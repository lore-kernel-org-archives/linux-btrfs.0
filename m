Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.vapor.com ([83.220.149.2]:37676 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab3A1Xbz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 18:31:55 -0500
Date: Tue, 29 Jan 2013 00:31:53 +0100
From: Ian Kumlien <pomac@vapor.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] Add static compile target
Message-ID: <20130128233153.GI15780@pomac.netswarm.net>
References: <1359158987-19921-1-git-send-email-pomac@demius.net>
 <20130128170500.GC16977@twin.jikos.cz>
 <20130128184101.GG15780@pomac.netswarm.net>
 <20130128214651.GH16977@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130128214651.GH16977@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 28, 2013 at 10:46:51PM +0100, David Sterba wrote:
> Resume: if the distro contains all required libs as static, then your
> patch works.
> 
> I wanted to get an idea how the static build would go so my patch
> was a dirty workaroud, that did not work in the end anyway.

To reiterate:
ldd btrfs btrfsck
btrfs:
	not a dynamic executable
btrfsck:
	not a dynamic executable

du -sh btrfs btrfsck
2,4M	btrfs
2,1M	btrfsck

strip btrfs
strip btrfsck

du -sh btrfs btrfsck
1,1M	btrfs
904K	btrfsck

---

And now dynamic:
du -sh btrfs btrfsck
1,5M	btrfs
1,3M	btrfsck

strip btrfsck ; strip btrfs

du -sh btrfs btrfsck
232K	btrfs
156K	btrfsck

---

This means that dists are striping binaries...
In which case it would be no problem to have then build the static target,
perhaps we could try to verify if they are available and build btrfs.static
and btrfsck.static if possible....

(I'm using: 64 bit - gcc 4.7.2)
