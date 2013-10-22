Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861Ab3JVOns (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 10:43:48 -0400
Date: Tue, 22 Oct 2013 16:43:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, chris.mason@fusionio.com,
        jbacik@fusionio.com
Subject: Re: [PATCH 1/2] btrfs-progs: make get_btrfs_mount callable
Message-ID: <20131022144346.GV1032@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1382421202-18494-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1382421202-18494-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 22, 2013 at 01:53:21PM +0800, Anand Jain wrote:
> get_btrfs_mount is reusable function but it is printing
> errors, this removes it. Here the parent function of
> open_path_or_dev_mnt does print error msg on error.

Yeah, but then each caller should duplicate the is_block_device check to
keep get_btrfs_mount silent. There should be 2 functions, one that does
all the error checking and prints error messages and one that is silent
and usable eg. from a library. I'll keep the patch as-is for now because
there are no other users than open_path_or_dev_mnt and the function is
not exported to library.

david
