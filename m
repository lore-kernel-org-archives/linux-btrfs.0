From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: btrfs mount flags
Date: Sun, 15 Apr 2012 12:00:31 +0200
Message-ID: <201204151200.31568.Martin@lichtvoll.de>
References: <jjul59-m49.ln1@hurikhan.ath.cx> <t0ho59-rjd.ln1@hurikhan.ath.cx> <pan.2012.04.15.05.53.30@cox.net> (sfid-20120415_113808_299097_7352B259)
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.04.15.05.53.30@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>

No cc - instead of whats habit on this list - as you prefer list replies.

Am Sonntag, 15. April 2012 schrieb Duncan:
> I believe there's a current report of a performance regression due to
> the  space cache, too, tho it's possible I'm getting this mixed up
> with the inode cache.  Someone with an ssd is using btrfs as their
> rootfs, and ran without the space cache for quite some time.  Now the
> first time the system's mounted with the space cache, it's supposed to
> take a bit longer, but this person is reporting that it's taking MUCH
> longer, for EVERY boot, now.  The original root read-only mount is
> fine, but immediately after the remount read-write, there's a long
> delay with not a lot going on, according to the bootchart they were
> asked to run as a diagnostic.  This guy has something like 60 machines
> with this problem, so it's not some random machine acting up,
> either.  I think they've tracked it to some code that hadn't been
> updated for the space cache (corner-case, they didn't expect it would
> be affected), but I'm not sure what the status on the patch is.  But
> the expectation is a fix by 3.4 release, some 4-6 weeks or so, from
> now.  Anyway, at least people with existing btrfs filesystems might
> want to hold off on enabling that option for the moment, if they're
> running the 3.4-rcs, but by 3.4 release, it'll hopefully be fine.

Interesting.

I am running with space_cache and inode_cache for quite some time already, 
and did not see issues, but for the moment 3.3 is the newest kernel I use.

When switching forth an back between 3.2/3.3 and earlier kernels I have 
seen it being rebuild, which on my ThinkPad T23 where BTRFS generally 
seems to be really slow let the boot process crawl. But after it has been 
build its fine. While the filesystem is still slower than the XFS I had 
there before I believe.

Maybe a fix will be in some rc candidate before 3.4 release.

Maybe an update wiki page could serve as input for additions to mount 
Manpage. Or a special btrfs mount options manpage. I would be willing to 
help with that as time permits.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
