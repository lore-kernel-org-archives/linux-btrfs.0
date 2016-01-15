Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:40615 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756455AbcAOJdy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jan 2016 04:33:54 -0500
Subject: Re: [PATCH v4 17/18] btrfs: dedup: add a property handler for online
 dedup
To: <fdmanana@gmail.com>
References: <1452751054-2365-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1452751054-2365-18-git-send-email-quwenruo@cn.fujitsu.com>
 <CAL3q7H4-Ztmx9Z4=jNT3610Y6eZbL5GqZXXOajYg3FoP_uyxYA@mail.gmail.com>
 <56984D50.3040106@cn.fujitsu.com>
 <CAL3q7H4ZS_qj3VqiFmDkvCBZK8f34SQ-T3jCDQv-V+rXrpu8Ng@mail.gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5698BCF3.3020507@cn.fujitsu.com>
Date: Fri, 15 Jan 2016 17:33:39 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H4ZS_qj3VqiFmDkvCBZK8f34SQ-T3jCDQv-V+rXrpu8Ng@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Filipe Manana wrote on 2016/01/15 09:19 +0000:
> On Fri, Jan 15, 2016 at 1:37 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>
>>
>> Filipe Manana wrote on 2016/01/14 09:56 +0000:
>>>
>>> On Thu, Jan 14, 2016 at 5:57 AM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> wrote:
>>>>
>>>> From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>>>>
>>>> We use btrfs extended attribute "btrfs.dedup" to record per-file online
>>>> dedup status, so add a dedup property handler.
>>>>
>>>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>>>> ---
>>>>    fs/btrfs/props.c | 40 ++++++++++++++++++++++++++++++++++++++++
>>>>    1 file changed, 40 insertions(+)
>>>>
>>>> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
>>>> index f9e6023..ae8b76d 100644
>>>> --- a/fs/btrfs/props.c
>>>> +++ b/fs/btrfs/props.c
>>>> @@ -41,6 +41,10 @@ static int prop_compression_apply(struct inode *inode,
>>>>                                     size_t len);
>>>>    static const char *prop_compression_extract(struct inode *inode);
>>>>
>>>> +static int prop_dedup_validate(const char *value, size_t len);
>>>> +static int prop_dedup_apply(struct inode *inode, const char *value,
>>>> size_t len);
>>>> +static const char *prop_dedup_extract(struct inode *inode);
>>>> +
>>>>    static struct prop_handler prop_handlers[] = {
>>>>           {
>>>>                   .xattr_name = XATTR_BTRFS_PREFIX "compression",
>>>> @@ -49,6 +53,13 @@ static struct prop_handler prop_handlers[] = {
>>>>                   .extract = prop_compression_extract,
>>>>                   .inheritable = 1
>>>>           },
>>>> +       {
>>>> +               .xattr_name = XATTR_BTRFS_PREFIX "dedup",
>>>> +               .validate = prop_dedup_validate,
>>>> +               .apply = prop_dedup_apply,
>>>> +               .extract = prop_dedup_extract,
>>>> +               .inheritable = 1
>>>> +       },
>>>>    };
>>>>
>>>>    void __init btrfs_props_init(void)
>>>> @@ -425,4 +436,33 @@ static const char *prop_compression_extract(struct
>>>> inode *inode)
>>>>           return NULL;
>>>>    }
>>>>
>>>> +static int prop_dedup_validate(const char *value, size_t len)
>>>> +{
>>>> +       if (!strncmp("disable", value, len))
>>>> +               return 0;
>>>> +
>>>> +       return -EINVAL;
>>>> +}
>>>> +
>>>> +static int prop_dedup_apply(struct inode *inode, const char *value,
>>>> size_t len)
>>>> +{
>>>> +       if (len == 0) {
>>>> +               BTRFS_I(inode)->flags &= ~BTRFS_INODE_NODEDUP;
>>>> +               return 0;
>>>> +       }
>>>> +
>>>> +       if (!strncmp("disable", value, len)) {
>>>> +               BTRFS_I(inode)->flags |= BTRFS_INODE_NODEDUP;
>>>> +               return 0;
>>>> +       }
>>>> +
>>>> +       return -EINVAL;
>>>> +}
>>>> +
>>>> +static const char *prop_dedup_extract(struct inode *inode)
>>>> +{
>>>> +       if (BTRFS_I(inode)->flags | BTRFS_INODE_NODEDUP)
>>>> +               return "disable";
>>>
>>>
>>> | -> &
>>>
>>> How about writing test cases (for xfstests)? Not only for the property
>>> but for the whole dedup feature, it would avoid such simple
>>> mistakes...
>>
>>
>> Yes, it's already in our schedule and we have some internal simple test
>> case.
>>
>> But the problem is,
>> Some behavior/format is not completely determined yet
>> Especially for on-disk format (ondisk backend only), and ioctl interface.
>
> How does someone guesses that? You could add an RFC tag to the patches...
>
>>
>> So I'm a little concerned about submit them too early before we made final
>> decision on the ioctl interface.
>
> What's the problem? You can submit such tests only to the btrfs list
> for now and tag them as RFC and mention that.

Wow, I never though xfstest patches can be submitted to btrfs maillist 
only!!

What a wonderful idea for RFC features like dedup!

I'll soon add such test cases.

Great thanks for such advice!
Qu

>
>>
>>> Take a look at the good example of xfs development. For example when
>>> all the recent patches for their reflink implementation was posted
>>> (and before getting merged), a comprehensive set of test cases for
>>> xfstests was also posted...
>>
>>
>> Yes, test driven development is very nice, but there is also problem,
>> especially for btrfs, like btrfs/047 which needs btrfs send --stream-version
>> support.
>
> Yes, this one was a special case in that around 2 years ago it seemed
> the functionality was going to be merged, but it ended up not being
> merged due to reasons not known to me (no reasons pointed in the
> mailing list nor in private).
>
> Better have unused tests instead of features without tests (and many
> btrfs specific features had no tests or almost nothing not that long
> ago).
>
>>
>> But unfortunately, there is not --stream-version support in upsteam
>> btrfs-progs and the test case never get executed on upsteam btrfs-progs.
>>
>> Personally speaking, xfs development can only happen in that way because
>> xfstest maintainer is also the maintainer of xfs.
>> As Dave knows every aspect of xfs and can determine which feature will be
>> merged.
>
> He can also accept patches to remove tests or change them...
> Shouldn't be an excuse to not share tests along with patches for new
> features, as noted above.
>
>> But that's not true for btrfs, so he can merge wrong patch and cause
>> inconsistent with what btrfs really supports between test cases.
>>
>> Thanks,
>> Qu
>>
>>
>>>
>>>>
>>>> +       return NULL;
>>>> +}
>>>> --
>>>> 2.7.0
>>>>
>>>>
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>>
>>>
>>
>>
>
>
>


