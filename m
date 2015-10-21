Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49078 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106AbbJULxV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 07:53:21 -0400
Date: Wed, 21 Oct 2015 13:52:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, dsterba@suse.cz,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [devel branch]Btrfs-convert assert at volumes.c:1846
Message-ID: <20151021115201.GF13624@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5624B828.80405@cn.fujitsu.com>
 <20151019112108.GU27761@suse.cz>
 <5624E445.3040203@gmx.com>
 <5625A801.8060704@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5625A801.8060704@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 20, 2015 at 10:33:37AM +0800, Qu Wenruo wrote:
> Finally, the bug is found.

Great, thanks!
> 
> A SUPER AWKWARD TYPO....

Happens ... :)

> See the patch just submitted:
> [PATCH] btrfs-progs: Fix a typo which causes super_copy corrupted
> 
> And, I think that's also the reason why PPC64 report errors.
> But unfortunately, there is no PPC64 machine here for me to test.

For now we can use convert and mkfs to test it a bit. Convert crashes on
4k sectors, and with "mkfs.btrfs -n 64k -s 64k --rootdir " we can
partially simulate the ppc64 parameters.
