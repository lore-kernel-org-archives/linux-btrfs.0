Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([83.144.122.22]:60347 "EHLO zlom.siedziba.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755860AbaAFSxs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jan 2014 13:53:48 -0500
Message-ID: <52CAF9A4.3060203@siedziba.pl>
Date: Mon, 06 Jan 2014 19:44:52 +0100
From: =?UTF-8?B?UGlvdHIgUGF3xYJvdw==?= <pp@siedziba.pl>
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Calvin Walton <calvin.walton@kepstin.ca>
Subject: Re: Help! - "btrfs device delete missing" running out of space
References: <labocc$5ue$1@ger.gmane.org> <laca4i$7lq$1@ger.gmane.org> <1389025462.18558.8.camel@sasami.ottawa.blindsidenetworks.com>
In-Reply-To: <1389025462.18558.8.camel@sasami.ottawa.blindsidenetworks.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
> I'm not sure what the solution is, but the issue seems to be that
> btrfs is laying out the RAID1 like this:
[snip]

Yeah, it kinda ended up like this. I think the problem stems from the
fact, that restoring redundancy works by relocating block groups, which
rewrites all chunks instead of restoring only the ones that are missing.
And it uses the usual allocation strategy, which fails in this case. It
treats unreplicated data as allocated, when in fact all of that data
will be, sooner or later, freed in the process.

If I succeed deleting the missing device, then running "btrfs balance"
should fix the problem.

Regards
