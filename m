Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:38495 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752104AbcJTMJY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Oct 2016 08:09:24 -0400
Received: by mail-it0-f41.google.com with SMTP id 66so87212233itl.1
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Oct 2016 05:09:23 -0700 (PDT)
Subject: Re: Is it possible to speed up unlink()?
To: Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAGqmi779inZ8CcXpJ_uX1XXTGS_JrhKNagbL8ms6vA9eVZBFWQ@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <00101fd7-39e0-903c-5151-f2458259fd62@gmail.com>
Date: Thu, 20 Oct 2016 08:09:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAGqmi779inZ8CcXpJ_uX1XXTGS_JrhKNagbL8ms6vA9eVZBFWQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-10-20 05:29, Timofey Titovets wrote:
> Hi, i use btrfs for NFS VM replica storage and for NFS shared VM storage.
> At now i have a small problem what VM image deletion took to long time
> and NFS client show a timeout on deletion
> (ESXi Storage migration as example).
>
> Kernel: Linux nfs05 4.7.0-0.bpo.1-amd64 #1 SMP Debian 4.7.5-1~bpo8+2
> (2016-10-01) x86_64 GNU/Linux
> Mount options: noatime,compress-force=zlib,space_cache,commit=180
> Feature enabled:
> big_metadata:1
> compress_lzo:1
> extended_iref:1
> mixed_backref:1
> no_holes:1
> skinny_metadata:1
>
> AFAIK, unlink() return only when all references to all extents from
> unlinked inode will be deleted
> So with compression enabled files have a many many refs to each
> compressed chunk.
> So, it's possible to return unlink() early? or this a bad idea(and why)?
I may be completely off about this, but I could have sworn that unlink() 
returns when enough info is on the disk that both:
1. The file isn't actually visible in the directory.
2. If the system crashes, the filesystem will know to finish the cleanup.

Out of curiosity, what are the mount options (and export options) for 
the NFS share?  I have a feeling that that's also contributing.  In 
particular, if you're on a reliable network, forcing UDP for mounting 
can significantly help performance, and if your server is reliable, you 
can set NFS to run asynchronously to make unlink() return almost 
immediately.

Now, on top of that, you should probably look at adding 'lazytime' to 
the mount options for BTRFS.  This will cause updates to file 
time-stamps (not just atime, but mtime also, it has no net effect on 
ctime though, because a ctime update means something else in the inode 
got updated) to be deferred up to 24 hours or until the next time the 
inode would be written out, which can significantly improve performance 
on BTRFS because of the write-amplification.  It's not hugely likely to 
improve performance for unlink(), but it should improve write 
performance some, which may help in general.
