From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs mount flags
Date: Sun, 15 Apr 2012 05:53:31 +0000 (UTC)
Message-ID: <pan.2012.04.15.05.53.30@cox.net>
References: <jjul59-m49.ln1@hurikhan.ath.cx>
	<pan.2012.04.13.17.42.32@cox.net> <t0ho59-rjd.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Sat, 14 Apr 2012 17:17:30 +0200 as excerpted:

> Duncan <1i5t5.duncan@cox.net> schrieb:
> 
>> Kai Krakow posted on Fri, 13 Apr 2012 17:50:45 +0200 as excerpted:
>> 
>>> Is there any documentation about btrfs mount flags wrt:
>>> [...]
>> 
>> AFAIK the best documentation is the wiki
>> http://btrfs.ipv5.de/index.php?title=Main_Page
> 
> This looks good but I think there's room for improvement. Are there any
> mount options which apply to a subvolume only?

Based on comments from the developers I've seen on the list, at present, 
pretty much everything is global per-filesystem.  (I think ro/rw and 
probably the exec/noexec etc style options work per-subvolume mount now, 
but not btrfs-feature-specific options.  Note that the feature I need 
isn't there yet, 3.5/3.6 roadmapped, so I'm not actually running btrfs 
myself yet, to check.)  There's plans to make much of it, especially 
stuff like the compress options, per-mount, and the filesystem has been 
designed in general to handle that, but AFAIK the filesystem only has one 
instance of the state tracker for that stuff currently, so it's global 
per filesystem, not per subvolume, ATM.

> And while I see space_cache having the "permanent" annotation in its
> description, I see something similar missing for e.g. the inode_cache,
> ssd,
> etc. descriptions. Something that says "not permanent, must be given
> each time".
> 
> Anyone willing to eloberate on this? I'd offer to contribute this to the
> wiki.

Someone else could confirm, but my understanding is that the space-cache 
is special in that it's a newer feature that changes the on-disk format 
in a way that isn't fully backward compatible.  After it's turned on, an 
older kernel can still be used, but the space cache won't be updated, so 
it'll be stale when one boots back into a new kernel with the feature 
once again.  That shouldn't break anything, but it's not ideal, so the 
option's there in ordered to let people enable it when they don't 
anticipate using older kernels without the feature any longer.

I believe there's a current report of a performance regression due to the 
space cache, too, tho it's possible I'm getting this mixed up with the 
inode cache.  Someone with an ssd is using btrfs as their rootfs, and ran 
without the space cache for quite some time.  Now the first time the 
system's mounted with the space cache, it's supposed to take a bit 
longer, but this person is reporting that it's taking MUCH longer, for 
EVERY boot, now.  The original root read-only mount is fine, but 
immediately after the remount read-write, there's a long delay with not a 
lot going on, according to the bootchart they were asked to run as a 
diagnostic.  This guy has something like 60 machines with this problem, 
so it's not some random machine acting up, either.  I think they've 
tracked it to some code that hadn't been updated for the space cache 
(corner-case, they didn't expect it would be affected), but I'm not sure 
what the status on the patch is.  But the expectation is a fix by 3.4 
release, some 4-6 weeks or so, from now.  Anyway, at least people with 
existing btrfs filesystems might want to hold off on enabling that option 
for the moment, if they're running the 3.4-rcs, but by 3.4 release, it'll 
hopefully be fine.

Most of the others are traditional mount options.  The compress options, 
for instance, only affect data written (or rewritten due to defrag/
rebalance) while the mount option is on.  Existing data, compressed or 
not, remains readable either way -- the filesystem automatically 
decompresses it on read as necessary, regardless of the state of the 
current compression mount options.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

