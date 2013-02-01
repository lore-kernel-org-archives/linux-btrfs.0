Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585Ab3BAMhL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Feb 2013 07:37:11 -0500
Date: Fri, 1 Feb 2013 13:37:09 +0100
From: David Sterba <dsterba@suse.cz>
To: Norbert Veber <nveber@pyre.virge.net>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs: extended inode refs
Message-ID: <20130201123709.GB23239@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130131153337.GB14605@pyre.virge.net>
 <20130131173404.GN30535@twin.jikos.cz>
 <20130131182526.GC14605@pyre.virge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130131182526.GC14605@pyre.virge.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 31, 2013 at 01:25:26PM -0500, Norbert Veber wrote:
> On Thu, Jan 31, 2013 at 06:34:04PM +0100, David Sterba wrote:
> > Otherwise, Mark's patches add the incompat bit unconditionally, we need
> > a way how to make it tunable in the same way as other mkfs do. I'd say
> > to take them as-is now and extend mkfs later.
> 
> Well I guess its more of a job for btrfstune.  Same way as tune2fs can
> enable all of their features.

Right.

> Having to reformat seems uncecessary.

Right.

david
