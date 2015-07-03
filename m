Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743AbbGCIzg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jul 2015 04:55:36 -0400
Date: Fri, 3 Jul 2015 10:55:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 11/18] btrfs: qgroup: Add new qgroup calculation
 function btrfs_qgroup_account_extents().
Message-ID: <20150703085534.GP726@suse.cz>
Reply-To: dsterba@suse.cz
References: <1430274551-9277-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1430274551-9277-12-git-send-email-quwenruo@cn.fujitsu.com>
 <20150702144349.GN726@twin.jikos.cz>
 <5595D7FC.60807@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5595D7FC.60807@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 03, 2015 at 08:31:56AM +0800, Qu Wenruo wrote:
> > Surprise, this adds an empty file. What was the intention?
> My fault, it seems I opened the non-existing file and saved it...
> Do I need to submit a patch to remove it?

Yes please, you can add my Acked-by: David Sterba <dsterba@suse.com>
