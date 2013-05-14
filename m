Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41552 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263Ab3ENNXO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 May 2013 09:23:14 -0400
Date: Tue, 14 May 2013 15:23:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS in laptop-mode
Message-ID: <20130514132312.GU16456@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5191F6AB.6020106@statystyka.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5191F6AB.6020106@statystyka.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 14, 2013 at 10:32:43AM +0200, Adam Ryczkowski wrote:
> What are perspectives on BTRFS complying with laptop-mode and stop writing
> to disk every 30 sec?

> Is there any tunable switch, that can delay such writes to, say, 15 minutes,
> or better yet: until the disk started spinning anyway?

30 seconds is the regular transaction commit interval. Tweaking the
value is easy (via a mount option to make it clearly visible):

http://lxr.free-electrons.com/source/fs/btrfs/disk-io.c#L1691

but has implications about data safety in case of a long delay in
combination with a crash.


david
