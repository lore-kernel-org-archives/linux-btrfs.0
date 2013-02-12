Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56380 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758258Ab3BLP0f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 10:26:35 -0500
Date: Tue, 12 Feb 2013 16:26:30 +0100
From: David Sterba <dsterba@suse.cz>
To: Ian Kumlien <pomac@demius.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/6] Btrfs-progs: add the rescue section to btrfs
Message-ID: <20130212152630.GZ12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1360283822-23452-1-git-send-email-pomac@demius.net>
 <1360283822-23452-7-git-send-email-pomac@demius.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360283822-23452-7-git-send-email-pomac@demius.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 08, 2013 at 01:37:02AM +0100, Ian Kumlien wrote:
> the btrfs command now lists:
>     btrfs rescue select-super -s <number> <device>
>         Select a superblock
>     btrfs rescue dump-super <device>
>         Dump a superblock to disk
>     btrfs rescue debug-tree [options] <device>
>         Debug the filesystem

The only candidate into rescue section I currently see is 'zero-log'.

david
