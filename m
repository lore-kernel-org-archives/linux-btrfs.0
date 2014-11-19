Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:35831 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756941AbaKSVrc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Nov 2014 16:47:32 -0500
Received: by mail-qc0-f173.google.com with SMTP id i17so1200557qcy.18
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Nov 2014 13:47:31 -0800 (PST)
Message-ID: <546D0FEA.5000608@ubuntu.com>
Date: Wed, 19 Nov 2014 16:47:22 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>	<546AF572.2020101@swiftspirit.co.za> <20141118153526.GS20972@merlins.org>	<47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>	<546BB2EA.5080809@ubuntu.com> <pan$7c051$a7c25939$cafa59e$f63379c9@cox.net> <546CC04F.6040207@ubuntu.com> <546D0609.9040105@pobox.com>
In-Reply-To: <546D0609.9040105@pobox.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/19/2014 4:05 PM, Robert White wrote:
> It's cheaper, and less error prone, and less likely to generate
> customer returns if the generic controller chips just "send init,
> wait a fixed delay, then request a status" compared to trying to
> "are-you-there-yet" poll each device like a nagging child. And you
> are going to see that at every level. And you are going to see it
> multiply with _sparsely_ provisioned buses where the cycle is going
> to be retried for absent LUNs (one disk on a Wide SCSI bus and a
> controller set to probe all LUNs is particularly egregious)

No, they do not wait a fixed time, then proceed.  They do in fact
issue the command, then poll or wait for an interrupt to know when it
is done, then time out and give up if that doesn't happen within a
reasonable amount of time.

> One of the reasons that the whole industry has started favoring 
> point-to-point (SATA, SAS) or physical intercessor chaining 
> point-to-point (eSATA) buses is to remove a lot of those
> wait-and-see delays.

Nope... even with the ancient PIO mode PATA interface, you polled a
ready bit in the status register to see if it was done yet.  If you
always waited 30 seconds for every command your system wouldn't boot
up until next year.

> Another strong actor is selecting the wrong storage controller
> chipset driver. In that case you may be faling back from high-end
> device you think it is, through intermediate chip-set, and back to
> ACPI or BIOS emulation

There is no such thing as ACPI or BIOS emulation.  AHCI SATA
controllers do usually have an old IDE emulation mode instead of AHCI
mode, but this isn't going to cause ridiculously long delays.

> Another common cause is having a dedicated hardware RAID
> controller (dell likes to put LSI MegaRaid controllers in their
> boxes for example), many mother boards have hardware RAID support
> available through the bios, etc, leaving that feature active, then
> the adding a drive and

That would be fake raid, not hardware raid.

> _not_ initializing that drive with the RAID controller disk setup.
> In this case the controller is going to repeatedly probe the drive
> for its proprietary controller signature blocks (and reset the
> drive after each attempt) and then finally fall back to raw block
> pass-through. This can take a long time (thirty seconds to a
> minute).

No, no, and no.  If it reads the drive and does not find its metadata,
it falls back to pass through.  The actual read takes only
milliseconds, though it may have to wait a few seconds for the drive
to spin up.  There is no reason it would keep retrying after a
successful read.

The way you end up with 30-60 second startup time with a raid is if
you have several drives and staggered spinup mode enabled, then each
drive is started one at a time instead of all at once so their
cumulative startup time can add up fairly high.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUbQ/qAAoJEI5FoCIzSKrwuhwH/R/+EVTpNlw36naJ8mxqMagt
/xafq+1kGhwNjLTPV68CI4Wt24WSGOLqpq5FPWlTMxuN0VSnX/wqBeSbz4w2Vl3F
VNic+4RqhmzS3EnLXNzkHyF2Z+hQEEldOlheAobkQb4hv/7jVxBri42nMdHQUq5w
em181txT8zkltmV+dm8aYcro8Z4ewntQtyGaO6U/nCfxt9Odr2rfytyeuSyJi9uY
+dKlGSb5klIFwCOOSoRqEz2+KOFHF7td9RrcfIRcPRgjKROH0YilQ8T53lTMoNL1
aUMsbyUy+edEBN1a4o/FqK3dEvBSu1nnRGRpSgm2fFGKhyi/z9gmJ1ZXTdYZRXE=
=/O7+
-----END PGP SIGNATURE-----
