Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51692 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864Ab3I2V3b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Sep 2013 17:29:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VQOYS-0007tS-Sc
	for linux-btrfs@vger.kernel.org; Sun, 29 Sep 2013 23:29:28 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Sep 2013 23:29:28 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Sep 2013 23:29:28 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Corrupt btrfs filesystem recovery... What best instructions?
Date: Sun, 29 Sep 2013 22:29:18 +0100
Message-ID: <l2a635$37m$1@ger.gmane.org>
References: <l27agq$u5a$1@ger.gmane.org> <l27mn1$squ$1@ger.gmane.org> <l2826k$1uc$1@ger.gmane.org> <pan$69794$b0c00066$a4aa3035$c87a3c3d@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <pan$69794$b0c00066$a4aa3035$c87a3c3d@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 29/09/13 06:11, Duncan wrote:
> Martin posted on Sun, 29 Sep 2013 03:10:37 +0100 as excerpted:
> 
>> So...
>>
>> Any options for btrfsck to fix things?
>>
>> Or is anything/everything that is fixable automatically fixed on the
>> next mount?
>>
>> Or should:
>>
>> btrfs scrub /dev/sdX
>>
>> be run first?
>>
>> Or?
>>
>>
>> What does btrfs do (or can do) for recovery?
> 
> Here's a general-case answer (courtesy gmane) to the order in which to 
> try recovery question, that Hugo posted a few weeks ago:
> 
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/27999

Thanks for that. Very well found!

The instructions from Hugo are:

####
   Let's assume that you don't have a physical device failure (which
is a different set of tools -- mount -odegraded, btrfs dev del
missing).

   First thing to do is to take a btrfs-image -c9 -t4 of the
filesystem, and keep a copy of the output to show josef. :)

   Then start with -orecovery and -oro,recovery for pretty much
anything.

   If those fail, then look in dmesg for errors relating to the log
tree -- if that's corrupt and can't be read (or causes a crash), use
btrfs-zero-log.

   If there's problems with the chunk tree -- the only one I've seen
recently was reporting something like "can't map address" -- then
chunk-recover may be of use.

   After that, btrfsck is probably the next thing to try. If options
-s1, -s2, -s3 have any success, then btrfs-select-super will help by
replacing the superblock with one that works. If that's not going to
be useful, fall back to btrfsck --repair.

   Finally, btrfsck --repair --init-extent-tree may be necessary if
there's a damaged extent tree. Finally, if you've got corruption in
the checksums, there's --init-csum-tree.

   Hugo.
####

Those will be tried next...



> Note that in specific cases someone who knew what they were doing could 
> omit some steps and focus on others, but I'm not at that level of "know 
> what I'm doing", so...
> 
> Scrub... would go before this, if it's useful.  But scrub depends on a 
> second, valid copy being available in ordered to fix the bad-checksum 
> one.  On a single device btrfs, btrfs defaults to DUP metadata (unless 
> it's SSD), so you may have a second copy for that, but you won't have a 
> second copy of the data.  This is a very strong reason to go btrfs raid1 
> mode (for both data and metadata) if you can, because that gives you a 
> second copy of everything, thereby actually making use of btrfs' checksum 
> and scrub ability.  (Unfortunately, there is as yet no way to do N-way 
> mirroring, there's only the second copy not a third, no matter how many 
> devices you have in that "raid1".)
> 
> Finally, if you mentioned your kernel (and btrfs-tools) version(s) I 
> missed it, but [boilerplate recommendation, stressed repeatedly both in 
> the wiki and on-list] btrfs being still labeled experimental and under 
> serious development, there's still lots of bugs fixed every kernel 
> release.  So as Chris Murphy said, if you're not on 3.11-stable or 3.12-
> rcX already, get there.  Not only can the safety of your data depend on 
> it, but by choosing to run experimental we're all testers, and our 
> reports if something does go wrong will be far more usable if we're on a 
> current kernel.  Similarly, btrfs-tools 0.20-rc1 is already somewhat old; 
> you really should be on a git-snapshot beyond that.  (The master branch 
> is kept stable, work is done in other branches and only merged to master 
> when it's considered suitably stable, so a recently updated btrfs-tools 
> master HEAD is at least in theory always the best possible version you 
> can be running.  If that's ever NOT the case, then testers need to be 
> reporting that ASAP so it can be fixed, too.)
> 
> Back to the kernel, it's worth noting that 3.12-rcX includes an option 
> that turns off most btrfs bugons by default.  Unless you're a btrfs 
> developer (which it doesn't sound like you are), you'll want to activate 
> that (turning off the bugons), as they're not helpful for ordinary users 
> and just force unnecessary reboots when something minor and otherwise 
> immediately recoverable goes wrong.  That's just one of the latest fixes.

Looking up what's available for Gentoo, the maintainers there look to be
nicely sharp with multiple versions available all the way up to kernel
3.11.2...

There's also the latest available from btrfs tools with
sys-fs/btrfs-progs "9999"...

OK, so onto the cutting edge to compile them in...


Thanks all,
Martin



