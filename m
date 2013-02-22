Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757031Ab3BVWas (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 17:30:48 -0500
Date: Fri, 22 Feb 2013 23:30:46 +0100
From: David Sterba <dsterba@suse.cz>
To: Zach Brown <zab@zabbo.net>
Cc: Anand Jain <Anand.Jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [bug]  mkfs.btrfs reports device busy for ext4 mounted disk
Message-ID: <20130222223046.GN27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5127022B.6070200@oracle.com>
 <20130222190325.GC22221@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130222190325.GC22221@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 22, 2013 at 11:03:25AM -0800, Zach Brown wrote:
> >  Next, since previously we had btrfs on sdb and mkfs.ext4
> >  does not overwrite super-block mirror 1.. so
> > 
> >    btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64
> > sb_bytenr)
> > 
> >  finds btrfs on sdb.
> 
> btrfs-progs shouldn't be unconditionally trusting the backup superblocks
> if the primary is garbage.  It should only check the backups if the user
> specifically asks it to.

Agreed. Let me add that all the rescue tools should accept a parameter
to pick the backup superblocks. Currently fsck -s, select-super -s,
restore -u (though I'd like see all the option names unified, 'S' is my
candidate that would not break compatibility).

david
