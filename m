Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:36264 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941143AbcJTRdP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Oct 2016 13:33:15 -0400
Received: by mail-yw0-f174.google.com with SMTP id u124so63233047ywg.3
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Oct 2016 10:33:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b3bfee72-8926-f9ef-cd05-3e0aef5ee4b8@gmail.com>
References: <CAGqmi779inZ8CcXpJ_uX1XXTGS_JrhKNagbL8ms6vA9eVZBFWQ@mail.gmail.com>
 <00101fd7-39e0-903c-5151-f2458259fd62@gmail.com> <CAGqmi772=Z6YMZdrc14ZoRNQpEtd2MHuapgE2wzWPCjwfC_bFQ@mail.gmail.com>
 <b3bfee72-8926-f9ef-cd05-3e0aef5ee4b8@gmail.com>
From: ronnie sahlberg <ronniesahlberg@gmail.com>
Date: Thu, 20 Oct 2016 10:33:13 -0700
Message-ID: <CAN05THT+6y4-eQd7RkMNr_XUz7Pp6jEqXfpZARuHaTdkM7-8vQ@mail.gmail.com>
Subject: Re: Is it possible to speed up unlink()?
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 20, 2016 at 7:44 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-10-20 09:47, Timofey Titovets wrote:
>>
>> 2016-10-20 15:09 GMT+03:00 Austin S. Hemmelgarn <ahferroin7@gmail.com>:
>>>
>>> On 2016-10-20 05:29, Timofey Titovets wrote:
>>>>
>>>>
>>>> Hi, i use btrfs for NFS VM replica storage and for NFS shared VM
>>>> storage.
>>>> At now i have a small problem what VM image deletion took to long time
>>>> and NFS client show a timeout on deletion
>>>> (ESXi Storage migration as example).
>>>>
>>>> Kernel: Linux nfs05 4.7.0-0.bpo.1-amd64 #1 SMP Debian 4.7.5-1~bpo8+2
>>>> (2016-10-01) x86_64 GNU/Linux
>>>> Mount options: noatime,compress-force=zlib,space_cache,commit=180
>>>> Feature enabled:
>>>> big_metadata:1
>>>> compress_lzo:1
>>>> extended_iref:1
>>>> mixed_backref:1
>>>> no_holes:1
>>>> skinny_metadata:1
>>>>
>>>> AFAIK, unlink() return only when all references to all extents from
>>>> unlinked inode will be deleted
>>>> So with compression enabled files have a many many refs to each
>>>> compressed chunk.
>>>> So, it's possible to return unlink() early? or this a bad idea(and why)?
>>>
>>>
>>> I may be completely off about this, but I could have sworn that unlink()
>>> returns when enough info is on the disk that both:
>>> 1. The file isn't actually visible in the directory.
>>> 2. If the system crashes, the filesystem will know to finish the cleanup.
>>>
>>> Out of curiosity, what are the mount options (and export options) for the
>>> NFS share?  I have a feeling that that's also contributing.  In
>>> particular,
>>> if you're on a reliable network, forcing UDP for mounting can
>>> significantly
>>> help performance, and if your server is reliable, you can set NFS to run
>>> asynchronously to make unlink() return almost immediately.
>>
>>
>>
>> For NFS export i use:
>> rw,no_root_squash,async,no_subtree_check,fsid=1
>> AFAIK ESXi don't support nfs with udp
>
> That doesn't surprise me.  If there's any chance of packet loss, then NFS
> over UDP risks data corruption, so a lot of 'professional' software only
> supports NFS over TCP.  The thing is though, in a vast majority of networks
> ESXi would be running in, there's functionally zero chance of packet loss
> unless there's a hardware failure.
>>
>> And you right on normal Linux client async work pretty good and
>> deletion of big file are pretty fast (but also it's can lock nfsd on
>> nfs server for long time, while he do unlink()).
>
> You might also try with NFS-Ganesha instead of the Linux kernel NFS server.
> It scales a whole lot better and tends to be a bit smarter, so it might help
> (especially since it gives better NFS over TCP performance than the kernel
> server too).  The only significant downside is that it's somewhat lacking in
> good documentation.

He is using NFS and removing a single file.
This involves only two packets to be exchanged between client and server
-> NFSv3 REMOVE resquest
and
<- NFSv3 REMOTE reply

These packets are both < 100 bytes in size.
On the server side, both knfsd.ko as well as Ganesha both pretty much just
calls unlink() for this request.

This looks like a pure BTRFS issue and I can not see how kngsd vs
ganesha or tcp vs udp can help.
Traditional nfs clients allow to tweak for impossibly slow servers,
for example using the 'timeo' client mount
option.


Maybe ESXi has a similar option to make it more tolerant to "when the
server does not respond within
reasonable timeout so we might need to consider the server dead and
return EIO to the application."




>>
>>
>>> Now, on top of that, you should probably look at adding 'lazytime' to the
>>> mount options for BTRFS.  This will cause updates to file time-stamps
>>> (not
>>> just atime, but mtime also, it has no net effect on ctime though, because
>>> a
>>> ctime update means something else in the inode got updated) to be
>>> deferred
>>> up to 24 hours or until the next time the inode would be written out,
>>> which
>>> can significantly improve performance on BTRFS because of the
>>> write-amplification.  It's not hugely likely to improve performance for
>>> unlink(), but it should improve write performance some, which may help in
>>> general.
>>
>>
>> Thanks for lazytime i forgot about it %)
>> On my debian servers i can't apply it with error:
>> BTRFS info (device sdc1): unrecognized mount option 'lazytime'
>> But successful apply it to my arch box (Linux 4.8.2)
>
> That's odd, 4.7 kernels definitely have support for it (I've been using it
> since 4.7.0 on all my systems, but I build upstream kernels).
>>
>>
>> For fast unlink(), i just think about subvolume like behaviour, then
>> it's possible to fast delete subvolume (without commit) and then
>> kernel will clean data in the background.
>
> There's two other possibilities I can think of to improve this.  One is
> putting each VM image in it's own subvolume, but that then means you almost
> certainly can't use ESXi to delete the images directly, although it will
> likely get you better performance overall.
>
> The other is to see if you can use a chunked image file format.  I'm not
> sure what it would be called in VMWare, but it just amounts to splitting the
> image into a number of smaller files (4M seems to work well for most
> workloads).  This should also get you slightly better performance (assuming
> you have things aligned to the chunk size in the VM disk itself), and In my
> experience, it's generally faster on BTRFS to unlink lots of small files
> than one big file.  I think that VMDK supports this (it appears to in
> VirtualBox at least), but you may need to use a command-line tool to create
> the image instead of doing it by hand.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
