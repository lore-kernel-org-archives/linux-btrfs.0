From: Kyle Gates <kylegates@hotmail.com>
Subject: RE: btrfs-raid questions I couldn't find an answer to on the wiki
Date: Tue, 31 Jan 2012 18:22:51 -0600
Message-ID: <COL113-DS1406F918FEA81D38635AA3B0730@phx.gbl>
References: <pan.2012.01.26.15.41.32@cox.net>,<201201291223.40161.kreijack@inwind.it>,<COL113-W485767962008EF29E7E27EB08D0@phx.gbl>,<pan.2012.01.31.05.55.47@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
To: <1i5t5.duncan@cox.net>, <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.01.31.05.55.47@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>

>> I've been having good luck with my /boot on a separate 1GB RAID1 btrfs
>> filesystem using grub2 (2 disks only! I wouldn't try it with 3). I
>> should note, however, that I'm NOT using compression on this volume
>> because if I remember correctly it may not play well with grub (maybe
>> that was just lzo though) and I'm also not using subvolumes either for
>> the same reason.
>
> Thanks! I'm on grub2 as well. It's is still masked on gentoo, but I
> recently unmasked and upgraded to it, taking advantage of the fact that I
> have two two-spindle md/raid-1s for /boot and its backup to test and
> upgrade one of them first, then the other only when I was satisfied with
> the results on the first set. I'll be using a similar strategy for the
> btrfs upgrades, only most of my md/raid-1s are 4-spindle, with two sets,
> working and backup, and I'll upgrade one set first.
>
> I'm going to keep /boot a pair of two-spindle raid-1s, but intend to make
> them btrfs-raid1s instead of md/raid-1s, and will upgrade one two-spindle
> set at a time.
>
> More on the status of grub2 btrfs-compression support based on my
> research. There is support for btrfs/gzip-compression in at least grub
> trunk. AFAIK, it's gzip-compression in grub-1.99-release and
> lzo-compression in trunk only, but I may be misremembering and it's gzip
> in trunk only and only uncompressed in grub-1.99-release.

I believe you are correct that btrfs zlib support is included in grub2 
version 1.99 and lzo is in trunk.
I'll try compressing the files on /boot for one installed kernel with the 
defrag -czlib option and see how it goes.
Result: Seemed to work just fine.

> In any event, since I'm running 128 MB /boot md/raid-1s without
> compression now, and intend to increase the size to at least a quarter
> gig to better align the following partitions, /boot is the one set of
> btrfs partitions I do NOT intend to enable compression on, so that won't
> be an issue for me here. And since for /boot I'm running a pair of
> two-spindle raid1s instead of my usual quad-spindle raid1s, you've
> confirmed that works as well. =:^)
>
> As a side note, since I only recently did the grub2 upgrade, I've been
> enjoying its ability to load and read md/raid and my current reiserfs
> directly, thus giving me the ability to look up info in at least text-
> based main system config and notes files directly from grub2, without
> booting into Linux, if for some reason the above-grub boot is hosed or
> inconvenient at that moment. I just realized that if I want to maintain
> that direct-from-grub access, I'll need to ensure that the grub2 I'm
> running groks the btrfs compression scheme I'm using on any filesystem I
> want grub2 to be able to read.
>
> Hmm... that brings up another question: You mention a 1-gig btrfs-raid1 /
> boot, but do NOT mention whether you installed it before or after mixed-
> chunk (data/metadata) support made it into btrfs and became the default
> for <= 1 gig filesystems.

I don't think I specifically enabled mixed chunk support when I created this 
filesystem. It was done on a 2.6 kernel sometime in the middle of 2011 iirc.

> Can you confirm one way or the other whether you're running mixed-chunk
> on that 1-gig? I'm not sure whether grub2's btrfs module groks mixed-
> chunk or not, or whether that even matters to it.
>
> Also, could you confirm mbr-bios vs gpt-bios vs uefi-gpt partitions? I'm
> using gpt-bios partitioning here, with the special gpt-bios-reserved
> partition, so grub2-install can build the modules necessary for /boot
> access directly into its core-image and install that in the gpt-bios-
> reserved partition. It occurs to me that either uefi-gpt or gpt-bios
> with the appropriate reserved partition won't have quite the same issues
> with grub2 reading a btrfs /boot that either mbr-bios or gpt-bios without
> a reserved bios partition would. If you're running gpt-bios with a
> reserved bios partition, that confirms yet another aspect of your setup,
> compared to mine. If you're running uefi-gpt, not so much as at least in
> theory, that's best-case. If you're running either mbr-bios or gpt-bios
> without a reserved bios partition, that's a worst-case, so if it works,
> then the others should definitely work.

Same here, gpt-bios, 1MB partition with bios_grub flag set (gdisk code EF02) 
for grub to reside on.

> Meanwhile, you're right about subvolumes. I'd not try them on a btrfs
> /boot, either. (I don't really see the use case for it, for a separate
> /boot, tho there's certainly a case for a /boot subvolume on a btrfs
> root, for people doing that.)

