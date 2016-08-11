Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:45475 "EHLO
	blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbcHKTHP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Aug 2016 15:07:15 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bXvJw-0005Nl-PR
	for linux-btrfs@vger.kernel.org; Thu, 11 Aug 2016 21:07:12 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: checksum error in metadata node - best way to move root fs to
 new drive?
Date: Thu, 11 Aug 2016 19:07:07 +0000 (UTC)
Message-ID: <pan$912d3$2d5e3dbf$b96ae0e6$53dad290@cox.net>
References: <CAGdWbB5k_HmN2b4zzrnYN+ExiqeP_9Eu9mVBCHEtgZNKHfTARA@mail.gmail.com>
	<pan$d9b53$c31dc60$985cf806$b833643c@cox.net>
	<CAJCQCtTHH=q9cE-BHDYuDpUASQx4Rnzx_b3VR=v-3s_THf1f4w@mail.gmail.com>
	<CAGdWbB72DLAkV3EwO-7Sakc4gPHRT=GmU5ftxo0YfR0wjBefNQ@mail.gmail.com>
	<CAJCQCtS3c5u6hDjHdU92AdQvSECNT99vOMxLiM4tchv4nrwPmA@mail.gmail.com>
	<CAGdWbB7qNFfKy1C3Ldb8aSCxvphZeYcmrXtdiB_ECGXNLZ-K5w@mail.gmail.com>
	<CAD=QJKjZP3V3HE_iXYcLJvq65mXKiXp_aYgZuoHmQFd7mJ7j0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nicholas D Steeves posted on Thu, 11 Aug 2016 10:12:04 -0400 as excerpted:

> Why is the combination of dm-crypt|luks+btrfs+compress=lzo as overlooked
> as a potential cause?  Other than the "raid56 ate my data" I've noticed
> a bunch of "luks+btrfs+compress=lzo ate my data" threads.

My usage is btrfs on physical device (well, on GPT partitions on the 
physical device), no encryption, and it's mostly raid1 on paired devices, 
but there's definitely one kink that compress=lzo (and I believe 
compression in general, including gzip) adds, and it's possible running 
it on encryption compounds the issue.

The compression-related problem is this:  Btrfs is considerably less 
tolerant of checksum-related errors on btrfs-compressed data, and while 
on uncompressed btrfs raid1 it will recover from the second copy where 
possible and continue, on files that btrfs has compressed, if there are 
enough checksum errors, for example in a hard-shutdown situation where 
one of the raid1 devices had the updates written but it crashed while 
writing the other, btrfs will crash instead of simply falling back to the 
good copy.

This is known to be specific to compression; uncompressed btrfs recover 
as intended from the second copy.  And it's known to occur only when 
there's too many checksum errors in a burst -- the filesystem apparently 
deals correctly with just a few at a time.

This problem has been ongoing for years -- I thought it was just the way 
btrfs worked until someone mentioned that it didn't behave that way 
without compression -- and it reasonably regularly prevents a smooth 
reboot here after a crash.

In my case I have the system btrfs running read-only by default, so it's 
not damaged.  However, /home and /var/log are of course mounted writable, 
and that's where the problems come in.  If I start in (I believe) rescue 
mode (it's that or emergency, the other won't do the mounts and won't let 
me do them manually either, as it thinks a dependency is missing), 
systemd will do the mounts but not start the (permanent) logging or the 
services that need to routinely write stuff that I have symlinked into 
/home/var/whatever so they can write with a read-only root and system 
partition, I can then scrub the mounted home and log partitions to fix 
the checksum errors due to one device having the update while the other 
doesn't, and continue booting normally.  However, if I try directly 
booting normally, the system invariably crashes due to too many checksum 
errors, even when it /should/ simply read the other copy, which is fine 
as demonstrated by the fact that scrub can use it to fix the errors on 
the device triggering the checksum errors.

This continued to happen with 4.6.  I'm on 4.7 now but am not sure I've 
crashed with it and thus can't say for sure whether the problem is fixed 
there.  However, I doubt it, as the problem has been there apparently 
since the compression and raid1 features were introduced, and I didn't 
see anything mentioning a fix for the issue in the patches going by on 
the list.

The problem is most obvious and reproducible in btrfs raid1 mode, since 
there, one device /can/ be behind the other, and scrub /can/ be 
demonstrated to fix it so it's obviously a checksum issue, but I'd 
imagine if enough checksum mismatches happen on a single device in single 
mode, it would crash as well, and of course then there's no second copy 
for scrub to fix the bad copy from, so it would simply show up as a btrfs 
that can mount but with significant corruption issues that will crash the 
system if an attempt to read the affected blocks reads too many at a time.

And to whatever possible extent an encryption layer between the physical 
device and btrfs results in possible additional corruption in the event 
of a crash or hard shutdown, it could easily compound an already bad 
situation.

Meanwhile, /if/ that does turn out to be the root issue here, then 
finally fixing the btrfs compression related problem where a large burst 
of checksum failures crashes the system, even when there provably exists 
a second valid copy, but where this only happens with compression, should 
go quite far in stabilizing btrfs on encrypted underlayers.

I know I certainly wouldn't object to the problem being fixed. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

