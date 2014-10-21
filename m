Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([37.187.97.211]:59515 "EHLO rin.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbaJUKQN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 06:16:13 -0400
Date: Tue, 21 Oct 2014 16:16:11 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: inode_cache  Re: strange 3.16.3 problem
Message-ID: <20141021161611.0f78e6e2@natsu>
In-Reply-To: <pan$87a32$ab14c0c8$d31af00$391cbfd4@cox.net>
References: <201410181454.19375.russell@coker.com.au>
	<54426C16.5030206@pobox.com>
	<201410191041.42013.russell@coker.com.au>
	<54454858.8010802@pobox.com>
	<54456EB0.9020503@inwind.it>
	<pan$87a32$ab14c0c8$d31af00$391cbfd4@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 21 Oct 2014 09:50:37 +0000 (UTC)
Duncan <1i5t5.duncan@cox.net> wrote:

> (FWIW I wish that mount option would just go away as it would definitely 
> remove an invitation to a Russian roulette party with their data for the 
> unwary, but I suppose there's someone paying some bills somewhere that 
> wants it kept for some specific use-case where the performance gain must 
> be worth the calculated risk, thus continuing that invitation to data 
> Russian roulette for everyone else.)

Why do you think it is so dangerous? Just because of possible bugs? But bugs
can be anywhere in Btrfs, why specifically single out one mount option.

Let's take a look at its description in the wiki:

"inode_cache (since 3.0)
Enable free inode number caching. Not recommended to use unless files on your
filesystem get assigned inode numbers that are approaching 2^64. Normally, new
files in each subvolume get assigned incrementally (plus one from the last
time) and are not reused. The mount option turns on caching of the existing
inode numbers and reuse of inode numbers of deleted files. This option may
slow down your system at first run, or after mounting without the option."
https://btrfs.wiki.kernel.org/index.php/Mount_options

As you can see it's not about performance, but rather more of a recognition
that a filesystem with some pre-determined finite lifetime expectancy is not a
good thing to have; even though 2^64 is a lot, there are various scenarios out
there, including millions of files and constant creation and removal of
snapshots, that may make the FS hit the limit faster than you would expect.

-- 
With respect,
Roman
