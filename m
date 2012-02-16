From: David Sterba <dave@jikos.cz>
Subject: Re: Problems Implementing Snappy Patches
Date: Thu, 16 Feb 2012 14:15:35 +0100
Message-ID: <20120216131535.GB1046@twin.jikos.cz>
References: <CAKcLGm_AgoHWa1TGwxz6PfSkKvxmDXi_3ykHR10WgTFVW9Gt4g@mail.gmail.com> <4F3C6495.60906@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>, andi@firstfloor.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F3C6495.60906@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 16, 2012 at 10:06:13AM +0800, Li Zefan wrote:
> Mitch Harder wrote:
> > I've been trying to test the snappy compression patches, but I'm
> > getting corruptions when trying to use snappy as built on my system.
> > 
> > I've also tried sourcing my snappy patches from Chris Mason's snappy
> > branch on kernel.org with the same result.
> > 
> 
> A month ago I saved emails as patches and applied them on linux-btrfs'
> for-linus branch, and I got the same problem. Then I used the snappy
> branch (plus my fix), and it was fine. Don't know why.

The decompression corruptions Mitch reported look same as what you sent.
And I don't think they are caused by misapplied patches, I've checked
both 'mbox via mutt' -> git or pull from Chris' branch, + your patches to
fix the inlined extents, no other changes.

I did this test:
* mkfs
* mount with compress-force=snappy
* copy linux-3.2
* drop caches  (or umount/mount)
* check md5sums from original

Result:
md5sum: WARNING: 32986 computed checksums did NOT match

there are 37617 files in linux-3.2/

syslog says just:
[  728.744179] Btrfs loaded
[  728.746332] device fsid 194bbb84-1f87-4a37-8091-957d557633f1 devid 1 transid 4 /dev/sda9
[  728.747693] btrfs: enabling auto defrag
[  728.747698] btrfs: enabling inode map caching
[  728.747702] btrfs: use snappy compression
[  728.747704] btrfs: disk space caching is enabled

> > My system is a Core 2 Duo x86_64 Sabayon based system (Gentoo is our
> > parent distro).  My target btrfs/snappy partition is a 16 GB partition
> > I use for testing on a 500GB Western Digital Hard Drive.

I use the same testbox and disk as always, no related hw problems in
syslog.


david
