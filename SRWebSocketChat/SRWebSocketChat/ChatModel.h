//
//  ChatModel.h
//  SRWebSocketChat
//
//  Created by Madis on 16/5/14.
//
//

#import <Foundation/Foundation.h>

//@interface ChatModel : NSObject
//
//@end

@interface YYWeiboPictureMetadata : NSObject <NSCoding, NSCopying>
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) int cutType;
@end

@interface YYWeiboPicture : NSObject <NSCoding, NSCopying>
@property (nonatomic, strong) NSString *picID;
@property (nonatomic, strong) NSString *objectID;
@property (nonatomic, assign) int photoTag;
@property (nonatomic, assign) BOOL keepSize;
@property (nonatomic, strong) YYWeiboPictureMetadata *thumbnail;
@property (nonatomic, strong) YYWeiboPictureMetadata *bmiddle;
@property (nonatomic, strong) YYWeiboPictureMetadata *middlePlus;
@property (nonatomic, strong) YYWeiboPictureMetadata *large;
@property (nonatomic, strong) YYWeiboPictureMetadata *largest;
@property (nonatomic, strong) YYWeiboPictureMetadata *original;
@end

@interface YYWeiboURL : NSObject <NSCoding, NSCopying>
@property (nonatomic, assign) BOOL result;
@property (nonatomic, strong) NSString *shortURL;
@property (nonatomic, strong) NSString *oriURL;
@property (nonatomic, strong) NSString *urlTitle;
@property (nonatomic, strong) NSString *urlTypePic;
@property (nonatomic, assign) int32_t urlType;
@property (nonatomic, strong) NSString *log;
@property (nonatomic, strong) NSDictionary *actionLog;
@property (nonatomic, strong) NSString *pageID;
@property (nonatomic, strong) NSString *storageType;
@end

@interface YYWeiboUser : NSObject <NSCoding, NSCopying>
@property (nonatomic, assign) uint64_t userID;
@property (nonatomic, strong) NSString *idString;
@property (nonatomic, strong) NSString *genderString;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *domain;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, assign) int32_t followersCount;
@property (nonatomic, assign) int32_t friendsCount;
@property (nonatomic, assign) int32_t biFollowersCount;
@property (nonatomic, assign) int32_t favouritesCount;
@property (nonatomic, assign) int32_t statusesCount;
@property (nonatomic, assign) int32_t pagefriendsCount;
@property (nonatomic, assign) BOOL followMe;
@property (nonatomic, assign) BOOL following;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *profileImageURL;
@property (nonatomic, strong) NSString *avatarLarge;
@property (nonatomic, strong) NSString *avatarHD;
@property (nonatomic, strong) NSString *coverImage;
@property (nonatomic, strong) NSString *coverImagePhone;
@property (nonatomic, strong) NSString *profileURL;
@property (nonatomic, assign) int32_t type;
@property (nonatomic, assign) int32_t ptype;
@property (nonatomic, assign) int32_t mbtype;
@property (nonatomic, assign) int32_t urank;
@property (nonatomic, assign) int32_t uclass;
@property (nonatomic, assign) int32_t ulevel;
@property (nonatomic, assign) int32_t mbrank;
@property (nonatomic, assign) int32_t star;
@property (nonatomic, assign) int32_t level;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, assign) BOOL allowAllActMsg;
@property (nonatomic, assign) BOOL allowAllComment;
@property (nonatomic, assign) BOOL geoEnabled;
@property (nonatomic, assign) int32_t onlineStatus;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSArray *icons;
@property (nonatomic, strong) NSString *weihao;
@property (nonatomic, strong) NSString *badgeTop;
@property (nonatomic, assign) int32_t blockWord;
@property (nonatomic, assign) int32_t blockApp;
@property (nonatomic, assign) int32_t hasAbilityTag;
@property (nonatomic, assign) int32_t creditScore;
@property (nonatomic, strong) NSDictionary *badge;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, assign) int32_t userAbility;
@property (nonatomic, strong) NSDictionary *extend;
@property (nonatomic, assign) BOOL verified;
@property (nonatomic, assign) int32_t verifiedType;
@property (nonatomic, assign) int32_t verifiedLevel;
@property (nonatomic, assign) int32_t verifiedState;
@property (nonatomic, strong) NSString *verifiedContactEmail;
@property (nonatomic, strong) NSString *verifiedContactMobile;
@property (nonatomic, strong) NSString *verifiedTrade;
@property (nonatomic, strong) NSString *verifiedContactName;
@property (nonatomic, strong) NSString *verifiedSource;
@property (nonatomic, strong) NSString *verifiedSourceURL;
@property (nonatomic, strong) NSString *verifiedReason;
@property (nonatomic, strong) NSString *verifiedReasonURL;
@property (nonatomic, strong) NSString *verifiedReasonModified;
@end

