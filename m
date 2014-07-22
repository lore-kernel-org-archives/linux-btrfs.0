Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51260 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbaGVR4U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 13:56:20 -0400
Date: Tue, 22 Jul 2014 19:56:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2] btrfs-progs: Add mount point output for 'btrfs fi df'
 command.
Message-ID: <20140722175617.GF1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1404889017-31426-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404889017-31426-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 09, 2014 at 02:56:57PM +0800, Qu Wenruo wrote:
> Add mount point output for 'btrfs fi df'.
> Also since the patch uses find_mount_root() to find mount point,
> now 'btrfs fi df' can output more meaningful error message when given a
> non-btrfs path.

If a non-btrfs path is passed, the "Mounted on" line is printed,
followed by 2 ERROR: lines. I suggest to print it only if get_df
succeeds, ie. right before print_df.
