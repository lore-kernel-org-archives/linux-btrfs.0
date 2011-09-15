From: David Sterba <dave@jikos.cz>
Subject: Re: WARNING: at fs/btrfs/inode.c:2193 btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]()
Date: Thu, 15 Sep 2011 22:12:42 +0200
Message-ID: <20110915201242.GJ22205@twin.jikos.cz>
References: <4E6BDAEB.7020206@tuxadero.com> <4E6EABAF.9010903@cn.fujitsu.com> <Pine.LNX.4.64.1109151137420.17623@cobra.newdream.net> <20110915195029.GD25179@dhcp231-156.rdu.redhat.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sage Weil <sage@newdream.net>, Liu Bo <liubo2009@cn.fujitsu.com>,
	martin@tuxadero.com, ceph-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110915195029.GD25179@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 15, 2011 at 03:50:29PM -0400, Josef Bacik wrote:
> > We're still seeing this with -rc6, which includes 98c9942 and 65450aa.
> > 
> > I haven't looked at the reservation code in much detail.  Is there 
> > anything I can do to help track this down?
> > 
> 
> This should be taken care of with all my enospc changes.  You can pull them down
> from my btrfs-work tree as soon as kernel.org comes back from the dead :).

should you need it earlier, here's a copy:

git://repo.or.cz/linux-2.6/btrfs-unstable.git #git.kernel.org/josef/master


david
