Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54768 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab3FNRPy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Jun 2013 13:15:54 -0400
Date: Fri, 14 Jun 2013 19:15:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add option to btrfs-debug-tree to print
 uuid tree only
Message-ID: <20130614171552.GB5028@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1369663622-6430-1-git-send-email-sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1369663622-6430-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a nice debugging help. I'm thinking about introducing a single
option to take names of all the trees to print. Something like

btrfs-debug-tree --tree uuid,csum,root,extent /dev

(or -t for the short option). Fortunatelly the number of trees is quite
small so we would not run out of letters too soon and -u is descriptive
enough. -c for csum tree works for me as well.

So I'm adding this into integration.


thanks,
david
