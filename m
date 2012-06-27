Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:42735 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab2F0BiS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 21:38:18 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.77 #2)
	id 1SjhD0-00012K-5C
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 18:38:18 -0700
Date: Tue, 26 Jun 2012 18:38:18 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Long btrfs hangs during suspend to RAM / BTRFS warning (device dm-0): Aborting unused transaction
Message-ID: <20120627013818.GA3556@merlins.org>
References: <20120626193637.GA27856@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120626193637.GA27856@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 26, 2012 at 12:36:37PM -0700, Marc MERLIN wrote:
> I was fine with btrfs until 3.2.16, but when going to 3.4 or 3.4.4, I'm
> having my system randomly not wanting to suspend to RAM.
> 
> My suspend light started flashing but the system wasn't suspending.
> I was able to unlock X, run top, saw that btrfs-delalloc-??? was taking
> 98% CPU, and any command that touched disk hung 
> (so I could log in, but would not get a shell).
> 
> I did the sysrq commands, which took a long time to work (they stacked
> up with nothing happening and maybe 10mn later, the system unhung itself
> and they ran, maybe too late, not sure).
> 
> Interestingly the system did go to sleep and resumed ok after that, it
> just took 20mn to get there.
> 
> It's all pasted below.
> 
> gandalfthegreat:~# btrfs fi show
> Label: 'btrfs_pool1'  uuid: 873d526c-e911-4234-af1b-239889cd143d
> 	Total devices 1 FS bytes used 214.44GB
> 	devid    1 size 231.02GB used 231.02GB path /dev/dm-0
> 
> Btrfs Btrfs v0.19
> gandalfthegreat:~# 

Now, I'm also seeing these below and I have this again (86% CPU):
 6076 root      20   0     0    0    0 R   86  0.0  29:40.11 btrfs-delalloc-    

How bad is it, doctor?  I think I'll be going back to 3.2.16 for now though.

[100415.369301] BTRFS warning (device dm-0): Aborting unused transaction.
[100415.739337] BTRFS warning (device dm-0): Aborting unused transaction.
[100416.093839] BTRFS warning (device dm-0): Aborting unused transaction.
[100416.433245] BTRFS warning (device dm-0): Aborting unused transaction.
[100709.352445] usb 1-5: USB disconnect, device number 8
[100710.197602] thinkpad_acpi: EC reports that Thermal Table has changed
[100710.199954] ACPI: \_SB_.GDCK - undocking
[100711.358679] wlan0: deauthenticating from 00:24:6c:67:03:d1 by local choice (reason=3)
[100713.044214] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[101447.801190] btrfs no csum found for inode 3910588 start 5144576
[101447.802277] btrfs csum failed ino 3910588 off 5144576 csum 2096800889 private 0
[101447.957161] btrfs no csum found for inode 3910588 start 5996544
[101447.957990] btrfs csum failed ino 3910588 off 5996544 csum 2096800889 private 0
[101447.960459] btrfs no csum found for inode 3910588 start 6062080
[101447.961351] btrfs csum failed ino 3910588 off 6062080 csum 2096800889 private 0
[101447.962459] btrfs no csum found for inode 3910588 start 6225920
[101447.963543] btrfs csum failed ino 3910588 off 6225920 csum 2096800889 private 0
[101447.964369] btrfs no csum found for inode 3910588 start 6291456
[101447.965045] btrfs csum failed ino 3910588 off 6291456 csum 2096800889 private 0
[101447.966406] btrfs no csum found for inode 3910588 start 6356992
[101447.967392] btrfs csum failed ino 3910588 off 6356992 csum 2123070294 private 0
[101448.088912] btrfs no csum found for inode 3910588 start 6553600
[101448.088971] btrfs no csum found for inode 3910588 start 6586368
[101448.090058] btrfs csum failed ino 3910588 off 6586368 csum 2096800889 private 0
[101448.090305] btrfs csum failed ino 3910588 off 6553600 csum 4253301504 private 0
[101448.093231] btrfs no csum found for inode 3910588 start 6717440
[101448.094269] btrfs csum failed ino 3910588 off 6717440 csum 2096800889 private 0
[101448.096104] btrfs no csum found for inode 3910588 start 6848512
[101448.097002] btrfs csum failed ino 3910588 off 6848512 csum 3282939717 private 0
[101448.098249] btrfs no csum found for inode 3910588 start 6946816
[101448.101561] btrfs no csum found for inode 3910588 start 7045120
[101448.106352] btrfs no csum found for inode 3910588 start 7176192
[101448.108224] btrfs no csum found for inode 3910588 start 7241728
[101448.111133] btrfs no csum found for inode 3910588 start 7307264
[101448.127081] btrfs no csum found for inode 3910588 start 7569408
[101448.144351] btrfs no csum found for inode 3910588 start 7864320
[101448.155857] btrfs no csum found for inode 3910588 start 8060928
[101448.165868] btrfs no csum found for inode 3910588 start 8257536
[101448.175275] btrfs no csum found for inode 3910588 start 8454144
[101448.176087] btrfs no csum found for inode 3910588 start 8552448
[101448.180927] btrfs no csum found for inode 3910588 start 8847360
[101448.183489] btrfs no csum found for inode 3910588 start 8978432
[101448.192909] btrfs no csum found for inode 3910588 start 9371648
[101448.198959] btrfs no csum found for inode 3910588 start 9568256
[101448.413716] btrfs no csum found for inode 3910588 start 5439488
[101448.413996] btrfs no csum found for inode 3910588 start 5537792
[101448.414379] btrfs no csum found for inode 3910588 start 5603328
[101448.416386] btrfs no csum found for inode 3910588 start 5734400
[101448.424108] btrfs no csum found for inode 3910588 start 5799936
[101448.721649] btrfs no csum found for inode 3910588 start 9699328
[101448.737377] btrfs no csum found for inode 3910588 start 9863168
[101448.743929] btrfs no csum found for inode 3910588 start 10027008
[101448.753186] btrfs no csum found for inode 3910588 start 10158080
[101448.762406] btrfs no csum found for inode 3910588 start 10256384
[101448.765143] btrfs no csum found for inode 3910588 start 10354688
[102230.473794] BTRFS warning (device dm-0): Aborting unused transaction.
[102231.154304] BTRFS warning (device dm-0): Aborting unused transaction.
[102231.816380] BTRFS warning (device dm-0): Aborting unused transaction.
[102231.845170] btrfs no csum found for inode 3910562 start 0
[102231.855415] btrfs_readpage_end_io_hook: 26 callbacks suppressed
[102231.855418] btrfs csum failed ino 3910562 off 0 csum 3145117582 private 0
[102231.999555] btrfs no csum found for inode 3910588 start 294912
[102232.009479] btrfs csum failed ino 3910588 off 294912 csum 697692408 private 0
[102232.142602] btrfs no csum found for inode 3910588 start 360448
[102232.142661] btrfs no csum found for inode 3910588 start 393216
[102232.157527] btrfs csum failed ino 3910588 off 360448 csum 66868660 private 0
[102232.158415] btrfs csum failed ino 3910588 off 393216 csum 230387419 private 0
[102232.968939] BTRFS warning (device dm-0): Aborting unused transaction.
[102234.107914] BTRFS warning (device dm-0): Aborting unused transaction.
[102235.218139] BTRFS warning (device dm-0): Aborting unused transaction.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
