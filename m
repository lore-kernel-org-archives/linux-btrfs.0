Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 24-246-31-2.cable.teksavvy.com ([24.246.31.2]:54662 "EHLO
	pyre.virge.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab3AaSZ1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 13:25:27 -0500
Date: Thu, 31 Jan 2013 13:25:26 -0500
From: Norbert Veber <nveber@pyre.virge.net>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs: extended inode refs
Message-ID: <20130131182526.GC14605@pyre.virge.net>
References: <20130131153337.GB14605@pyre.virge.net>
 <20130131173404.GN30535@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130131173404.GN30535@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 31, 2013 at 06:34:04PM +0100, David Sterba wrote:
> Otherwise, Mark's patches add the incompat bit unconditionally, we need
> a way how to make it tunable in the same way as other mkfs do. I'd say
> to take them as-is now and extend mkfs later.

Well I guess its more of a job for btrfstune.  Same way as tune2fs can
enable all of their features.

Having to reformat seems uncecessary.
