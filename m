Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.162]:50357 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaCOLfe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Mar 2014 07:35:34 -0400
Received: from fuchsia.localnet (p5DE8D06B.dip0.t-ipconnect.de [93.232.208.107])
	by smtp.strato.de (RZmta 32.27 DYNA|AUTH)
	with ESMTPSA id f06362q2FBZUQIS
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	for <linux-btrfs@vger.kernel.org>;
	Sat, 15 Mar 2014 12:35:30 +0100 (CET)
From: Michael Schuerig <michael.lists@schuerig.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Incremental backup for a raid1
Date: Sat, 15 Mar 2014 12:35:30 +0100
Message-ID: <1789445.UA8sCrE2Cn@fuchsia>
In-Reply-To: <53224D57.8020308@chinilu.com>
References: <1564384.fRV1HUkfCq@fuchsia> <2106363.nA97oxn4hn@fuchsia> <53224D57.8020308@chinilu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 13 March 2014 17:29:11 George Mitchell wrote:
> I currently use rsync to a separate drive to maintain a 
> backup copy, but it is not integrated into the array like n-way would 
> be, and is definitely not a perfect solution.

Could you explain how you're using rsync? I was just about to copy a 
btrfs filesystem to another disk. That filesystem has several subvolumes 
and about 100 snapshots overall. Owing to COW, this amounts to about 
1.2TB. However, I reckon that rsync doesn't know anything about COW and 
accordingly would blow up my data immensely on the destination disk.

How do I copy a btrfs filesystem preserving its complete contents? How 
do I update such a copy?

Yes, I want to keep the subvolume layout of the original and I want to 
copy all snapshots. I don't think send/receive is the answer, but it's 
likey I don't understand it well enough. I'm concerned, that a 
send/receive-based approach is not robust against mishaps.

Consider: I want to incrementally back-up a filesystem to two external 
disks. For this I'd have to for each subvolume keep a snapshot 
corresponding to its state on the backup disk. If I make any mistake in 
managing these snapshots, I can't update the external backup anymore.

Also, I don't understand whether send/receive would allow me to 
copy/update a subvolume *including* its snapshots.

Things have become a little more complicated than I had hoped for, but 
I've only been using btrfs for a couple of weeks.

Michael

-- 
Michael Schuerig
mailto:michael@schuerig.de
http://www.schuerig.de/michael/

