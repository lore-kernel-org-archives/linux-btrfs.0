Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw4a-germaine.wadns.net ([196.220.39.45]:35132 "EHLO
	fw4a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759189AbbBIGb6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 01:31:58 -0500
Message-ID: <54D85452.9070306@swiftspirit.co.za>
Date: Mon, 09 Feb 2015 08:31:46 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: constantine <costas.magnuse@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Replacing a (or two?) failed drive(s) in RAID-1 btrfs filesystem
References: <CANcfdL0x_LTSnyL1FP8vVV4=MaFrewT4pd0MZgu3qzxOviXDgg@mail.gmail.com> <CAJCQCtT+8+02KkYOcRUOhscj3AP0av8PpNmsK526hvJY=3ucRw@mail.gmail.com> <CANcfdL0twe-pi4f1ZVNG=m82gQTKc5QL3pcodY6diJ6uLj2Q9A@mail.gmail.com> <CAJCQCtSJ+kgxKb-gGnuOCFEVBsr2UP0aUWg_M60Ts_OQaSL8oQ@mail.gmail.com> <CANcfdL2aSfE5uwgwt1KYGRsucF_wTGSyEVT=LfX+COd2gywJ+A@mail.gmail.com> <CANcfdL3qEG8HPDzRE8z8rEuuBpkcbMF4ZjV0oQrH9sZ8FSpxXg@mail.gmail.com> <CAJCQCtRy=Duyd9T5_rnPF06=a-fuqjhR=0yos0UtA1vm1r2v2A@mail.gmail.com> <CANcfdL1rT7BMM05cO7=Kd1JzKYSbUXXW+23YdzMc3+SYVra=TQ@mail.gmail.com>
In-Reply-To: <CANcfdL1rT7BMM05cO7=Kd1JzKYSbUXXW+23YdzMc3+SYVra=TQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015/02/09 01:58, constantine wrote:
>> Second, SMART is only saying its internal test is good. The errors are
>> related to data transfer, so that implicates the enclosure (bridge
>> chipset or electronics), the cable, or the controller interface.
>> Actually it could also be a flaky controller or RAM on the drive
>> itself too which I don't think get checked with SMART tests.
> Which test should I do from now on (on a weekly basis?) so as to
> prevent similar things from happening?
Chris has given some very good info so far. I've also had to learn some 
of this stuff the hard way (failed/unreliable drives, data 
unavailable/lost, etc). The info below will be of help to you in 
following some of the advice already given. Unfortunately, the best 
course of action I see so far is to follow Chris' advice and to purchase 
more disks so you can make a backup ASAP.

I have the following two lines in 
/etc/udev/rules.d/61-persistent-storage.rules for two old 250GB 
spindles. It sets the timeout to 120 seconds because these two disks 
don't support SCT ERC. This may very well apply without modification to 
other distros - but this is only tested in Arch:
ACTION=="add", KERNEL=="sd*", SUBSYSTEM=="block", 
ENV{ID_SERIAL}="ST3250410AS_6RYF5NP7" RUN+="/bin/sh -c 'echo 120 > 
/sys$devpath/device/timeout'"
ACTION=="add", KERNEL=="sd*", SUBSYSTEM=="block", 
ENV{ID_SERIAL}="ST3250820AS_9QE2CQWC" RUN+="/bin/sh -c 'echo 120 > 
/sys$devpath/device/timeout'"

I have a "smart_scan" script* that does a check of all disks using 
smartctl. The meat of the script is in main(). The rest of the script is 
from a template of mine. The script, with no parameters, will do a short 
and then a long test on all drives. It does not give any output - 
however if you have smartd running and configured appropriately, smartd 
will pick up on any issues found and send appropriate alerts 
(email/system log/etc).

It is configured in /etc/cron.d/smart. It runs a short test every 
morning and a long test every Saturday evening:
25    5    *    *    *    root    /usr/local/sbin/smart_scan short
25    18    *    *    6    root    /usr/local/sbin/smart_scan long

Then, scrubbing**:
This relatively simple script runs a scrub on all disks and prints the 
results *only* if there were errors.
I've scheduled this in a cron as well to execute *every* morning shortly 
after 2am. Cron is configured to send me an email if there is any output 
- so I only get an email if there's something to look into.

And finally, I have btsync configured to synchronise my Arch desktop's 
system journal to a couple of local and remote servers of mine. A much 
cleaner way to do this would be to use an external syslog server - I 
haven't yet looked into doing that properly, however.

http://swiftspirit.co.za/down/smart_scan
http://swiftspirit.co.za/down/btrfs-scrub-all

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