@interface YYWeiboStatus : NSObject <NSCoding, NSCopying>
@property (nonatomic, assign) uint64_t statusID;
@property (nonatomic, strong) NSString *idstr;
@property (nonatomic, strong) NSString *mid;
@property (nonatomic, strong) NSString *rid;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) YYWeiboUser *user;
@property (nonatomic, assign) int32_t userType;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSArray *picIds;        /// Array<NSString>
@property (nonatomic, strong) NSDictionary *picInfos; /// Dic<NSString, YYWeiboPicture>
@property (nonatomic, strong) NSArray *urlStruct;     ///< Array<YYWeiboURL>
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) BOOL truncated;
@property (nonatomic, assign) int32_t repostsCount;
@property (nonatomic, assign) int32_t commentsCount;
@property (nonatomic, assign) int32_t attitudesCount;
@property (nonatomic, assign) int32_t attitudesStatus;
@property (nonatomic, assign) int32_t recomState;
@property (nonatomic, strong) NSString *inReplyToScreenName;
@property (nonatomic, strong) NSString *inReplyToStatusId;
@property (nonatomic, strong) NSString *inReplyToUserId;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, assign) int32_t sourceType;
@property (nonatomic, assign) int32_t sourceAllowClick;
@property (nonatomic, strong) NSString *geo;
@property (nonatomic, strong) NSArray *annotations;
@property (nonatomic, assign) int32_t bizFeature;
@property (nonatomic, assign) int32_t mlevel;
@property (nonatomic, strong) NSString *mblogid;
@property (nonatomic, strong) NSString *mblogTypeName;
@property (nonatomic, assign) int32_t mblogType;
@property (nonatomic, strong) NSString *scheme;
@property (nonatomic, strong) NSDictionary *visible;
@property (nonatomic, strong) NSArray *darwinTags;
@end

/// YYModel GHUser
@interface YYGHUser : NSObject <NSCoding>
@property (nonatomic, strong) NSString *login;
@property (nonatomic, assign) UInt64 userID;
@property (nonatomic, strong) NSString *avatarURL;
@property (nonatomic, strong) NSString *gravatarID;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *htmlURL;
@property (nonatomic, strong) NSString *followersURL;
@property (nonatomic, strong) NSString *followingURL;
@property (nonatomic, strong) NSString *gistsURL;
@property (nonatomic, strong) NSString *starredURL;
@property (nonatomic, strong) NSString *subscriptionsURL;
@property (nonatomic, strong) NSString *organizationsURL;
@property (nonatomic, strong) NSString *reposURL;
@property (nonatomic, strong) NSString *eventsURL;
@property (nonatomic, strong) NSString *receivedEventsURL;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) BOOL siteAdmin;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *blog;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *hireable;
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, assign) UInt32 publicRepos;
@property (nonatomic, assign) UInt32 publicGists;
@property (nonatomic, assign) UInt32 followers;
@property (nonatomic, assign) UInt32 following;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, strong) NSValue *test;
@end

@interface ChatModel : NSObject <NSCoding>
@property (nonatomic, assign) UInt64   userID;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *headImgURL;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) UInt64   messageCount;
@property (nonatomic, strong) NSDate   *sendDate;
@end

@interface ChatListModel : NSObject <NSCoding>
@property (nonatomic, strong) NSArray *messageArray;        /// Array<ChatModel>
@property (nonatomic, assign) UInt64   messageCount;
@end

@interface ChatDetailModel : NSObject <NSCoding>
@property (nonatomic, strong) NSArray *messageArray;        /// Array<ChatModel>
@property (nonatomic, assign) UInt64   fromUserID;
@property (nonatomic, strong) NSString *fromUserName;
@property (nonatomic, strong) NSString *fromHeadImgURL;
@property (nonatomic, assign) UInt64   toUserID;
@property (nonatomic, strong) NSString *toUserName;
@property (nonatomic, strong) NSString *toHeadImgURL;
//@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) UInt64   messageCount;
//@property (nonatomic, strong) NSDate   *sendDate;
@end
