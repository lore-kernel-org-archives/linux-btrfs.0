Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55993 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaGJXZI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jul 2014 19:25:08 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 04E913EE0C1
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Jul 2014 08:25:07 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.nic.fujitsu.com [10.0.50.92])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 05782AC04D7
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Jul 2014 08:25:06 +0900 (JST)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id B53B51DB8038
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Jul 2014 08:25:05 +0900 (JST)
Received: from g01jpexchkw36.g01.fujitsu.local (unknown [10.0.193.4])
	by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id 6CFB9692678
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Jul 2014 08:25:04 +0900 (JST)
Message-ID: <53BF20C4.2040308@jp.fujitsu.com>
Date: Fri, 11 Jul 2014 08:24:52 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <miaox@cn.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/4] btrfs-progs: Integrate error message output into
 find_mount_root().
References: <1404961513-14614-1-git-send-email-quwenruo@cn.fujitsu.com> <1404961513-14614-2-git-send-email-quwenruo@cn.fujitsu.com> <53BE41C3.1050804@jp.fujitsu.com> <53BE4A59.5010009@cn.fujitsu.com> <53BE4E4F.6040800@cn.fujitsu.com>
In-Reply-To: <53BE4E4F.6040800@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/07/10 17:26), Qu Wenruo wrote:
>
> -------- Original Message --------
> Subject: Re: [PATCH 2/4] btrfs-progs: Integrate error message output into find_mount_root().
> From: Miao Xie <miaox@cn.fujitsu.com>
> To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
> Date: 2014年07月10日 16:10
>> Takeuchi-san
>>
>> On Thu, 10 Jul 2014 16:33:23 +0900, Satoru Takeuchi wrote:
>>> (2014/07/10 12:05), Qu Wenruo wrote:
>>>> Before this patch, find_mount_root() and the caller both output error
>>>> message, which sometimes make the output duplicated and hard to judge
>>>> what the problem is.
>>>>
>>>> This pathh will integrate all the error messages output into
>>>> find_mount_root() to give more meaning error prompt and remove the
>>>> unneeded caller error messages.
>>>>
>>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>> ---
>>>>    cmds-receive.c   |  2 --
>>>>    cmds-send.c      |  8 +-------
>>>>    cmds-subvolume.c |  5 +----
>>>>    utils.c          | 15 ++++++++++++---
>>>>    4 files changed, 14 insertions(+), 16 deletions(-)
>>>>
>>>> diff --git a/cmds-receive.c b/cmds-receive.c
>>>> index 48380a5..084d97d 100644
>>>> --- a/cmds-receive.c
>>>> +++ b/cmds-receive.c
>>>> @@ -981,8 +981,6 @@ static int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd,
>>>>        ret = find_mount_root(dest_dir_full_path, &r->root_path);
>>>>        if (ret < 0) {
>>>>            ret = -EINVAL;
>>>> -        fprintf(stderr, "ERROR: failed to determine mount point "
>>>> -            "for %s\n", dest_dir_full_path);
>>>>            goto out;
>>>>        }
>>>>        r->mnt_fd = open(r->root_path, O_RDONLY | O_NOATIME);
>>>> diff --git a/cmds-send.c b/cmds-send.c
>>>> index 9a73b32..091f32b 100644
>>>> --- a/cmds-send.c
>>>> +++ b/cmds-send.c
>>>> @@ -357,8 +357,6 @@ static int init_root_path(struct btrfs_send *s, const char *subvol)
>>>>        ret = find_mount_root(subvol, &s->root_path);
>>>>        if (ret < 0) {
>>>>            ret = -EINVAL;
>>>> -        fprintf(stderr, "ERROR: failed to determine mount point "
>>>> -                "for %s\n", subvol);
>>>>            goto out;
>>>>        }
>>>> @@ -622,12 +620,8 @@ int cmd_send(int argc, char **argv)
>>>>            }
>>>>            ret = find_mount_root(subvol, &mount_root);
>>>> -        if (ret < 0) {
>>>> -            fprintf(stderr, "ERROR: find_mount_root failed on %s: "
>>>> -                    "%s\n", subvol,
>>>> -                strerror(-ret));
>>>> +        if (ret < 0)
>>>>                goto out;
>>>> -        }
>>>>            if (strcmp(send.root_path, mount_root) != 0) {
>>>>                ret = -EINVAL;
>>>>                fprintf(stderr, "ERROR: all subvols must be from the "
>>>> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
>>>> index 639fb10..b252eab 100644
>>>> --- a/cmds-subvolume.c
>>>> +++ b/cmds-subvolume.c
>>>> @@ -981,11 +981,8 @@ static int cmd_subvol_show(int argc, char **argv)
>>>>        }
>>>>        ret = find_mount_root(fullpath, &mnt);
>>>> -    if (ret < 0) {
>>>> -        fprintf(stderr, "ERROR: find_mount_root failed on %s: "
>>>> -                "%s\n", fullpath, strerror(-ret));
>>>> +    if (ret < 0)
>>>>            goto out;
>>>> -    }
>>>>        ret = 1;
>>>>        svpath = get_subvol_name(mnt, fullpath);
>>>> diff --git a/utils.c b/utils.c
>>>> index 507ec6c..07173ee 100644
>>>> --- a/utils.c
>>>> +++ b/utils.c
>>>> @@ -2417,13 +2417,19 @@ int find_mount_root(const char *path, char **mount_root)
>>>>        char *longest_match = NULL;
>>>>        fd = open(path, O_RDONLY | O_NOATIME);
>>>> -    if (fd < 0)
>>>> +    if (fd < 0) {
>>>> +        fprintf(stderr, "ERROR: Failed to open %s: %s\n",
>>>> +            path, strerror(errno));
>>> It drops part of original messages. It doesn't show this error
>>> is from find_mount_root(). I consider the original meaning keep as is.
>>> How do you think?
>> I think it is strange for the common users to show the name of a internal function.
>> Maybe we should introduce two kinds of the message, one is for the common users,
>> the other is for the developers to debug.
>>
>> Thanks
>> Miao
> I agree with Miao's idea.
> It's true that some developers needs to get info from the output,
> but IMO the error messages are often used to indicate what *users* do wrong,
> since most problem is caused by wrong parameter given by users.
>
> For example, I always forget to run 'btrfs fi df /mnt' and the 'Operation not permiited' message
> makes me realize the permission problem. And the function name or other messages are less
> important than that.
>
> On the other hand, if developers encounter problems, they will gdb the program or grep the source
> to find out the problem. So function name in error message seems not so demanding for me.

OK, I got it.

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

>
> It would also be a greate idea for adding new frame work to show debug message,
> but I'd prefer to make the frame some times later(Maybe when btrfs-progs become more comlicated than current?)

It's nice. I consider the messages of btrfs-progs are a bit messy.

Satoru

>
> Thanks,
> Qu
>
>
>>
>>> Thanks,
>>> Satoru
>>>
>>>>            return -errno;
>>>> +    }
>>>>        close(fd);
>>>>        mnttab = setmntent("/proc/self/mounts", "r");
>>>> -    if (!mnttab)
>>>> +    if (!mnttab) {
>>>> +        fprintf(stderr, "ERROR: Failed to setmntent: %s\n",
>>>> +            strerror(errno));
>>>>            return -errno;
>>>> +    }
>>>>        while ((ent = getmntent(mnttab))) {
>>>>            len = strlen(ent->mnt_dir);
>>>> @@ -2457,8 +2463,11 @@ int find_mount_root(const char *path, char **mount_root)
>>>>        ret = 0;
>>>>        *mount_root = realpath(longest_match, NULL);
>>>> -    if (!*mount_root)
>>>> +    if (!*mount_root) {
>>>> +        fprintf(stderr, "Failed to resolve path %s: %s\n",
>>>> +            longest_match, strerror(errno));
>>>>            ret = -errno;
>>>> +    }
>>>>        free(longest_match);
>>>>        return ret;
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>

