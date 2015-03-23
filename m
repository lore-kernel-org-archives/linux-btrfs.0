Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43963 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbbCWXqZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 19:46:25 -0400
Date: Tue, 24 Mar 2015 00:46:23 +0100
From: David Sterba <dsterba@suse.cz>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2][BTRFS-PROGS] Improve output of mkfs.btrfs command
Message-ID: <20150323234623.GQ20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1418847252-14184-1-git-send-email-kreijack@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1418847252-14184-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

FYI, I've added the following patches to 3.19 queue

 * btrfs-progs: return the fsid from make_btrfs()
 * btrfs-progs: add strdup in btrfs_add_to_fsid() to track the device path
 * btrfs-progs: add verbose option to btrfs_add_to_fsid()
 * btrfs-progs: add -v and -q switches in the mkfs.btrfs man page
 * btrfs-progs: add -v -q switches to mkfs.btrfs

ie. the patch that adds the the summary is not there yet but I'm planning to
add it as well with some modifications. If that turns out to be too different
from your proposal, I'm going to send it for comments.
