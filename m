Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36613 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758208Ab3HHXo4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 19:44:56 -0400
Date: Fri, 9 Aug 2013 01:44:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] Btrfs: track compression algorithm on inodes
Message-ID: <20130808234454.GG5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1375874984-31139-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375874984-31139-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 07, 2013 at 12:29:44PM +0100, Filipe David Borba Manana wrote:
> Currently the compression settings (algorithm and force mode) need
> to be specified at mount time in order to have newly created files
> compressed.
[...]

I think we should take the top-down approach and start with UI how to
set these attributes, then think where to store the information
(existing strucutures, xattrs). Tweaking compressin per-file is
desirable, but with your patch it's required to set it via a mount
option and that's not very practical (only via remount, root required).

david
