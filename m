Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56423 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbaLDQA4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Dec 2014 11:00:56 -0500
Date: Thu, 4 Dec 2014 17:00:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH RFC] btrfs-progs: Add simple python front end to the
 search ioctl
Message-ID: <20141204160056.GF9754@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5421A23B.3000401@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5421A23B.3000401@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 23, 2014 at 12:39:23PM -0400, Chris Mason wrote:
> This is a starting point for a debugfs style python interface using
> the search ioctl.  For now it can only do one thing, which is to
> print out all the extents in a file and calculate the compression ratio.
> 
> Over time it will grow more features, especially for the kinds of things
> we might run btrfs-debug-tree to find out.  Expect the usage and output
> to change dramatically over time (don't hard code to it).
> 
> Signed-off-by: Chris Mason <clm@fb.com>

FYI, I'm adding the script to progs git.
