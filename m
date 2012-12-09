Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:41381 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599Ab2LIOiz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 9 Dec 2012 09:38:55 -0500
Date: Sun, 9 Dec 2012 15:38:49 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: Roman Mamedov <rm@romanrm.ru>
cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-btrfs@vger.kernel.org,
        =?UTF-8?Q?Sw=C3=A2mi_Petaramesh?= <swami@petaramesh.org>
Subject: Re: BTRFS, getting darn slower everyday
In-Reply-To: <20121209164125.1bd91f23@natsu>
Message-ID: <alpine.LNX.2.01.1212091527160.31544@nerf07.vanv.qr>
References: <50714AC8.4010100@petaramesh.org> <201210071259.05801.Martin@lichtvoll.de> <50718C44.2080701@petaramesh.org> <201210071648.54027.Martin@lichtvoll.de> <alpine.LNX.2.01.1212090614400.31120@nerf07.vanv.qr> <20121209164125.1bd91f23@natsu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sunday 2012-12-09 11:41, Roman Mamedov wrote:
>> 
>> Absolutely. COW snapshots cause severe fragmentation (it's
>> in their nature).
>
>CoW filesystem incurs fragmentation by its nature, not specifically snapshots.
>Even without snapshots, rewriting portions of existing files will write the
>new blocks not over the original ones, but elsewhere, thus increasing
>fragmentation.

Right, of course.

In the "normal" case, the originals are deleted at some point, so the
length of the CoW "chain" should be bound. However, with snapshots,
there is, I wager to say, no limit to the chain length, so
defragmenting a file also becomes more work.

One can of course use rsync without --inplace, which does a full file
copy-up if the file has changed, which essentially disables CoW,
and thus reduces fragmentation. Unfortunately, not all copy
operations on one's machine do use rsync, so perhaps it would be nice
to have this as a subvolume mount option as well.
