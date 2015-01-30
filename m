Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62777 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752285AbbA3CUz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Jan 2015 21:20:55 -0500
Message-ID: <54CAEA83.3080908@cn.fujitsu.com>
Date: Fri, 30 Jan 2015 10:20:51 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH RESEND v4 6/8] vfs: Add get_vfsmount_sb() function to
 get vfsmount from a given sb.
References: <1422498281-20493-1-git-send-email-quwenruo@cn.fujitsu.com> <1422498281-20493-7-git-send-email-quwenruo@cn.fujitsu.com> <20150129123758.GJ3641@twin.jikos.cz> <20150129152347.GE29656@ZenIV.linux.org.uk> <54CADA3E.6050306@cn.fujitsu.com> <20150130020902.GG29656@ZenIV.linux.org.uk>
In-Reply-To: <20150130020902.GG29656@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH RESEND v4 6/8] vfs: Add get_vfsmount_sb() function 
to get vfsmount from a given sb.
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年01月30日 10:09
> On Fri, Jan 30, 2015 at 09:11:26AM +0800, Qu Wenruo wrote:
>> For the mounted ro case, that's not a problem, since if one instance
>> is mounted ro,
>> other instances are also mounted ro, so that's not a problem.
> Not really.
>
> root@satch:~# cd /tmp/
> root@satch:~# mkdir /tm/a
> root@satch:~# mount --bind /tmp/ /tmp/a
> root@satch:~# mount --bind -o remount,ro /tmp/a
> root@satch:~# mkdir /tmp/b
> root@satch:~# mkdir /tmp/a/c
> mkdir: cannot create directory '/tmp/a/c': Read-only file system
> root@satch:~# stat /tmp/b /tmp/a/b
>    File: '/tmp/b'
>    Size: 4096            Blocks: 8          IO Block: 4096   directory
> Device: 806h/2054d      Inode: 257537      Links: 2
> Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
> Access: 2015-01-29 21:03:35.000000000 -0500
> Modify: 2015-01-29 21:03:35.000000000 -0500
> Change: 2015-01-29 21:03:35.000000000 -0500
>   Birth: -
>    File: '/tmp/a/b'
>    Size: 4096            Blocks: 8          IO Block: 4096   directory
> Device: 806h/2054d      Inode: 257537      Links: 2
> Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
> Access: 2015-01-29 21:03:35.000000000 -0500
> Modify: 2015-01-29 21:03:35.000000000 -0500
> Change: 2015-01-29 21:03:35.000000000 -0500
>   Birth: -
> root@satch:~#
>
> IOW, /tmp and /tmp/a bear the same filesystem (one from /dev/sda6), the former
> is mounted r/w, the latter - r/o.
Oh, bind mount.....

I was so stupid to forget bind.
>
>>> Assuming that your superblock is guaranteed to stay alive and usable for
>>> whatever work you are trying to do, what's wrong with sb_want_write()?
>> Did you mean change the function name and it's parameter to
>> sb_want_write(sb) and sb_drop_write(sb).
>> That looks much better.
>> But I'm a little worried about just using sb_start_write() and
>> s_readonly_remount/s_flags to do the protection,
>> will it be enough?
> Protection against what?  If superblock is r/w, it will stay r/w until you
> do sb_drop_write(); if it's r/o, sb_want_write() will fail.  There might be
> any number of vfsmounts over superblock; attempt to get write access via
> vfsmount will succeed only of both the vfsmount and superblock are r/w -
> mnt_want_write() does sb_want_write() and fails if that has failed.
Nice.
I'll add sb_want_write() and sb_drop_write().

Tons of thanks for all your advice!
Qu
