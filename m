Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:61980 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935920AbdI0Amo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 20:42:44 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 96AACAC0097
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Sep 2017 09:42:35 +0900 (JST)
Subject: Re: [PATCH 3/4] btrfs-progs: change seen_fsid to hold fd and DIR*
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>
References: <8c494134-ce71-4ca7-dc91-06d36774cc84@jp.fujitsu.com>
 <b490f6d6-b96f-c295-7729-c85272508550@jp.fujitsu.com>
 <c48c8132-686b-ba76-00d7-fb2539bebae6@gmx.com>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Message-ID: <9c152273-0fb0-9919-9199-0249bdbc0d55@jp.fujitsu.com>
Date: Wed, 27 Sep 2017 09:42:29 +0900
MIME-Version: 1.0
In-Reply-To: <c48c8132-686b-ba76-00d7-fb2539bebae6@gmx.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017/09/26 22:08, Qu Wenruo wrote:
> 
> 
> On 2017年09月26日 13:45, Misono, Tomohiro wrote:
>> Change seen_fsid to hold fd and DIR* in order to keep access to each fs.
>> This will be used for 'subvol delete --commit-after'.
> 
> It is already quite good, good enough for the fix.
> 
> However just a small point can be further enhanced, commended below.
> 
>>
>> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
>> ---
>>   cmds-filesystem.c | 4 ++--
>>   utils.c           | 6 +++++-
>>   utils.h           | 5 ++++-
>>   3 files changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
>> index c7dae40..4bbff43 100644
>> --- a/cmds-filesystem.c
>> +++ b/cmds-filesystem.c
>> @@ -277,7 +277,7 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices,
>>   	u64 devs_found = 0;
>>   	u64 total;
>>   
>> -	if (add_seen_fsid(fs_devices->fsid, seen_fsid_hash))
>> +	if (add_seen_fsid(fs_devices->fsid, seen_fsid_hash, -1, NULL))
>>   		return;
>>   
>>   	uuid_unparse(fs_devices->fsid, uuidbuf);
>> @@ -324,7 +324,7 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
>>   	struct btrfs_ioctl_dev_info_args *tmp_dev_info;
>>   	int ret;
>>   
>> -	ret = add_seen_fsid(fs_info->fsid, seen_fsid_hash);
>> +	ret = add_seen_fsid(fs_info->fsid, seen_fsid_hash, -1, NULL);
>>   	if (ret == -EEXIST)
>>   		return 0;
>>   	else if (ret)
>> diff --git a/utils.c b/utils.c
>> index f91d41e..bdfbfe0 100644
>> --- a/utils.c
>> +++ b/utils.c
>> @@ -1804,7 +1804,8 @@ int is_seen_fsid(u8 *fsid, struct seen_fsid *seen_fsid_hash[])
>>   	return 0;
>>   }
>>   
>> -int add_seen_fsid(u8 *fsid, struct seen_fsid *seen_fsid_hash[])
>> +int add_seen_fsid(u8 *fsid, struct seen_fsid *seen_fsid_hash[],
>> +		int fd, DIR *dirstream)
>>   {
>>   	u8 hash = fsid[0];
>>   	int slot = hash % SEEN_FSID_HASH_SIZE;
>> @@ -1832,6 +1833,8 @@ insert:
>>   
>>   	alloc->next = NULL;
>>   	memcpy(alloc->fsid, fsid, BTRFS_FSID_SIZE);
>> +	alloc->fd = fd;
>> +	alloc->dirstream = dirstream;
>>   
>>   	if (seen)
>>   		seen->next = alloc;
>> @@ -1851,6 +1854,7 @@ void free_seen_fsid(struct seen_fsid *seen_fsid_hash[])
>>   		seen = seen_fsid_hash[slot];
>>   		while (seen) {
>>   			next = seen->next;
>> +			close_file_or_dir(seen->fd, seen->dirstream);
>>   			free(seen);
>>   			seen = next;
>>   		}
>> diff --git a/utils.h b/utils.h
>> index da34e6c..bac7688 100644
>> --- a/utils.h
>> +++ b/utils.h
>> @@ -107,9 +107,12 @@ int get_fsid(const char *path, u8 *fsid, int silent);
>>   struct seen_fsid {
>>   	u8 fsid[BTRFS_FSID_SIZE];
>>   	struct seen_fsid *next;
>> +	int fd;
> 
> Will it be possible that the final fd recorded here is invalid or some 
> other reason that we failed to execute SYNC ioctl on that fd, but can 
> succeeded with other fd?
> 
> In that case, a list of fd will help.
> 
> Thanks,
> Qu
> 
Hello,

I think fd will not be invalidated unless user does because open is
succeeded. Also, if SYNC is failed for one fd, it would fail for other fds
too. So, I think there is no need to keep several fds. What do you think?

By the way, thanks for reviewing whole patches and comments.
I will splits the cleanup for the fourth patch.

Regards,
Tomohiro

>> +	DIR *dirstream;
>>   };
>>   int is_seen_fsid(u8 *fsid, struct seen_fsid *seen_fsid_hash[]);
>> -int add_seen_fsid(u8 *fsid, struct seen_fsid *seen_fsid_hash[]);
>> +int add_seen_fsid(u8 *fsid, struct seen_fsid *seen_fsid_hash[],
>> +		int fd, DIR *dirstream);
>>   void free_seen_fsid(struct seen_fsid *seen_fsid_hash[]);
>>   
>>   int get_label(const char *btrfs_dev, char *label);
>>
> 
> 

