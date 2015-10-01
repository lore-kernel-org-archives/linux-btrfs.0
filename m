Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38684 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbbJARA2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Oct 2015 13:00:28 -0400
Date: Thu, 1 Oct 2015 18:59:26 +0200
From: David Sterba <dsterba@suse.cz>
To: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs: obtain block checksums from user space
Message-ID: <20151001165926.GI5885@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <mu1e38$io1$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <mu1e38$io1$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 24, 2015 at 09:06:32PM +0300, Matwey V. Kornilov wrote:
> I would like to read the list of the checksums for the specific file
> stored onto btrfs filesystem. I think I could use the checksums in the
> manner like rsync does, but safe both CPU (because csums are already
> calculated for the file) and I/O (because I don't need to reread all the
> file from the hard drive).
> 
> I've looked through linux kernel sources and not found appropriate ioctl
> to do this. Frankly speaking, I've not found good documentations for all
> available btrfs ioctls.

I have the ioctl docs in my todo and barely started it. There's no
single ioctl for getting the per-block checksums but it is possible
using several calls to the SEARCH_TREE. I have a prototype in my gits in
branch dev/block-csum-search (2nd patch from the top), I'll try to find
some time to make it a proper subcommand, so far the command UI is not
righ enough and the output is quite rough.
