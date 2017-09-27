Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:60612 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030619AbdI0Aw7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 20:52:59 -0400
Subject: Re: [PATCH 3/4] btrfs-progs: change seen_fsid to hold fd and DIR*
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <8c494134-ce71-4ca7-dc91-06d36774cc84@jp.fujitsu.com>
 <b490f6d6-b96f-c295-7729-c85272508550@jp.fujitsu.com>
 <c48c8132-686b-ba76-00d7-fb2539bebae6@gmx.com>
 <9c152273-0fb0-9919-9199-0249bdbc0d55@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <20072a8b-bb1b-0a8e-c6ff-8e0111a835cb@gmx.com>
Date: Wed, 27 Sep 2017 08:52:49 +0800
MIME-Version: 1.0
In-Reply-To: <9c152273-0fb0-9919-9199-0249bdbc0d55@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月27日 08:42, Misono, Tomohiro wrote:
> On 2017/09/26 22:08, Qu Wenruo wrote:
>>
>>
>> On 2017年09月26日 13:45, Misono, Tomohiro wrote:
>>> Change seen_fsid to hold fd and DIR* in order to keep access to each fs.
>>> This will be used for 'subvol delete --commit-after'.
>>
>> It is already quite good, good enough for the fix.
>>
>> However just a small point can be further enhanced, commended below.
>>
>>>
>>> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
>>> ---
>>>    cmds-filesystem.c | 4 ++--
>>>    utils.c           | 6 +++++-
>>>    utils.h           | 5 ++++-
>>>    3 files changed, 11 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
>>> index c7dae40..4bbff43 100644
>>> --- a/cmds-filesystem.c
>>> +++ b/cmds-filesystem.c
>>> @@ -277,7 +277,7 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices,
>>>    	u64 devs_found = 0;
>>>    	u64 total;
>>>    
>>> -	if (add_seen_fsid(fs_devices->fsid, seen_fsid_hash))
>>> +	if (add_seen_fsid(fs_devices->fsid, seen_fsid_hash, -1, NULL))
>>>    		return;
>>>    
>>>    	uuid_unparse(fs_devices->fsid, uuidbuf);
>>> @@ -324,7 +324,7 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
>>>    	struct btrfs_ioctl_dev_info_args *tmp_dev_info;
>>>    	int ret;
>>>    
>>> -	ret = add_seen_fsid(fs_info->fsid, seen_fsid_hash);
>>> +	ret = add_seen_fsid(fs_info->fsid, seen_fsid_hash, -1, NULL);
>>>    	if (ret == -EEXIST)
>>>    		return 0;
>>>    	else if (ret)
>>> diff --git a/utils.c b/utils.c
>>> index f91d41e..bdfbfe0 100644
>>> --- a/utils.c
>>> +++ b/utils.c
>>> @@ -1804,7 +1804,8 @@ int is_seen_fsid(u8 *fsid, struct seen_fsid *seen_fsid_hash[])
>>>    	return 0;
>>>    }
>>>    
>>> -int add_seen_fsid(u8 *fsid, struct seen_fsid *seen_fsid_hash[])
>>> +int add_seen_fsid(u8 *fsid, struct seen_fsid *seen_fsid_hash[],
>>> +		int fd, DIR *dirstream)
>>>    {
>>>    	u8 hash = fsid[0];
>>>    	int slot = hash % SEEN_FSID_HASH_SIZE;
>>> @@ -1832,6 +1833,8 @@ insert:
>>>    
>>>    	alloc->next = NULL;
>>>    	memcpy(alloc->fsid, fsid, BTRFS_FSID_SIZE);
>>> +	alloc->fd = fd;
>>> +	alloc->dirstream = dirstream;
>>>    
>>>    	if (seen)
>>>    		seen->next = alloc;
>>> @@ -1851,6 +1854,7 @@ void free_seen_fsid(struct seen_fsid *seen_fsid_hash[])
>>>    		seen = seen_fsid_hash[slot];
>>>    		while (seen) {
>>>    			next = seen->next;
>>> +			close_file_or_dir(seen->fd, seen->dirstream);
>>>    			free(seen);
>>>    			seen = next;
>>>    		}
>>> diff --git a/utils.h b/utils.h
>>> index da34e6c..bac7688 100644
>>> --- a/utils.h
>>> +++ b/utils.h
>>> @@ -107,9 +107,12 @@ int get_fsid(const char *path, u8 *fsid, int silent);
>>>    struct seen_fsid {
>>>    	u8 fsid[BTRFS_FSID_SIZE];
>>>    	struct seen_fsid *next;
>>> +	int fd;
>>
>> Will it be possible that the final fd recorded here is invalid or some
>> other reason that we failed to execute SYNC ioctl on that fd, but can
>> succeeded with other fd?
>>
>> In that case, a list of fd will help.
>>
>> Thanks,
>> Qu
>>
> Hello,
> 
> I think fd will not be invalidated unless user does because open is
> succeeded. Also, if SYNC is failed for one fd, it would fail for other fds
> too. So, I think there is no need to keep several fds. What do you think?

Makes sense.

So I'm OK using current method.
Feel free to add my reviewed-by tag.

Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>

Thanks,
Qu

> 
> By the way, thanks for reviewing whole patches and comments.
> I will splits the cleanup for the fourth patch.
> 
> Regards,
> Tomohiro
> 
>>> +	DIR *dirstream;
>>>    };
>>>    int is_seen_fsid(u8 *fsid, struct seen_fsid *seen_fsid_hash[]);
>>> -int add_seen_fsid(u8 *fsid, struct seen_fsid *seen_fsid_hash[]);
>>> +int add_seen_fsid(u8 *fsid, struct seen_fsid *seen_fsid_hash[],
>>> +		int fd, DIR *dirstream);
>>>    void free_seen_fsid(struct seen_fsid *seen_fsid_hash[]);
>>>    
>>>    int get_label(const char *btrfs_dev, char *label);
>>>
>>
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
