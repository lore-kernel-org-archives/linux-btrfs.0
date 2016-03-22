Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49616 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759234AbcCVLEx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 07:04:53 -0400
Date: Tue, 22 Mar 2016 12:04:23 +0100
From: David Sterba <dsterba@suse.cz>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org, chandan@mykolab.com
Subject: Re: [PATCH V15 00/15] Btrfs: Subpagesize-blocksize: Allow I/O on
 blocks whose size is less than page size
Message-ID: <20160322110423.GI8095@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1455212873-14829-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1455212873-14829-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 11, 2016 at 11:17:38PM +0530, Chandan Rajendra wrote:
> this patchset temporarily disables the commit
> f82c458a2c3ffb94b431fc6ad791a79df1b3713e.
> 
> The commits for the Btrfs kernel module can be found at
> https://github.com/chandanr/linux/tree/btrfs/subpagesize-blocksize.

The branch does not apply cleanly to at least 4.5, I've tried to rebase
it but there are conflicts that are not simple. Please update it on top
of current master, ie. with the preparatory patchset merged.
