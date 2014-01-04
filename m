Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:56303 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649AbaADVQu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 4 Jan 2014 16:16:50 -0500
Message-ID: <52C87A41.9030701@jrs-s.net>
Date: Sat, 04 Jan 2014 16:16:49 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
References: <52C73987.7000106@jrs-s.net>	<52C73D1A.8060805@gmail.com>	<52C7402A.7050605@jrs-s.net> <CAOjFWZ7zC3=4oH6=SBZA+PhZMrSK1KjxoRN6L2vqd=GTBKKTQA@mail.gmail.com> <52C74B00.7080906@jrs-s.net> <03E88FCB-C473-4978-B682-076B90039E0E@colorremedies.com> <52C77903.9060408@jrs-s.net> <241D8699-CA7A-433E-B573-012F44026411@colorremedies.com>
In-Reply-To: <241D8699-CA7A-433E-B573-012F44026411@colorremedies.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/04/2014 02:18 PM, Chris Murphy wrote:
> I'm not sure what else you're referring to?(working on boot 
> environment of btrfs)

Just the string of caveats regarding mounting at boot time - needing to 
monkeypatch 00_header to avoid the bogus sparse file error (which, 
worse, tells you to press a key when pressing a key does nothing) 
followed by this, in my opinion completely unexpected, behavior when 
missing a disk in a fault-tolerant array, which also requires 
monkey-patching in fstab and now elsewhere in GRUB to avoid.

Please keep in mind - I think we got off on the wrong foot here, and I'm 
sorry for my part in that, it was unintentional. I *love* btrfs, and 
think the devs are doing incredible work. I'm excited about it. I'm 
aware it's not intended for production yet. However, it's just on the 
cusp, with distributions not only including it in their installers but a 
couple teetering on the fence with declaring it their next default FS 
(Oracle Unbreakable, OpenSuse, hell even RedHat was flirting with the 
idea) that it seems to me some extra testing with an eye towards 
production isn't a bad thing. That's why I'm here. Not to crap on 
anybody, but to get involved, hopefully helpfully.

> fs_passno is 1 which doesn't apply to Btrfs.
Again, that's the distribution's default, so the argument should be with 
them, not me... with that said, I'd respectfully argue that fs_passno 1 
is correct for any root file system; if the file system itself declines 
to run an fsck that's up to the filesystem, but it's correct to specify 
fs_passno 1 if the filesystem is to be mounted as root in the first place.

I'm open to hearing why that's a bad idea, if you have a specific reason?

> Well actually LVM thinp does have fast snapshots without requiring 
> preallocation, and uses COW.

LVM's snapshots aren't very useful for me - there's a performance 
penalty while you have them in place, so they're best used as a 
transient use-then-immediately-delete feature, for instance for 
rsync'ing off a database binary. Until recently, there also wasn't a 
good way to roll back an LV to a snapshot, and even now, that can be 
pretty problematic. Finally, there's no way to get a partial copy of an 
LV snapshot out of the snapshot and back into production, so if eg you 
have virtual machines of significant size, you could be looking at 
*hours* of file copy operations to restore an individual VM out of a 
snapshot (if you even have the drive space available for it), as 
compared to btrfs' cp --reflink=always operation, which allows you to do 
the same thing instantaneously.

FWIW, I think the ability to do cp --reflink=always is one of the big 
killer features that makes btrfs more attractive than zfs (which, again 
FWIW, I have 5+ years of experience with, and is my current primary 
storage system).

> I'm not sure what you mean by self-correcting, but if the drive 
> reports a read error md, lvm, and Btrfs raid1+ all will get missing 
> data from mirror/parity reconstruction, and write corrected data back 
> to the bad sector.

You're assuming that the drive will actually *report* a read error, 
which is frequently not the case. I have a production ZFS array right 
now that I need to replace an Intel SSD on - the SSD has thrown > 10K 
checksum errors in six months. Zero read or write errors. Neither 
hardware RAID nor mdraid nor LVM would have helped me there.

Since running filesystems that do block-level checksumming, I have 
become aware that bitrot happens without hardware errors getting thrown 
FAR more frequently than I would have thought before having the tools to 
spot it. ZFS, and now btrfs, are the only tools at hand that can 
actually prevent it.
