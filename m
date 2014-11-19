Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:39023 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994AbaKSQHv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Nov 2014 11:07:51 -0500
Received: by mail-qg0-f47.google.com with SMTP id z60so637033qgd.6
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Nov 2014 08:07:51 -0800 (PST)
Message-ID: <546CC04F.6040207@ubuntu.com>
Date: Wed, 19 Nov 2014 11:07:43 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>	<546AF572.2020101@swiftspirit.co.za> <20141118153526.GS20972@merlins.org>	<47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>	<546BB2EA.5080809@ubuntu.com> <pan$7c051$a7c25939$cafa59e$f63379c9@cox.net>
In-Reply-To: <pan$7c051$a7c25939$cafa59e$f63379c9@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/18/2014 9:46 PM, Duncan wrote:
> I'm not sure about normal operation, but certainly, many drives
> take longer than 30 seconds to stabilize after power-on, and I
> routinely see resets during this time.

As far as I have seen, typical drive spin up time is on the order of
3-7 seconds.  Hell, I remember my pair of first generation seagate
cheetah 15,000 rpm drives seemed to take *forever* to spin up and that
still was maybe only 15 seconds.  If a drive takes longer than 30
seconds, then there is something wrong with it.  I figure there is a
reason why spin up time is tracked by SMART so it seems like long spin
up time is a sign of a sick drive.

> This doesn't happen on single-hardware-device block devices and 
> filesystems because in that case it's either up or down, if the
> device doesn't come up in time the resume simply fails entirely,
> instead of coming up with one or more devices there, but others
> missing as they didn't stabilize in time, as is unfortunately all
> too common in the multi- device scenario.

No, the resume doesn't "fail entirely".  The drive is reset, and the
IO request is retried, and by then it should succeed.

> I've seen this with both spinning rust and with SSDs, with mdraid
> and btrfs, with multiple mobos and device controllers, and with
> resume both from suspend to ram (if the machine powers down the
> storage devices in that case, as most modern ones do) and hibernate
> to permanent storage device, over several years worth of kernel
> series, so it's a reasonably widespread phenomena, at least among
> consumer-level SATA devices.  (My experience doesn't extend to
> enterprise-raid-level devices or proper SCSI, etc, so I simply
> don't know, there.)

If you are restoring from hibernation, then the drives are already
spun up before the kernel is loaded.

> While two minutes is getting a bit long, I think it's still within
> normal range, and some devices definitely take over a minute enough
> of the time to be both noticeable and irritating.

It certainly is not normal for a drive to take that long to spin up.
IIRC, the 30 second timeout comes from the ATA specs which state that
it can take up to 30 seconds for a drive to spin up.

> That said, I SHOULD say I'd be far *MORE* irritated if the device
> simply pretended it was stable and started reading/writing data
> before it really had stabilized, particularly with SSDs where that
> sort of behavior has been observed and is known to put some devices
> at risk of complete scrambling of either media or firmware, beyond
> recovery at times.  That of course is the risk of going the other
> direction, and I'd a WHOLE lot rather have devices play it safe for
> another 30 seconds or so after they / think/ they're stable and be
> SURE, than pretend to be just fine when voltages have NOT
> stabilized yet and thus end up scrambling things irrecoverably.
> I've never had that happen here tho I've never stress- tested for
> it, only done normal operation, but I've seen testing reports where
> the testers DID make it happen surprisingly easily, to a surprising
>  number of their test devices.

Power supply voltage is stable within milliseconds.  What takes HDDs
time to start up is mechanically bringing the spinning rust up to
speed.  On SSDs, I think you are confusing testing done on power
*cycling* ( i.e. yanking the power cord in the middle of a write )
with startup.

> So, umm... I suspect the 2-minute default is 2 minutes due to
> power-up stabilizing issues, where two minutes is a reasonable
> compromise between failing the boot most of the time if the timeout
> is too low, and taking excessively long for very little further
> gain.

The default is 30 seconds, not 2 minutes.

> sure whether it's even possible, without some specific hardware
> feature available to tell the kernel that it has in fact NOT been
> in power-saving mode for say 5-10 minutes, hopefully long enough
> that voltage readings really /are/ fully stabilized and a shorter
> timeout is possible.

Again, there is no several minute period where voltage stabilizes and
the drive takes longer to access.  This is a complete red herring.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUbMBPAAoJEI5FoCIzSKrwcV0H/20pv7O5+CDf2cRg5G5vt7PR
4J1NuVIBsboKwjwCj8qdxHQJHihvLYkTQKANqaqHv0+wx0u2DaQdPU/LRnqN71xA
jP7b9lx9X6rPnAnZUDBbxzAc8HLeutgQ8YD/WB0sE5IXlI1/XFGW4tXIZ4iYmtN9
GUdL+zcdtEiYE993xiGSMXF4UBrN8d/5buBRsUsPVivAZes6OHbf9bd72c1IXBuS
ADZ7cH7XGmLL3OXA+hm7d99429HFZYAgI7DjrLWp6Tb9ja5Gvhy+AVvrbU5ZWMwu
XUnNsLsBBhEGuZs5xpkotZgaQlmJpw4BFY4BKwC6PL+7ex7ud3hGCGeI6VDmI0U=
=DLHU
-----END PGP SIGNATURE-----
