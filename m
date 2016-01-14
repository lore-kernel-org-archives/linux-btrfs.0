Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39750 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421AbcANKrL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 05:47:11 -0500
Date: Thu, 14 Jan 2016 11:47:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Mike Gilbert <floppym@gentoo.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Use AC_CHECK_TOOL to find AR
Message-ID: <20160114104708.GU4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1452766683-17982-1-git-send-email-floppym@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1452766683-17982-1-git-send-email-floppym@gentoo.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 14, 2016 at 05:18:03AM -0500, Mike Gilbert wrote:
> AC_CHECK_TOOL takes the --host option into account for cross-compiling.
> 
> Signed-off-by: Mike Gilbert <floppym@gentoo.org>

Applied, thanks.
