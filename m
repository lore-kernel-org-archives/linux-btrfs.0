Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.linuxsystems.it ([2.119.245.46]:41403 "EHLO
	mail2.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbcEIOxW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 May 2016 10:53:22 -0400
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: <linux-btrfs@vger.kernel.org>
Cc: Clemens Eisserer <linuxhippy@gmail.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Patrik Lundquist <patrik.lundquist@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: btrfs ate my data in just two days, after a fresh install. ram =?iso-8859-1?Q?and_disk_are_ok._it_still_mounts,_but_I_cannot_repair?=
Date: Mon, 09 May 2016 16:53:13 +0200
MIME-Version: 1.0
Message-ID: <52f0c710-d695-443d-b6d5-266e3db634f8@linuxsystems.it>
In-Reply-To: <799cf552-4612-56c5-b44d-59458119e2b0@gmail.com>
References: <3bf4a554-e3b8-44e2-b8e7-d08889dcffed@linuxsystems.it>
 <CAJCQCtRAqxREr8ToorSkbsnYKKk_NPy+1oSHP6WMOnpLe=9T1g@mail.gmail.com>
 <c9bde2c9-c0f3-4bd2-a9ac-81fe0250edcc@linuxsystems.it>
 <20160505174854.GA1012@vader.dhcp.thefacebook.com>
 <585760e0-7d18-4fa0-9974-62a3d7561aee@linuxsystems.it>
 <2cd5aca36f853f3c9cf1d46c2f133aa3@linuxsystems.it>
 <CAFvQSYTQ1yZqPYyv0dmd+JuHRWfKm-RtZLdbKXQeHiWMthnyLw@mail.gmail.com>
 <f1dd07efb34a0a110f62566979530944@linuxsystems.it>
 <799cf552-4612-56c5-b44d-59458119e2b0@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On domenica 8 maggio 2016 20:27:55 CEST, Patrik Lundquist wrote:
> Are you using any power management tweaks?

Yes, as stated in my very first post I use TLP with 
SATA_LINKPWR_ON_BAT=max_performance, but I managed to reproduce the bug 
even without TLP. Also in the past week I've alwyas been on AC.

On lunedì 9 maggio 2016 13:52:16 CEST, Austin S. Hemmelgarn wrote:
> Memtest doesn't replicate typical usage patterns very well.  My 
> usual testing for RAM involves not just memtest, but also 
> booting into a LiveCD (usually SystemRescueCD), pulling down a 
> copy of the kernel source, and then running as many concurrent 
> kernel builds as cores, each with as many make jobs as cores (so 
> if you've got a quad core CPU (or a dual core with 
> hyperthreading), it would be running 4 builds with -j4 passed to 
> make).  GCC seems to have memory usage patterns that reliably 
> trigger memory errors that aren't caught by memtest, so this 
> generally gives good results.

Building kernel with 4 concurrent threads is not an issue for my system, in 
fact I do compile a lot and I never had any issue.

On lunedì 9 maggio 2016 13:52:16 CEST, Austin S. Hemmelgarn wrote:
> On a similar note, badblocks doesn't replicate filesystem like 
> access patterns, it just runs sequentially through the entire 
> disk.  This isn't as likely to give bad results, but it's still 
> important to know.  In particular, try running it over a dmcrypt 
> volume a couple of times (preferably with a different key each 
> time, pulling keys from /dev/urandom works well for this), as 
> that will result in writing different data.  For what it's 
> worth, when I'm doing initial testing of new disks, I always use 
> ddrescue to copy /dev/zero over the whole disk, then do it twice 
> through dmcrypt with different keys, copying from the disk to 
> /dev/null after each pass.  This gives random data on disk as a 
> starting point (which is good if you're going to use dmcrypt), 
> and usually triggers reallocation of any bad sectors as early as 
> possible.

While trying to find a common denominator for my issue I did lots of 
backups of /dev/mapper/cryptroot and I restored them into 
/dev/mapper/cryptroot dozens of times (triggering a 150GB+ random data 
write every time), without any issue (after restoring the backup I alwyas 
check the parition with btrfs check). So disk doesn't seem to be the 
culprit.

On lunedì 9 maggio 2016 13:52:16 CEST, Austin S. Hemmelgarn wrote:
> 1. If you have an eSATA port, try plugging your hard disk in 
> there and see if things work.  If that works but having the hard 
> drive plugged in internally doesn't, then the issue is probably 
> either that specific SATA port (in which case your chip-set is 
> bad and you should get a new system), or the SATA connector 
> itself (or the wiring, but that's not as likely when it's traces 
> on a PCB).  Normally I'd suggest just swapping cables and SATA 
> ports, but that's not really possible with a laptop.
> 2. If you have access to a reasonably large flash drive, or to 
> a USB to SATA adapter, try that as well, if it works on that but 
> not internally (or on an eSATA port), you've probably got a bad 
> SATA controller, and should get a new system.

My laptop doesn't have an eSATA port and my only big enough external drive 
is currently used for daily backups, since I fear for data loss.

On lunedì 9 maggio 2016 13:52:16 CEST, Austin S. Hemmelgarn wrote:
> 3. Try things without dmcrypt.  Adding extra layers makes it 
> harder to determine what is actually wrong.  If it works without 
> dmcrypt, try using different parameters for the encryption 
> (different ciphers is what I would try first).  If it works 
> reliably without dmcrypt, then it's either a bug in dmcrypt 
> (which I don't think is very likely), or it's bad interaction 
> between dmcrypt and BTRFS.  If it works with some encryption 
> parameters but not others, then that will help narrow down where 
> the issue is.

On domenica 8 maggio 2016 01:35:16 CEST, Chris Murphy wrote:
> You're making the troubleshooting unnecessarily difficult by
> continuing to use non-default options. *shrug*
>
> Every single layer you add complicates the setup and troubleshooting.
> Of course all of it should work together, many people do. But you're
> the one having the problem so in order to demonstrate whether this is
> a software bug or hardware problem, you need to test it with the most
> basic setup possible --> btrfs on plain partitions and default mount
> options.

I will try to recap because you obviously missed my previous e-mail: I 
managed to replicate the irrecoverable corruption bug even with default 
options and no dmcrypt at all. Somehow it was a bit more difficult to 
replicate with default options and so I started to play with different 
combinations to find if there was something which increased the chances of 
getting corruption. I have the feeling that "autodefrag" enhances the 
chances to get corruption, but I'm not 100% sure about it. Anyway, 
triggering a whole packages reinstall with "pacaur -S $(pacman -Qe)", 
giving high chances to get irrecoverable corruption. When running such 
command it simply extracts the tarballs from the cache and overwrites the 
already installed files. It doesn't write lots of data (after 
reinstallation my system is still quite small, just a few GBs) but it seems 
to be enough to displease the filesystem.

To avoid losing my data every time I power on or reboot my laptop I first 
boot into an external drive, I btrfs check /dev/mapper/cryptroot and if 
it's still sane I backup /dev/mapper/cryptroot into an external SSD with 
dd, otherwise I restore the previous copy from the SSD into 
/dev/mapper/cryptroot.
I cannot manage to survive such annoying workflow for long, so I really 
hope someone will manage to track the bug down soon.

Thanks for your help, I really appreciate it.
Niccolò
