Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-10v.sys.comcast.net ([96.114.154.169]:38423 "EHLO
	resqmta-po-10v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756974AbaKSWZl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Nov 2014 17:25:41 -0500
Message-ID: <546D18D9.60201@pobox.com>
Date: Wed, 19 Nov 2014 14:25:29 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Phillip Susi <psusi@ubuntu.com>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>	<546AF572.2020101@swiftspirit.co.za> <20141118153526.GS20972@merlins.org>	<47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>	<546BB2EA.5080809@ubuntu.com> <pan$7c051$a7c25939$cafa59e$f63379c9@cox.net> <546CC04F.6040207@ubuntu.com> <546D0609.9040105@pobox.com> <546D0FEA.5000608@ubuntu.com>
In-Reply-To: <546D0FEA.5000608@ubuntu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Shame you already know everything?

On 11/19/2014 01:47 PM, Phillip Susi wrote:
> On 11/19/2014 4:05 PM, Robert White wrote:


>
>> One of the reasons that the whole industry has started favoring
>> point-to-point (SATA, SAS) or physical intercessor chaining
>> point-to-point (eSATA) buses is to remove a lot of those
>> wait-and-see delays.
>
> Nope... even with the ancient PIO mode PATA interface, you polled a
> ready bit in the status register to see if it was done yet.  If you
> always waited 30 seconds for every command your system wouldn't boot
> up until next year.

The controller, the thing that sets the ready bit and sends the 
interrupt is distinct from the driver, the thing that polls the ready 
bit when the interrupt is sent. At the bus level there are fixed delays 
and retries. Try putting two drives on a pin-select IDE bus and 
strapping them both as _slave_ (or indeed master) sometime and watch the 
shower of fixed delay retries.

>> Another strong actor is selecting the wrong storage controller
>> chipset driver. In that case you may be faling back from high-end
>> device you think it is, through intermediate chip-set, and back to
>> ACPI or BIOS emulation
>
> There is no such thing as ACPI or BIOS emulation.

That's odd... my bios reads from storage to boot the device and it does 
so using the ACPI storage methods.

ACPI 4.0 Specification Section 9.8 even disagrees with you at some length.

Let's just do the titles shall we:

9.8 ATA Controller Devices
9.8.1 Objects for both ATA and SATA Controllers.
9.8.2 IDE Controller Device
9.8.3 Serial ATA (SATA) controller Device

Oh, and _lookie_ _here_ in Linux Kernel Menuconfig at
Device Drivers ->
  <*> Serial ATA and Parallel ATA drivers (libata) ->
   <*> ACPI firmware driver for PATA

CONFIG_PATA_ACPI:

This option enables an ACPI method driver which drives motherboard PATA 
controller interfaces through the ACPI firmware in the BIOS. This driver 
can sometimes handle otherwise unsupported hardware.

You are a storage _genius_ for knowing that all that stuff doesn't 
exist... the rest of us must simply muddle along in our delusion...

 > AHCI SATA
 > controllers do usually have an old IDE emulation mode instead of AHCI
 > mode, but this isn't going to cause ridiculously long delays.

Do tell us more... I didn't say the driver would cause long delays, I 
said that the time it takes to error out other improperly supported 
drivers and fall back to this one could induce long delays and resets.

I think I am done with your "expertise" in the question of all things 
storage related.

Not to be rude... but I'm physically ill and maybe I shouldn't be 
posting right now... 8-)

-- Rob.
