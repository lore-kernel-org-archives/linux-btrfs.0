Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:45096 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbaKTU0c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Nov 2014 15:26:32 -0500
Received: by mail-qa0-f46.google.com with SMTP id u7so2474135qaz.5
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Nov 2014 12:26:32 -0800 (PST)
Message-ID: <546E4E6A.3060208@ubuntu.com>
Date: Thu, 20 Nov 2014 15:26:18 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>	<546AF572.2020101@swiftspirit.co.za> <20141118153526.GS20972@merlins.org>	<47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>	<546BB2EA.5080809@ubuntu.com> <pan$7c051$a7c25939$cafa59e$f63379c9@cox.net> <546CC04F.6040207@ubuntu.com> <546D0609.9040105@pobox.com> <546D0FEA.5000608@ubuntu.com> <546D18D9.60201@pobox.com>
In-Reply-To: <546D18D9.60201@pobox.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/19/2014 5:25 PM, Robert White wrote:
> The controller, the thing that sets the ready bit and sends the 
> interrupt is distinct from the driver, the thing that polls the
> ready bit when the interrupt is sent. At the bus level there are
> fixed delays and retries. Try putting two drives on a pin-select
> IDE bus and strapping them both as _slave_ (or indeed master)
> sometime and watch the shower of fixed delay retries.

No, it does not.  In classical IDE, the "controller" is really just a
bus bridge.  When you read from the status register in the controller,
the read bus cycle is propagated down the IDE ribbon, and into the
drive, and you are in fact, reading the register directly from the
drive.  That is where the name Integrated Device Electronics came
from: because the controller was really integrated into the drive.

The only fixed delays at the bus level are the bus cycle speed.  There
are no retries.  There are only 3 mentions of the word "retry" in the
ATA8-APT and they all refer to the host driver.

> That's odd... my bios reads from storage to boot the device and it
> does so using the ACPI storage methods.

No, it doesn't.  It does so by accessing the IDE or ACHI registers
just as pc bios always has.  I suppose I also need to remind you that
we are talking about the context of linux here, and linux does not
make use of the bios for disk access.

> ACPI 4.0 Specification Section 9.8 even disagrees with you at some
> length.
> 
> Let's just do the titles shall we:
> 
> 9.8 ATA Controller Devices 9.8.1 Objects for both ATA and SATA
> Controllers. 9.8.2 IDE Controller Device 9.8.3 Serial ATA (SATA)
> controller Device
> 
> Oh, and _lookie_ _here_ in Linux Kernel Menuconfig at Device
> Drivers -> <*> Serial ATA and Parallel ATA drivers (libata) -> <*>
> ACPI firmware driver for PATA
> 
> CONFIG_PATA_ACPI:
> 
> This option enables an ACPI method driver which drives motherboard
> PATA controller interfaces through the ACPI firmware in the BIOS.
> This driver can sometimes handle otherwise unsupported hardware.
> 
> You are a storage _genius_ for knowing that all that stuff doesn't 
> exist... the rest of us must simply muddle along in our
> delusion...

Yes, ACPI 4.0 added this mess.  I have yet to see a single system that
actually implements it.  I can't believe they even bothered adding
this driver to the kernel.  Is there anyone in the world who has ever
used it?  If no motherboard vendor has bothered implementing the ACPI
FAN specs, I very much doubt anyone will ever bother with this.

> Do tell us more... I didn't say the driver would cause long delays,
> I said that the time it takes to error out other improperly
> supported drivers and fall back to this one could induce long
> delays and resets.

There is no "error out" and "fall back".  If the device is in AHCI
mode then it identifies itself as such and the ACHI driver is loaded.
 If it is in IDE mode, then it identifies itself as such, and the IDE
driver is loaded.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUbk5qAAoJEI5FoCIzSKrw++IH/2DAayNzDqKlA7DBi79UVlpg
jJHDOlmzPqJCLMkffZRX1TLM/OEzu3k/pYMlS0HCdNggbG7eTpHxsoCetiETPcnc
LCcolWXa/eMfzkEphSq4GToeEj5FKrVNzymNvPVL6zdiSfySvSg4RZOs123ULYNM
nPUaOYPSiDPzfC7ggUS3RSvWb8mNzfRVJtgGXlZd/jDh+NAjy3oTb4fYksZjq8qb
n5emKU1jJafvSbBek41wo7Xji1vLThiDZ4kcf4c7oT3x4WuQUMUhzkficqEnwYsm
HK12pv0ktDJr6hKMcHPT26YKsdUOPE6XC3GgNaxt8EZ3bioWYRb4RRAdAuAjI2s=
=+M2o
-----END PGP SIGNATURE-----
