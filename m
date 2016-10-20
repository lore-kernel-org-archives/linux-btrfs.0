Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:33837 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932160AbcJTNrp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Oct 2016 09:47:45 -0400
Received: by mail-qk0-f175.google.com with SMTP id f128so91336395qkb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Oct 2016 06:47:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <00101fd7-39e0-903c-5151-f2458259fd62@gmail.com>
References: <CAGqmi779inZ8CcXpJ_uX1XXTGS_JrhKNagbL8ms6vA9eVZBFWQ@mail.gmail.com>
 <00101fd7-39e0-903c-5151-f2458259fd62@gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Thu, 20 Oct 2016 16:47:03 +0300
Message-ID: <CAGqmi772=Z6YMZdrc14ZoRNQpEtd2MHuapgE2wzWPCjwfC_bFQ@mail.gmail.com>
Subject: Re: Is it possible to speed up unlink()?
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-10-20 15:09 GMT+03:00 Austin S. Hemmelgarn <ahferroin7@gmail.com>:
> On 2016-10-20 05:29, Timofey Titovets wrote:
>>
>> Hi, i use btrfs for NFS VM replica storage and for NFS shared VM storage.
>> At now i have a small problem what VM image deletion took to long time
>> and NFS client show a timeout on deletion
>> (ESXi Storage migration as example).
>>
>> Kernel: Linux nfs05 4.7.0-0.bpo.1-amd64 #1 SMP Debian 4.7.5-1~bpo8+2
>> (2016-10-01) x86_64 GNU/Linux
>> Mount options: noatime,compress-force=zlib,space_cache,commit=180
>> Feature enabled:
>> big_metadata:1
>> compress_lzo:1
>> extended_iref:1
>> mixed_backref:1
>> no_holes:1
>> skinny_metadata:1
>>
>> AFAIK, unlink() return only when all references to all extents from
>> unlinked inode will be deleted
>> So with compression enabled files have a many many refs to each
>> compressed chunk.
>> So, it's possible to return unlink() early? or this a bad idea(and why)?
>
> I may be completely off about this, but I could have sworn that unlink()
> returns when enough info is on the disk that both:
> 1. The file isn't actually visible in the directory.
> 2. If the system crashes, the filesystem will know to finish the cleanup.
>
> Out of curiosity, what are the mount options (and export options) for the
> NFS share?  I have a feeling that that's also contributing.  In particular,
> if you're on a reliable network, forcing UDP for mounting can significantly
> help performance, and if your server is reliable, you can set NFS to run
> asynchronously to make unlink() return almost immediately.


For NFS export i use:
rw,no_root_squash,async,no_subtree_check,fsid=1
AFAIK ESXi don't support nfs with udp
And you right on normal Linux client async work pretty good and
deletion of big file are pretty fast (but also it's can lock nfsd on
nfs server for long time, while he do unlink()).

> Now, on top of that, you should probably look at adding 'lazytime' to the
> mount options for BTRFS.  This will cause updates to file time-stamps (not
> just atime, but mtime also, it has no net effect on ctime though, because a
> ctime update means something else in the inode got updated) to be deferred
> up to 24 hours or until the next time the inode would be written out, which
> can significantly improve performance on BTRFS because of the
> write-amplification.  It's not hugely likely to improve performance for
> unlink(), but it should improve write performance some, which may help in
> general.

Thanks for lazytime i forgot about it %)
On my debian servers i can't apply it with error:
BTRFS info (device sdc1): unrecognized mount option 'lazytime'
But successful apply it to my arch box (Linux 4.8.2)

For fast unlink(), i just think about subvolume like behaviour, then
it's possible to fast delete subvolume (without commit) and then
kernel will clean data in the background.

-- 
Have a nice day,
Timofey.
