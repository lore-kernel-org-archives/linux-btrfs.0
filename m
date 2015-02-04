Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55088 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353AbbBDI6r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Feb 2015 03:58:47 -0500
Date: Wed, 4 Feb 2015 09:58:45 +0100
From: David Sterba <dsterba@suse.cz>
To: WorMzy Tykashi <wormzy.tykashi@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs-progs 3.19rc1 issues
Message-ID: <20150204085845.GE24227@suse.cz>
Reply-To: dsterba@suse.cz
References: <CALOYprUOeeeeXTZwCjBDvC5rapM-Dk5xwQ26S9nVZWKaG2c1mA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALOYprUOeeeeXTZwCjBDvC5rapM-Dk5xwQ26S9nVZWKaG2c1mA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 03, 2015 at 10:26:00PM +0000, WorMzy Tykashi wrote:
> I've been watching the 3.19.x branch with interest, and noticed that
> you've tagged rc1. Unfortunately, I think I've found a few problems
> with it. I will try to explain here:

Thanks for the early feedback, I did not manage to write the
announcement yesterday. The purpose of the release is to find the
problems that arise from the reworked build system. I'll look at the
issues.
