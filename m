Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43586 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761130AbbEEQyo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 May 2015 12:54:44 -0400
Date: Tue, 5 May 2015 18:54:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: btrfs_scan_block_devices is unused function
 delete it
Message-ID: <20150505165442.GM5099@suse.cz>
Reply-To: dsterba@suse.cz
References: <1410571282-3482-4-git-send-email-anand.jain@oracle.com>
 <1412640511-21840-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1412640511-21840-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 07, 2014 at 08:08:31AM +0800, Anand Jain wrote:
> After Patch:
>  remove BTRFS_SCAN_PROC scan method
> There isn't any consumer for btrfs_scan_block_devices() so delete it.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Applied, thanks.
