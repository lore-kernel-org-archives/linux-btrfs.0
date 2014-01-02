Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:43137 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaABMmV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jan 2014 07:42:21 -0500
Received: by mail-ig0-f173.google.com with SMTP id ut6so2487126igb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jan 2014 04:42:20 -0800 (PST)
Message-ID: <52C55D36.2070201@gmail.com>
Date: Thu, 02 Jan 2014 07:36:06 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: Migrate to bcache: A few questions
References: <kof6pa-akd.ln1@hurikhan77.spdns.de>	<52C1990D.9060704@gmail.com> <52C476B8.2040601@gmail.com> <pan$ce6d2$f8c0c73e$1b8dc4d$cbbdd6eb@cox.net>
In-Reply-To: <pan$ce6d2$f8c0c73e$1b8dc4d$cbbdd6eb@cox.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-01-02 03:49, Duncan wrote:
> Austin S Hemmelgarn posted on Wed, 01 Jan 2014 15:12:40 -0500 as
> excerpted:
> 
>> On 12/30/2013 11:02 AM, Austin S Hemmelgarn wrote:
>>>
>>> As an alternative to using bcache, you might try something simmilar to
>>> the following:
>>>     64G SSD with /boot, /, and /usr Other HDD with /var, /usr/portage,
>>>     /usr/src, and /home tmpfs or ramdisk for /tmp and /var/tmp
>>> This is essentially what I use now, and I have found that it
>>> significantly improves system performance.
>>>
>> On this specific note, I would actually suggest against putting the
>> portage tree on btrfs, it makes syncing go ridiculously slow,
>> and it also seems to slow down emerge as well.
> 
> Interesting observation.
> 
> I had not see it here (with the gentoo tree and overlays on btrfs), but 
> that's very likely because all my btrfs are on SSD, as I upgraded to both 
> at the same time, because my previous default filesystem choice, 
> reiserfs, isn't well suited to SSD due to excessive writing due to the 
> journaling.
> 
> I do know slow syncs and portage dep-calculations were one of the reasons 
> I switched to SSD (and thus btrfs), however.  That was getting pretty 
> painful on spinning rust, at least with reiserfs.  And I imagine btrfs on 
> single-device spinning rust would if anything be worse at least for 
> syncs, due to the default dup metadata, meaning at least three writes 
> (and three seeks) for each file, once for the data, twice for the 
> metadata.
> 
I think the triple seek+write is probably the biggest offender in my
case, although COW and autodefrag probably don't help either.  I'm kind
of hesitant to put stuff that gets changed daily on a SSD, so I've ended
up putting portage on ext4 with no journaling (which out-performs every
other filesystem I have tested WRT write performance).  As for the
dep-calculations, I have 16G of ram, so I just use a script to read the
entire tree into the page cache after each sync.
