Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38940 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754672Ab3AWLBK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 06:01:10 -0500
Date: Wed, 23 Jan 2013 12:01:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: put csums on the right ordered extent
Message-ID: <20130123110107.GG28263@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1358887535-7241-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1358887535-7241-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 22, 2013 at 03:45:35PM -0500, Josef Bacik wrote:
> I noticed a WARN_ON going off when adding csums because we were going over
> the amount of csum bytes that should have been allowed for an ordered
> extent.  This is a leftover from when we used to hold the csums privately
> for direct io, but now we use the normal ordered sum stuff so we need to
> make sure and check if we've moved on to another extent so that the csums
> are added to the right extent.  Without this we could end up with csums for
> bytenrs that don't have extents to cover them yet.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Survived a few hours of Chris' test and I'm running the full xfstests
again now.

david
