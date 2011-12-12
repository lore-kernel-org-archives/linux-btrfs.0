Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41668 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1LLIFH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Dec 2011 03:05:07 -0500
Received: by vcbfk14 with SMTP id fk14so3522317vcb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Dec 2011 00:05:06 -0800 (PST)
MIME-Version: 1.0
Reply-To: chb@muc.de
In-Reply-To: <or62hmut7c.fsf@livre.localdomain>
References: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
	<f4751f56cf4767cb60306605fd13ee2573f3cf67.1322507825.git.oliva@lsd.ic.unicamp.br>
	<CAO47_--r5NVPLpLRW0ftUs4T3xtEuJqMpAz1t7SYnHGdM0e=Fg@mail.gmail.com>
	<or62i1rxzl.fsf@livre.localdomain>
	<CAO47_-9SCmZGCkKmV93t-Q9X_ffaYs8gY_vaiPxtAPwzRzHQ+w@mail.gmail.com>
	<CAO47_--d2oEHCyMafoBLWfbd1WZsASngBh=4_TNiwrwd+QJkGA@mail.gmail.com>
	<or62hmut7c.fsf@livre.localdomain>
Date: Mon, 12 Dec 2011 09:05:06 +0100
Message-ID: <CAO47_-8EZaCG=PaLKiwUh6i+R-01wK6F5urfVsobxWWE54nAWw@mail.gmail.com>
Subject: Re: [PATCH 02/20] Btrfs: initialize new bitmaps' list
From: Christian Brunner <chb@muc.de>
To: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2011/12/12 Alexandre Oliva <oliva@lsd.ic.unicamp.br>:
> On Dec  7, 2011, Christian Brunner <chb@muc.de> wrote:
>
>> With this patch applied I get much higher write-io values than without
>> it. Some of the other patches help to reduce the effect, but it's
>> still significant.
>
>> iostat on an unpatched node is giving me:
>
>> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s
>> avgrq-sz avgqu-sz   await  svctm  %util
>> sda             105.90     0.37   15.42   14.48  2657.33   560.13
>> 107.61     1.89   62.75   6.26  18.71
>
>> while on a node with this patch it's
>> sda             128.20     0.97   11.10   57.15  3376.80   552.80
>> 57.58    20.58  296.33   4.16  28.36
>
>
>> Also interesting, is the fact that the average request size on the
>> patched node is much smaller.
>
> That's probably expected for writes, as bitmaps are expected to be more
> fragmented, even if used only for metadata (or are you on SSD?)
>

It's a traditional hardware RAID5 with spinning disks. - I would
accept this if the writes would start right after the mount, but in
this case it takes a few hours until the writes increase. Thats why
I'm allmost certain that something is still wrong.

> Bitmaps are just a different in-memory (and on-disk-cache, if enabled)
> representation of free space, that can be far more compact: one bit per
> disk block, rather than an extent list entry.  They're interchangeable
> otherwise, it's just that searching bitmaps for a free block (bit) is
> somewhat more expensive than taking the next entry from a list, but you
> don't want to use up too much memory with long lists of
> e.g. single-block free extents.

Thanks for the explanation! I'll try to insert some debuging code,
once my test server is ready.

Christian
