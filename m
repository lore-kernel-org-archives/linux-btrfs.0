Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56672 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756593Ab3DWPrO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Apr 2013 11:47:14 -0400
Date: Tue, 23 Apr 2013 17:47:11 +0200
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org, wangshilong1991@gmail.com
Subject: Re: [PATCH v3 3/3] Btrfs: automatic rescan after "quota enable"
 command
Message-ID: <20130423154711.GU16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1366716411-9750-1-git-send-email-list.btrfs@jan-o-sch.net>
 <1366716411-9750-4-git-send-email-list.btrfs@jan-o-sch.net>
 <20130423153623.GT16427@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130423153623.GT16427@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 23, 2013 at 05:36:23PM +0200, David Sterba wrote:
> The original question I've had is what sort of work does rescan do
> because it's on the commit path and we don't want to add more work and
> delay commit.

It just wakes up the rescan worker, not a problem.
