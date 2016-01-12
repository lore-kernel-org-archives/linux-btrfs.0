Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59906 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762523AbcALOac (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jan 2016 09:30:32 -0500
Date: Tue, 12 Jan 2016 15:28:06 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Format change for btrfs fi df
Message-ID: <20160112142806.GL4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1450070396-20744-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1450070396-20744-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 14, 2015 at 01:19:56PM +0800, Qu Wenruo wrote:
> The GlobalReserve space in 'btrfs fi df' is always confusing for a lot
> of users.
> As it is not a special chunk type like DATA or METADATA, it's in fact a
> sub-type of METADATA.
> 
> So change the output to skip GlobalReserve by default, and adding its
> total to metadata used.
> And add a new option '-r|--reserve' to show the GlobalReserve, but skip
> the profile of GlobalReserve.

How about this:

- keep the global reserve in the output, separate from metadata and not
  accounted
- add new option to account the global reserve into metadata and then
  drop it from the output
