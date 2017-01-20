Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:44573 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751409AbdATIF6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jan 2017 03:05:58 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cUUCd-0001Pz-D0
        for linux-btrfs@vger.kernel.org; Fri, 20 Jan 2017 09:05:43 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs recovery
Date: Fri, 20 Jan 2017 08:05:33 +0000 (UTC)
Message-ID: <pan$70181$45383b8f$72c6c22$19cae0fb@cox.net>
References: <7473ea27-9716-33fb-ecec-2ec52fac3820@dd-wrt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sebastian Gottschall posted on Thu, 19 Jan 2017 11:06:19 +0100 as
excerpted:

> I have a question. after a power outage my system was turning into a
> unrecoverable state using btrfs (kernel 4.9)
> since im running --init-extent-tree now for 3 days i'm asking how long
> this process normally takes

QW has the better direct answer for you, but...

This is just a note to remind you, in general questions like "how long" 
can be better answered if we know the size of your filesystem, the mode 
(how many devices and what duplication mode for data and metadata) and 
something about how you use it -- how many subvolumes and snapshots you 
have, whether you have quotas enabled, etc.

Normally output from commands like btrfs fi usage can answer most of the 
filesystem size and mode stuff, but of course that command requires a 
mount, and you're doing an unmounted check ATM.  However, btrfs fi show 
should still work and give us basic information like file size and number 
of devices, and you can fill in the blanks from there.

You did mention the kernel version (4.9) however, something that a lot of 
reports miss, and you're current, so kudos for that. =:^)

As to your question, assuming a terabyte scale filesystem, as QW 
suggested, a full extent tree rebuild is a big job and could indeed take 
awhile (days).

>From a practical perspective...

Given the state of btrfs as a still stabilizing and maturing filesystem, 
having backups for any data you value more than the time and hassle 
necessary to do the backup is even more a given than on a fully stable 
filesystem, which means, given the time for an extent tree rebuild on 
that size of a filesystem, unless you're doing the rebuild specifically 
to get the experience or test the code, as a practical matter it's 
probably simply easier to restore from that backup if you valued the data 
enough to have one, or simply scrap the filesystem and start over if you 
considered the data worth less than the time and hassle of a backup, and 
thus didn't have one.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

