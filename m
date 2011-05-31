From: David Sterba <dave@jikos.cz>
Subject: Re: linux-next: build warninga in Linus' tree
Date: Tue, 31 May 2011 19:57:09 +0200
Message-ID: <20110531175709.GC12709@twin.jikos.cz>
References: <20110530113653.5c7084f0.sfr@canb.auug.org.au>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110530113653.5c7084f0.sfr@canb.auug.org.au>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Mon, May 30, 2011 at 11:36:53AM +1000, Stephen Rothwell wrote:
> After merging the Linus' tree, today's linux-next build (powerpc
> ppc64_defconfig) produced these warnings:
> 
> fs/btrfs/sysfs.c:76:26: warning: 'btrfs_root_attrs' defined but not used
> fs/btrfs/sysfs.c:97:26: warning: 'btrfs_super_attrs' defined but not used
> fs/btrfs/sysfs.c:153:13: warning: 'btrfs_super_release' defined but not used
> fs/btrfs/sysfs.c:160:13: warning: 'btrfs_root_release' defined but not used
> 
> I have started using gcc v4.5.2 (instead of v4.4.4) if that makes a
> difference.

the warning probably started to show up after one of my cleanup patches,
removing unused functions (f2a97a9dbd86eb1ef956bdf20e05c507b32beb96).
The sysfs interface is not being used right now, but there's a unmerged
patchset which adds the interesting bits like info about available btrfs
filesystems and devices. I don't know what are the intentions regarding
sysfs.


david
