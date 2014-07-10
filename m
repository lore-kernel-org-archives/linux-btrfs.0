Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56549 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752010AbaGJI1B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jul 2014 04:27:01 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6A8QvMS010306
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 16:26:57 +0800
Message-ID: <53BE4E4F.6040800@cn.fujitsu.com>
Date: Thu, 10 Jul 2014 16:26:55 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <miaox@cn.fujitsu.com>, Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/4] btrfs-progs: Integrate error message output into
 find_mount_root().
References: <1404961513-14614-1-git-send-email-quwenruo@cn.fujitsu.com> <1404961513-14614-2-git-send-email-quwenruo@cn.fujitsu.com> <53BE41C3.1050804@jp.fujitsu.com> <53BE4A59.5010009@cn.fujitsu.com>
In-Reply-To: <53BE4A59.5010009@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH 2/4] btrfs-progs: Integrate error message output 
into find_mount_root().
From: Miao Xie <miaox@cn.fujitsu.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>, Qu Wenruo 
<quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Date: 2014年07月10日 16:10
> Takeuchi-san
>
> On Thu, 10 Jul 2014 16:33:23 +0900, Satoru Takeuchi wrote:
>> (2014/07/10 12:05), Qu Wenruo wrote:
>>> Before this patch, find_mount_root() and the caller both output error
>>> message, which sometimes make the output duplicated and hard to judge
>>> what the problem is.
>>>
>>> This pathh will integrate all the error messages output into
>>> find_mount_root() to give more meaning error prompt and remove the
>>> unneeded caller error messages.
>>>
>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> ---
>>>    cmds-receive.c   |  2 --
>>>    cmds-send.c      |  8 +-------
>>>    cmds-subvolume.c |  5 +----
>>>    utils.c          | 15 ++++++++++++---
>>>    4 files changed, 14 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/cmds-receive.c b/cmds-receive.c
>>> index 48380a5..084d97d 100644
>>> --- a/cmds-receive.c
>>> +++ b/cmds-receive.c
>>> @@ -981,8 +981,6 @@ static int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd,
>>>    	ret = find_mount_root(dest_dir_full_path, &r->root_path);
>>>    	if (ret < 0) {
>>>    		ret = -EINVAL;
>>> -		fprintf(stderr, "ERROR: failed to determine mount point "
>>> -			"for %s\n", dest_dir_full_path);
>>>    		goto out;
>>>    	}
>>>    	r->mnt_fd = open(r->root_path, O_RDONLY | O_NOATIME);
>>> diff --git a/cmds-send.c b/cmds-send.c
>>> index 9a73b32..091f32b 100644
>>> --- a/cmds-send.c
>>> +++ b/cmds-send.c
>>> @@ -357,8 +357,6 @@ static int init_root_path(struct btrfs_send *s, const char *subvol)
>>>    	ret = find_mount_root(subvol, &s->root_path);
>>>    	if (ret < 0) {
>>>    		ret = -EINVAL;
>>> -		fprintf(stderr, "ERROR: failed to determine mount point "
>>> -				"for %s\n", subvol);
>>>    		goto out;
>>>    	}
>>>    
>>> @@ -622,12 +620,8 @@ int cmd_send(int argc, char **argv)
>>>    		}
>>>    
>>>    		ret = find_mount_root(subvol, &mount_root);
>>> -		if (ret < 0) {
>>> -			fprintf(stderr, "ERROR: find_mount_root failed on %s: "
>>> -					"%s\n", subvol,
>>> -				strerror(-ret));
>>> +		if (ret < 0)
>>>    			goto out;
>>> -		}
>>>    		if (strcmp(send.root_path, mount_root) != 0) {
>>>    			ret = -EINVAL;
>>>    			fprintf(stderr, "ERROR: all subvols must be from the "
>>> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
>>> index 639fb10..b252eab 100644
>>> --- a/cmds-subvolume.c
>>> +++ b/cmds-subvolume.c
>>> @@ -981,11 +981,8 @@ static int cmd_subvol_show(int argc, char **argv)
>>>    	}
>>>    
>>>    	ret = find_mount_root(fullpath, &mnt);
>>> -	if (ret < 0) {
>>> -		fprintf(stderr, "ERROR: find_mount_root failed on %s: "
>>> -				"%s\n", fullpath, strerror(-ret));
>>> +	if (ret < 0)
>>>    		goto out;
>>> -	}
>>>    	ret = 1;
>>>    	svpath = get_subvol_name(mnt, fullpath);
>>>    
>>> diff --git a/utils.c b/utils.c
>>> index 507ec6c..07173ee 100644
>>> --- a/utils.c
>>> +++ b/utils.c
>>> @@ -2417,13 +2417,19 @@ int find_mount_root(const char *path, char **mount_root)
>>>    	char *longest_match = NULL;
>>>    
>>>    	fd = open(path, O_RDONLY | O_NOATIME);
>>> -	if (fd < 0)
>>> +	if (fd < 0) {
>>> +		fprintf(stderr, "ERROR: Failed to open %s: %s\n",
>>> +			path, strerror(errno));
>> It drops part of original messages. It doesn't show this error
>> is from find_mount_root(). I consider the original meaning keep as is.
>> How do you think?
> I think it is strange for the common users to show the name of a internal function.
> Maybe we should introduce two kinds of the message, one is for the common users,
> the other is for the developers to debug.
>
> Thanks
> Miao
I agree with Miao's idea.
It's true that some developers needs to get info from the output,
but IMO the error messages are often used to indicate what *users* do wrong,
since most problem is caused by wrong parameter given by users.

For example, I always forget to run 'btrfs fi df /mnt' and the 
'Operation not permiited' message
makes me realize the permission problem. And the function name or other 
messages are less
important than that.

On the other hand, if developers encounter problems, they will gdb the 
program or grep the source
to find out the problem. So function name in error message seems not so 
demanding for me.

It would also be a greate idea for adding new frame work to show debug 
message,
but I'd prefer to make the frame some times later(Maybe when btrfs-progs 
become more comlicated than current?)

Thanks,
Qu


>
>> Thanks,
>> Satoru
>>
>>>    		return -errno;
>>> +	}
>>>    	close(fd);
>>>    
>>>    	mnttab = setmntent("/proc/self/mounts", "r");
>>> -	if (!mnttab)
>>> +	if (!mnttab) {
>>> +		fprintf(stderr, "ERROR: Failed to setmntent: %s\n",
>>> +			strerror(errno));
>>>    		return -errno;
>>> +	}
>>>    
>>>    	while ((ent = getmntent(mnttab))) {
>>>    		len = strlen(ent->mnt_dir);
>>> @@ -2457,8 +2463,11 @@ int find_mount_root(const char *path, char **mount_root)
>>>    
>>>    	ret = 0;
>>>    	*mount_root = realpath(longest_match, NULL);
>>> -	if (!*mount_root)
>>> +	if (!*mount_root) {
>>> +		fprintf(stderr, "Failed to resolve path %s: %s\n",
>>> +			longest_match, strerror(errno));
>>>    		ret = -errno;
>>> +	}
>>>    
>>>    	free(longest_match);
>>>    	return ret;
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

