Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60967 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381AbcBYR7R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Feb 2016 12:59:17 -0500
Date: Thu, 25 Feb 2016 18:59:05 +0100
From: David Sterba <dsterba@suse.cz>
To: anand.jain@oracle.com
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 00/15] Device delete by id
Message-ID: <20160225175905.GJ23746@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1455556900.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1455556900.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 15, 2016 at 06:33:56PM +0100, David Sterba wrote:
> this patchset extends the ioctl arugments to take an id so we can delete a
> device by it. It reuses the existing structure btrfs_ioctl_vol_args_v2 and
> extends it in na backward-compatible way so that we don't need to introduce
> another one.
> 
> The core patchset is from Anand, I did some cleanups as I went through the
> series again and made some cleanups and minor naming tweaks to the interface.
> 
> I'll add the branch to for-next and if everything goes fine I'll send a pull
> request for 4.6 in a week.

This patchset is causing crashes in my setup, based on linux-next tree
with my for-next. I did a test round without it and it passes, so I'm
removing it from 4.6 queue. We need more time to find and fix it.
