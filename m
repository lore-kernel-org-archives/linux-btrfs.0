Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:49201 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754495AbdKNM6v (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 07:58:51 -0500
Received: by mail-io0-f178.google.com with SMTP id x63so12075586ioe.6
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Nov 2017 04:58:51 -0800 (PST)
Subject: Re: A partially failing disk in raid0 needs replacement
To: Roman Mamedov <rm@romanrm.net>, Klaus Agnoletti <klaus@agnoletti.dk>
Cc: linux-btrfs@vger.kernel.org
References: <CAFTHvW9OmWApkzJ=s51Saq=cwv24hBqe0bzhR55Yv2+fAANH-Q@mail.gmail.com>
 <20171114174856.12ae346f@natsu>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ebe4279f-ac09-f27a-47f2-3e911033268b@gmail.com>
Date: Tue, 14 Nov 2017 07:58:48 -0500
MIME-Version: 1.0
In-Reply-To: <20171114174856.12ae346f@natsu>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-14 07:48, Roman Mamedov wrote:
> On Tue, 14 Nov 2017 10:36:22 +0200
> Klaus Agnoletti <klaus@agnoletti.dk> wrote:
> 
>> Obviously, I want /dev/sdd emptied and deleted from the raid.
> 
>    * Unmount the RAID0 FS
> 
>    * copy the bad drive using `dd_rescue`[1] into a file on the 6TB drive
>      (noting how much of it is actually unreadable -- chances are it's mostly
>      intact)
> 
>    * physically remove the bad drive (have a powerdown or reboot for this to be
>      sure Btrfs didn't remember it somewhere)
> 
>    * set up a loop device from the dd_rescue'd 2TB file
> 
>    * run `btrfs device scan`
> 
>    * mount the RAID0 filesystem
> 
>    * run the delete command on the loop device, it will not encounter I/O
>      errors anymore.
While the above procedure will work, it is worth noting that you may 
still lose data.
> 
> 
> [1] Note that "ddrescue" and "dd_rescue" are two different programs for the
> same purpose, one may work better than the other. I don't remember which. :)
As a general rule, GNU ddrescue is more user friendly for block-level 
copies, while Kurt Garlof's dd_rescue tends to be better for copying at 
the file level.  Both work fine in terms of reliability though.
