Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:50859 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753507AbdKNOKN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 09:10:13 -0500
Received: by mail-ua0-f171.google.com with SMTP id v27so13929601uav.7
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Nov 2017 06:10:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171114174856.12ae346f@natsu>
References: <CAFTHvW9OmWApkzJ=s51Saq=cwv24hBqe0bzhR55Yv2+fAANH-Q@mail.gmail.com>
 <20171114174856.12ae346f@natsu>
From: Klaus Agnoletti <klaus@agnoletti.dk>
Date: Tue, 14 Nov 2017 15:09:52 +0100
Message-ID: <CAFTHvW9=ojuQW0GWRLdy2g4j7DSzT13-=ODrjhjWAq3YMEiszg@mail.gmail.com>
Subject: Re: A partially failing disk in raid0 needs replacement
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Roman

I almost understand :-) - however, I need a bit more information:

How do I copy the image file to the 6TB without screwing the existing
btrfs up when the fs is not mounted? Should I remove it from the raid
again?

Also, as you might have noticed, I have a bit of an issue with the
entire space of the 6TB disk being added to the btrfs when I added the
disk. There's something kinda basic about using btrfs that I haven't
really understodd yet. Maybe you - or someone else - can point me in
the right direction in terms of documentation.

Thanks

/klaus

On Tue, Nov 14, 2017 at 1:48 PM, Roman Mamedov <rm@romanrm.net> wrote:
> On Tue, 14 Nov 2017 10:36:22 +0200
> Klaus Agnoletti <klaus@agnoletti.dk> wrote:
>
>> Obviously, I want /dev/sdd emptied and deleted from the raid.
>
>   * Unmount the RAID0 FS
>
>   * copy the bad drive using `dd_rescue`[1] into a file on the 6TB drive
>     (noting how much of it is actually unreadable -- chances are it's mostly
>     intact)
>
>   * physically remove the bad drive (have a powerdown or reboot for this to be
>     sure Btrfs didn't remember it somewhere)
>
>   * set up a loop device from the dd_rescue'd 2TB file
>
>   * run `btrfs device scan`
>
>   * mount the RAID0 filesystem
>
>   * run the delete command on the loop device, it will not encounter I/O
>     errors anymore.
>
>
> [1] Note that "ddrescue" and "dd_rescue" are two different programs for the
> same purpose, one may work better than the other. I don't remember which. :)
>
> --
> With respect,
> Roman



-- 
Klaus Agnoletti
