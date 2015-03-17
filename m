Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37995 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbbCQKL5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Mar 2015 06:11:57 -0400
Date: Tue, 17 Mar 2015 11:11:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: Remove the check for old-style mkfs
Message-ID: <20150317101156.GT20767@suse.cz>
Reply-To: dsterba@suse.cz
References: <20150316162534.GO20767@twin.jikos.cz>
 <1426574056-2978-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1426574056-2978-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 17, 2015 at 02:34:16PM +0800, Liu Bo wrote:
> This was used to make sure that a fresh btrfs from an older mkfs.btrfs,
> but it also allows us to mount a buggy btrfs if this btrfs has the right
> superblock head part but has something wrong with chunk tree part[1], and
> after that we can hit BUG_ON()s set in the code to prevent something
> impossible.
> 
> Since David has released "Btrfs progs v3.19-rc2", just remove the check,
> if anyone who wants to make a fresh btrfs, please use the latest one.
> 
> [1]: http://www.spinics.net/lists/linux-btrfs/msg42358.html
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.cz>

Thanks.
