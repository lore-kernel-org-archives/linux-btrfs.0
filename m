Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755305AbbJUWx6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 18:53:58 -0400
Date: Thu, 22 Oct 2015 00:52:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs: check unsupported filters in balance arguments
Message-ID: <20151021225237.GJ13624@suse.cz>
Reply-To: dsterba@suse.cz
References: <20151021205500.GD9839@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151021205500.GD9839@mwanda>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 21, 2015 at 11:55:00PM +0300, Dan Carpenter wrote:
> Hello David Sterba,
> 
> The patch 8eb934591f8b: "btrfs: check unsupported filters in balance
> arguments" from Oct 12, 2015, leads to the following static checker
> warning:
> 
> 	fs/btrfs/ioctl.c:4673 btrfs_ioctl_balance()
> 	warn: possible memory leak of 'bctl'

Thanks for the report, the fix is on the way:
https://patchwork.kernel.org/patch/7453231/
