Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:53703 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaKYWPm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 17:15:42 -0500
Received: by mail-qc0-f174.google.com with SMTP id c9so1202065qcz.19
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 14:15:41 -0800 (PST)
Message-ID: <5474FF63.5030008@ubuntu.com>
Date: Tue, 25 Nov 2014 17:14:59 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>	<546AF572.2020101@swiftspirit.co.za> <20141118153526.GS20972@merlins.org>	<47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>	<546BB2EA.5080809@ubuntu.com>	<pan$7c051$a7c25939$cafa59e$f63379c9@cox.net>	<546CC04F.6040207@ubuntu.com> <pan$440ce$23845ab3$4bdb3665$b30296cb@cox.net>
In-Reply-To: <pan$440ce$23845ab3$4bdb3665$b30296cb@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/19/2014 6:59 PM, Duncan wrote:
> It's not physical spinup, but electronic device-ready.  It happens
> on SSDs too and they don't have anything to spinup.

If you have an SSD that isn't handling IO within 5 seconds or so of
power on, it is badly broken.

> But, for instance on my old seagate 300-gigs that I used to have in
> 4-way mdraid, when I tried to resume from hibernate the drives
> would be spunup and talking to the kernel, but for some seconds to
> a couple minutes or so after spinup, they'd sometimes return
> something like (example) "Seagrte3x0" instead of "Seagate300".  Of
> course that wasn't the exact string, I think it was the model
> number or perhaps the serial number or something, but looking at
> dmsg I could see the ATA layer up for each of the four devices, the
> connection establish and seem to be returning good data, then the
> mdraid layer would try to assemble and would kick out a drive or
> two due to the device string mismatch compared to what was there 
> before the hibernate.  With the string mismatch, from its
> perspective the device had disappeared and been replaced with
> something else.

Again, these drives were badly broken then.  Even if it needs extra
time to come up for some reason, it shouldn't be reporting that it is
ready and returning incorrect information.

> And now I seen similar behavior resuming from suspend (the old
> hardware wouldn't resume from suspend to ram, only hibernate, the
> new hardware resumes from suspend to ram just fine, but I had
> trouble getting it to resume from hibernate back when I first setup
> and tried it; I've not tried hibernate since and didn't even setup
> swap to hibernate to when I got the SSDs so I've not tried it for a
> couple years) on SSDs with btrfs raid.  Btrfs isn't as informative
> as was mdraid on why it kicks a device, but dmesg says both devices
> are up, while btrfs is suddenly spitting errors on one device.  A
> reboot later and both devices are back in the btrfs and I can do a
> scrub to resync, which generally finds and fixes errors on the
> btrfs that were writable (/home and /var/log), but of course not on
> the btrfs mounted as root, since it's read-only by default.

Several months back I was working on some patches to avoid blocking a
resume until after all disks had spun up ( someone else ended up
getting a different version merged to the mainline kernel ).  I looked
quite hard at the timings of things during suspend and found that my
ssd was ready and handling IO darn near instantly and the hd ( 5900
rpm wd green at the time ) took something like 7 seconds before it was
completing IO.  These days I'm running a raid10 on 3 7200 rpm blues
and it comes right up from suspend with no problems, just as it should.

> The paper specifically mentioned that it wasn't necessarily the
> more expensive devices that were the best, either, but the ones
> that faired best did tend to have longer device-ready times.  The
> conclusion was that a lot of devices are cutting corners on
> device-ready, gambling that in normal use they'll work fine,
> leading to an acceptable return rate, and evidently, the gamble
> pays off most of the time.

I believe I read the same study and don't recall any such conclusion.
 Instead the conclusion was that the badly behaving drives aren't
ordering their internal writes correctly and flushing their metadata
from ram to flash before completing the write request.  The problem
was on the power *loss* side, not the power application.

> The spinning rust in that study faired far better, with I think
> none of the devices scrambling their own firmware, and while there
> was some damage to storage, it was generally far better confined.

That is because they don't have a flash translation layer to get
mucked up and prevent them from knowing where the blocks are on disk.
 The worst thing you get out of a hdd losing power during a write is
the sector it was writing is corrupted and you have to re-write it.

> My experience says otherwise.  Else explain why those problems
> occur in the first two minutes, but don't occur if I hold it at the
> grub prompt "to stabilize"for two minutes, and never during normal
> "post- stabilization" operation.  Of course perhaps there's another
> explanation for that, and I'm conflating the two things.  But so
> far, experience matches the theory.

I don't know what was broken about these drives, only that it wasn't
capacitors since those charge in milliseconds, not seconds.  Further,
all systems using microprocessors ( like the one in the drive that
controls it ) have reset circuitry that prevents them from running
until after any caps have charged enough to get the power rail up to
the required voltage.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUdP9jAAoJEI5FoCIzSKrw50IH/jkh48Z8Oh/AS/i68zT6Grtb
C98aNNQwhC2sJSvaxRBqJ1qkXY4af5DZM/SOvFdNE4qdPLBDLfg70tnTXwU4PjzN
1mHR1PR6Vgft11t0+u8TPTos669Jm8KJ21NMgY072P18Kj/+UJqNRQ+UUNikAcaM
XrTragev53F1Kzu5IrSGGjyS4ryZZNh9YioFtR3oUTh4WuCJIiiqvq1Qpno3ee+D
QrL+5/fyzEkv0fAt59lhfheb2SkWe2Po+FmmH853sPP3MfhX4blTRzQbkVqZpixb
NwsEMu/1hOGedzlZAp4i6aRRKDcl7B+R+x63frFun/kgY54gdbBEn3auoNSGuZA=
=iPNz
-----END PGP SIGNATURE-----
