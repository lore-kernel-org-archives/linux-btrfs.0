Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxsystems.it ([79.7.78.67]:49716 "EHLO
        mail.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752238AbeESIyV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 19 May 2018 04:54:21 -0400
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: Any chance to get snapshot-aware =?iso-8859-1?Q?defragmentation=3F?=
Date: Sat, 19 May 2018 10:54:19 +0200
MIME-Version: 1.0
Message-ID: <b8ac31e3-7c9b-44a7-a286-08f1642e25c6@linuxsystems.it>
In-Reply-To: <07cf6f9b-7d67-93b9-2a6f-6d031ccf5468@gmail.com>
References: <4428b2eb-796a-4c1b-8527-a05532436da4@linuxsystems.it>
 <20180518162051.GS6649@twin.jikos.cz>
 <99d57070-a1df-45ef-8f7e-df832bd7ad92@linuxsystems.it>
 <de7adf73-ba0b-9154-e3d1-b4e468ad3c96@gmail.com>
 <161bea23-f1ea-4f01-b3ea-2c5e706102a7@linuxsystems.it>
 <07cf6f9b-7d67-93b9-2a6f-6d031ccf5468@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On venerdì 18 maggio 2018 20:33:53 CEST, Austin S. Hemmelgarn wrote:
> With a bit of work, it's possible to handle things sanely.  You 
> can deduplicate data from snapshots, even if they are read-only 
> (you need to pass the `-A` option to duperemove and run it as 
> root), so it's perfectly reasonable to only defrag the main 
> subvolume, and then deduplicate the snapshots against that (so 
> that they end up all being reflinks to the main subvolume).  Of 
> course, this won't work if you're short on space, but if you're 
> dealing with snapshots, you should have enough space that this 
> will work (because even without defrag, it's fully possible for 
> something to cause the snapshots to suddenly take up a lot more 
> space).

Been there, tried that. Unfortunately even if I skip the defreg a simple

duperemove -drhA --dedupe-options=noblock --hashfile=rootfs.hash rootfs

is going to eat more space than it was previously available (probably due 
to autodefrag?).

Niccolò
