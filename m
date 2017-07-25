Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:35256 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751651AbdGYNQx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jul 2017 09:16:53 -0400
Received: by mail-it0-f43.google.com with SMTP id h199so50693159ith.0
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Jul 2017 06:16:53 -0700 (PDT)
Subject: Re: btrfs raid assurance
To: =?UTF-8?Q?H=c3=a9rikz_Nawarro?= <herikz.nawarro@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAD6NJSxuix4N=kPbQ_=QRnKP4Ny6kLyVyEA4p=PvBfgtbwrUHw@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <32bd5570-7bb4-8234-5e2e-b4ea9ff04ccd@gmail.com>
Date: Tue, 25 Jul 2017 09:16:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAD6NJSxuix4N=kPbQ_=QRnKP4Ny6kLyVyEA4p=PvBfgtbwrUHw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-07-25 08:55, Hérikz Nawarro wrote:
> Hello everyone,
> 
> I'm migrating to btrfs and i would like to know, in a btrfs filesystem
> with 4 disks (multiple sizes) with -d raid0 & -m raid1, how many
> drives can i lost without losing the entire array?
Exactly one, but you will lose data if you lose one device.  Most of the 
BTRFS profiles are poorly named (single and dup being the exceptions), 
and do not behave consistently with the RAID levels they are named 
after.  BTRFS raid1 mode is functionally equivalent to MD or LVM RAID10 
mode, just with larger blocks.  It only gives you two copies of the 
data, so losing one device will make the array degraded, and two will 
effectively nuke it.

If you care about data safety, I would advise against using raid0 for 
data.  If you lose _one_ device in raid0 mode, you will usually lose 
part of most of the files on the volume.  Single mode for data will 
still distribute things evenly and will not have that issue (unless you 
have files larger than 1GB, a file will either be all there or all gone, 
as opposed to having read errors part way through), and isn't much worse 
in terms of performance (BTRFS does not parallelize device access as 
well as it should).

If you care about both performance and data safety, and can tolerate 
having only half the usable space, I would actually suggest running 
BTRFS with both data and metadata in raid1 mode on top of two LVM or MD 
RAID0 volumes.  This should outperform the configuration you listed by a 
significant amount, will provide better data safety, and should also do 
a better job of distributing the load across devices.
