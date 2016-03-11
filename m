Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38402 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932585AbcCKQF2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Mar 2016 11:05:28 -0500
Date: Fri, 11 Mar 2016 17:05:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3] Btrfs: Show a warning message if one of objectid
 reaches its highest value
Message-ID: <20160311160505.GU18908@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56DFC051.1040409@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56DFC051.1040409@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 09, 2016 at 03:18:57PM +0900, Satoru Takeuchi wrote:
> It's better to show a warning message for the exceptional case
> that one of objectid (in most case, inode number) reaches its
> highest value. For example, if inode cache is off and this event
> happens, we can't create any file even if there are not so many files.
> This message ease detecting such problem.
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>

I'll queue this one, with minor fixes

> +		btrfs_warn(root->fs_info,
> +			   "The objectid of root %llu reaches its highest value.\n",

lower case 'The', no "." and no "\n" for the btrfs_* helpers
