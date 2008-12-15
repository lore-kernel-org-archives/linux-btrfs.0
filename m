From: Andreas Dilger <adilger@sun.com>
Subject: Re: Btrfs trees for linux-next
Date: Mon, 15 Dec 2008 14:03:23 -0700
Message-ID: <20081215210323.GB5000@webber.adilger.int>
References: <1227183484.6161.17.camel@think.oraclecorp.com>
 <1228962896.21376.11.camel@think.oraclecorp.com>
 <20081211141436.030c2d65.sfr@canb.auug.org.au>
 <20081210200604.8e190b0d.akpm@linux-foundation.org>
 <1229006596.22236.46.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1229006596.22236.46.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Dec 11, 2008  09:43 -0500, Chris Mason wrote:
> The multi-device code uses a very simple brute force scan from userland
> to populate the list of devices that belong to a given FS.  Kay Sievers
> has some ideas on hotplug magic to make this less dumb.  (The scan isn't
> required for single device filesystems).

This should use libblkid to do the scanning of the devices, and it can
cache the results for efficiency.  Best would be to have the same LABEL+UUID
for all devices in the same filesystem, and then once any of these devices
are found the mount.btrfs code can query the rest of the devices to find
the remaining parts of the filesystem.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

