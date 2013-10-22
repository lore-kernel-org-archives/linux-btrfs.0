Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54028 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262Ab3JVPqW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 11:46:22 -0400
Date: Tue, 22 Oct 2013 17:46:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: WARNING: CPU: 2 PID: 1543 at fs/btrfs/ctree.c:1322
 btrfs_search_old_slot+0x338/0x81d [btrfs]()
Message-ID: <20131022154619.GW1032@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20131021122123.43b3aa50@virtall.com>
 <20131021151032.708cc7d2@virtall.com>
 <20131021125317.GK1032@twin.jikos.cz>
 <20131022025025.169941de@virtall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131022025025.169941de@virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 22, 2013 at 02:50:25AM +0900, Tomasz Chmielewski wrote:
> I'm getting these every few seconds when running scrub - expected?

The system probably locked up again due to the corrupted data. Looking
at the stacktraces again, this is due to a BUG_ON in
btrfs_merge_bio_hook, and it does not look like an easy one to fix.

The filesystem is damaged, but we don't know to what extent. It's
possible that 'btrfs restore' will be able to get to the data.

david
