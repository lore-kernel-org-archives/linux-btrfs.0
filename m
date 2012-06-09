Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:58786 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563Ab2FIGYe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Jun 2012 02:24:34 -0400
From: Goffredo Baroncelli <kreijack@inwind.it>
To: linux-btrfs@vger.kernel.org
Cc: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH][btrfs-progs] Removing btrfsctl, btrfs-vol, btrfs-show
Date: Sat,  9 Jun 2012 08:24:18 +0200
Message-Id: <1339223060-6256-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With the commit 002d021c (committed October 2011)
btrfsctl, btrfs-vol, btrfs-show were declared deprecated.
The last patches related to these commands are dated December 2010.

These tools are replaced by the "btrfs" tool in all the
functionality.

Stefan Behrens yesterday issued a patch which removes these programs
from Makefile. I think that it is a time to remove these program at all.

You can pull this patch also from 
	http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git
branch
	remove-old

BR
G.Baroncelli
