Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59146 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbbG0PEO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jul 2015 11:04:14 -0400
Date: Mon, 27 Jul 2015 17:04:03 +0200
From: David Sterba <dsterba@suse.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 10/10] btrfs-progs: Allow open_ctree use backup tree
 root or search it automatically if primary tree root is corrupted.
Message-ID: <20150727150403.GG6306@suse.cz>
Reply-To: dsterba@suse.com
References: <1421649912-14539-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1421649912-14539-11-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1421649912-14539-11-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 19, 2015 at 02:45:12PM +0800, Qu Wenruo wrote:
> Allow open_ctree to try its best to open tree root on damaged file system.
> 
> With this patch, open_ctree will follow the below priority to read tree
> root, providing better chance to open damaged btrfs fs.
> 1) Using root bytenr in SB to read tree root
> Normal routine if not specified to use backup roots or specified root
> tree bytenr.
> 
> 2) Using backup root if specified or 1) fails
> Backup will be automatically used without user specification if
> normal routine fails
> 
> 3) Try to search possible tree root in all its metadata chunks
> The last chance, searching through all the metadata space.
> May takes a long time but still worth a try since above methods all
> fails.

I don't see this patch merged and there are no folowups. IIRC I had
objections against the automatic behaviour but cannot find the
discussion. Can we merge at least some bit of that patch? It does more
than one thing so it would be better to split it.
