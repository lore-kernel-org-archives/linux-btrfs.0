Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46291 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340AbcGDMMx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jul 2016 08:12:53 -0400
Date: Mon, 4 Jul 2016 14:13:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: use the correct struct for
 BTRFS_IOC_LOGICAL_INO
Message-ID: <20160704121318.GE13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1467580946-2899-1-git-send-email-hans.van.kranenburg@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1467580946-2899-1-git-send-email-hans.van.kranenburg@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 03, 2016 at 11:22:26PM +0200, Hans van Kranenburg wrote:
> BTRFS_IOC_LOGICAL_INO takes a btrfs_ioctl_logical_ino_args as argument,
> not a btrfs_ioctl_ino_path_args. The lines were probably copy/pasted
> when the code was written.
> 
> Since btrfs_ioctl_logical_ino_args and btrfs_ioctl_ino_path_args have
> the same size, the actual IOCTL definition here does not change.
> 
> But, it makes the code less confusing for the reader.
> 
> Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>

Applied, thanks. Same fix is needed for kernel, care to send a patch?
