Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-12v.sys.comcast.net ([69.252.207.44]:55528 "EHLO
	resqmta-ch2-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933694AbaKSVFR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Nov 2014 16:05:17 -0500
Message-ID: <546D0609.9040105@pobox.com>
Date: Wed, 19 Nov 2014 13:05:13 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Phillip Susi <psusi@ubuntu.com>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>	<546AF572.2020101@swiftspirit.co.za> <20141118153526.GS20972@merlins.org>	<47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>	<546BB2EA.5080809@ubuntu.com> <pan$7c051$a7c25939$cafa59e$f63379c9@cox.net> <546CC04F.6040207@ubuntu.com>
In-Reply-To: <546CC04F.6040207@ubuntu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/19/2014 08:07 AM, Phillip Susi wrote:
> On 11/18/2014 9:46 PM, Duncan wrote:
>> I'm not sure about normal operation, but certainly, many drives
>> take longer than 30 seconds to stabilize after power-on, and I
>> routinely see resets during this time.
>
> As far as I have seen, typical drive spin up time is on the order of
> 3-7 seconds.  Hell, I remember my pair of first generation seagate
> cheetah 15,000 rpm drives seemed to take *forever* to spin up and that
> still was maybe only 15 seconds.  If a drive takes longer than 30
> seconds, then there is something wrong with it.  I figure there is a
> reason why spin up time is tracked by SMART so it seems like long spin
> up time is a sign of a sick drive.

I was recently re-factoring Underdog (http://underdog.sourceforge.net) 
startup scripts to separate out the various startup domains (e.g. lvm, 
luks, mdadm) in the prtotype init.

So I notice you (Duncan) use the word "stabilize", as do a small number 
of drivers in the linux kernel. This word has very little to do with 
"disks" per se.

Between SCSI probing LUNs (where the controller tries every theoretical 
address and gives a potential device ample time to reply), and 
usb-storage having a simple timer delay set for each volume it sees, 
there is a lot of "waiting in the name of safety" going on in the linux 
kernel at device initialization.

When I added the messages "scanning /dev/sd??" to the startup sequence 
as I iterate through the disks and partitions present I discovered that 
the first time I called blkid (e.g. right between /dev/sda and 
/dev/sda1) I'd get a huge hit of many human seconds (I didn't time it, 
but I'd say eight or so) just for having a 2Tb My Book WD 3.0 disk 
enclosure attached as /dev/sdc. This enclosure having "spun up" in the 
previous boot cycle and only bing a soft reboot was immaterial. In this 
case usb-store is going to take its time and do its deal regardless of 
the state of the physical drive itself.

So there are _lots_ of places where you are going to get delays and very 
few of them involve the disk itself going from power-off to ready.

You said it yourself with respect to SSDs.

It's cheaper, and less error prone, and less likely to generate customer 
returns if the generic controller chips just "send init, wait a fixed 
delay, then request a status" compared to trying to "are-you-there-yet" 
poll each device like a nagging child. And you are going to see that at 
every level. And you are going to see it multiply with _sparsely_ 
provisioned buses where the cycle is going to be retried for absent LUNs 
(one disk on a Wide SCSI bus and a controller set to probe all LUNs is 
particularly egregious)

One of the reasons that the whole industry has started favoring 
point-to-point (SATA, SAS) or physical intercessor chaining 
point-to-point (eSATA) buses is to remove a lot of those wait-and-see 
delays.

That said, you should not see a drive (or target enclosure, or 
controller) "reset" during spin up. In a SCSI setting this is almost 
always a cabling, termination, or addressing issue. In IDE its jumper 
mismatch (master vs slave vs cable-select). Less often its a 
partitioning issue (trying to access sectors beyond the end of the drive).

Another strong actor is selecting the wrong storage controller chipset 
driver. In that case you may be faling back from high-end device you 
think it is, through intermediate chip-set, and back to ACPI or BIOS 
emulation

Another common cause is having a dedicated hardware RAID controller 
(dell likes to put LSI MegaRaid controllers in their boxes for example), 
many mother boards have hardware RAID support available through the 
bios, etc, leaving that feature active, then the adding a drive and 
_not_ initializing that drive with the RAID controller disk setup. In 
this case the controller is going to repeatedly probe the drive for its 
proprietary controller signature blocks (and reset the drive after each 
attempt) and then finally fall back to raw block pass-through. This can 
take a long time (thirty seconds to a minute).

But seriously, if you are seeing "reset" anywhere in any storage chain 
during a normal power-on cycle then you've got a problem  with geometry 
or configuration.
