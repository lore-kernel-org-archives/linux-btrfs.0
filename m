Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51083 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbaKXRjK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Nov 2014 12:39:10 -0500
Date: Mon, 24 Nov 2014 18:39:09 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>, torvalds@linux-foundation.org,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs deadlock fix
Message-ID: <20141124173909.GC26471@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20141123151439.GA16816@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141123151439.GA16816@ret.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

I thought the fix for the scrub/replace deadlock would be included in
this pull, I can reproduce it on each run of xfstests with 3.18-rc.

btrfs: fix dead lock while running replace and defrag concurrently
https://patchwork.kernel.org/patch/5264531/

I've retested it again including this pull and still deadlocks reliably
at btrfs/070.
