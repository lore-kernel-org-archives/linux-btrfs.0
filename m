From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: btrfs-raid questions I couldn't find an answer to on the wiki
Date: Sat, 11 Feb 2012 19:04:41 -0500
Message-ID: <4F370219.1000205@ubuntu.com>
References: <pan.2012.01.26.15.41.32@cox.net> <201201291223.40161.kreijack@inwind.it> <COL113-W485767962008EF29E7E27EB08D0@phx.gbl> <pan.2012.01.31.05.55.47@cox.net> <4F3573E7.9080306@ubuntu.com> <pan.2012.02.11.05.48.22@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Duncan <1i5t5.duncan@cox.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.02.11.05.48.22@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/11/2012 12:48 AM, Duncan wrote:
> So you see, a separate /boot really does have its uses. =:^)

True, but booting from removable media is easy too, and a full livecd gives
much more recovery options than the grub shell.  It is the corrupted root
fs that is of much more concern than /boot.

> I like the raid-10 idea and will have to research it some more as I 
> understand the idea behind "near" and "far" on raid10, but having never 
> used raid-10, I don't "grok" that idea, understand it well enough to have 
> appreciated the possibility for lose-an-two, before you suggested it.

To grok the other layouts, it helps to think of the simple two disk case.
A far layout is like having a raid0 across the first half of the disk, then
mirroring the whole first half of the disk onto the second half of the other
disk.  Offset has the mirror on the next stripe so each stripe is interleaved
with a mirror stripe, rather than having all original, then all mirrors after.

It looks like mdadm won't let you use both at once, so you'd have to go with
a 3 way far or offset.  Also I was wrong about the additional space.  You
would only get 25% more space since you still have 3 copies of all data so
you get 4/3 times the space, but you will get much better throughput since
it is striped across all 4 disks.  Far gives better sequential read since it
reads just like a raid0, but writes have to seek all the way across the disk
to write the backup.  Offset requires seeks between each stripe on read, but
the writes don't have to seek to write the backup.

You also could do a raid6 and get the double failure tolerance, and two disks
worth of capacity, but not as much read throughput as raid10.

> But I believe I'll keep multiple raids for much the same reason I keep 
> multiple partitions, it's a FAR more robust solution than having all 
> one's eggs in one RAID basket.

True.

> Besides, I actually did try a single partitioned RAID (well, two, one for 
> all the working copies, one for the backups) when I first setup md/raid, 
> and came to the conclusion that the recovery time on that big a raid is 
> rather longer than I like to be dealing with it.  Multiple raids, with 
> the ones I'm not using ATM offline, means I don't have to worry about 
> recovering the entire thing, only the raids that were online and actually 
> dirty at the time of crash or whatever.  And of course write-intent 
> bitmaps means even shorter recovery time in most cases, so between 
> multiple raids and write-intent-bitmaps, a recovery that would take 2-3 
> hours with my original all-in-one raid setup, now often takes < 5 
> minutes! =:^)  Even with write-intent-bitmaps, I'd hate to go back to big 
> all-in-one raids, for recovery reasons alone, and between that and the 
> additional robustness of multiple raids, I just don't see myself doing 
> that any time soon.

Depends on what you mean by recovery.  Re-adding a drive that you removed
will be faster with multiple raids ( though write-intent bitmaps also take
care of that ), but if you actually have a failed disk and have to replace
it with a new one, you still have to do a rebuild on all of the raids
so it ends up taking the same total time.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPNwIZAAoJEJrBOlT6nu754yUIAL79DHhanAC0SWaXFBYTT4T2
N2xG3ved177BXX0VhKCcoYcWFiSerWzAnPlZsUDzMfaHDxBNF4ATsnboY31rCG1j
QJE3Oz9Cop45xhTBrMcwYs+woR+0HAmYb1Qa1aKrNwG0d6XlfZsLFBFUtrB411lX
erOS77EsT2BYaumanvouM8vm5LG9ZrOItiELI7rm+hEcw64p3rjkUkvBG5nTdj8K
0x7tYgUHEZNngMSx4rMTUFTlx9485gn7eJ2hT1gbVNmRcCGwotTpOTXoJMh3csbF
jYbUJKqK0n+gxhHSW/+KJBTlb1gbZpuaiibqpQnUlOecI/Fmj2MpHQnZ4WSNpc8=
=HjvY
-----END PGP SIGNATURE-----
