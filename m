Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:48939 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1756187AbcH2B2l (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 21:28:41 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1beBNN-0001Gy-8K
        for linux-btrfs@vger.kernel.org; Mon, 29 Aug 2016 03:28:37 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs and systemd
Date: Mon, 29 Aug 2016 01:28:30 +0000 (UTC)
Message-ID: <pan$887ef$35b40aeb$b83a6f75$374bc3a8@cox.net>
References: <47ee55de-a77b-185a-1a01-b8b39899b188@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stefan Priebe - Profihost AG posted on Sun, 28 Aug 2016 22:15:21 +0200 as
excerpted:

> Hi,
> 
> i'm trying to get my 60TB btrfs volume to mount with systemd at boot.
> But this always fails with: "mounting timed out. Stopping." after 90s.
> 
> I can't find any fstab setting for systemd to higher this timeout.
> There's just  the x-systemd.device-timeout but this controls how long to
> wait for the device and not for the mount command.
> 
> Is there any solution for big btrfs volumes and systemd?

Yes.

The key here is to realize that systemd creates mount units dynamically 
based on the fstab file, placing them in /run/systemd/generator/ (take a 
look =:^), and then uses them to process mounts.  So the normal method 
for reconfiguring/overriding systemd units applies.  See the systemd.unit 
manpage, example section, example 2 (as of systemd 230), for override 
details, but in general you choose whether you want to override the 
entire default unit (probably not, as you'd replace the generated file 
and override the fstab options) or just specific options (likely what you 
want), and place your override file in the appropriate subdir of 
/etc/systemd/ accordingly.


Now that you know where to put the file with the override, take a look at 
the systemd.mount manpage, options section.  Based on that (IOW, I've not 
actually tried this), the setting you need to change is TimeoutSec.


You can also consider changing the global timeout setting by setting 
DefaultTimeoutStart in /etc/systemd/system.conf, tho that's going to 
affect other units as well.  But it may be easier, if your other units 
start up fine without getting anywhere close to the timeout, and thus 
never need to use the timeout setting.  Of course if they break, you'll 
then be dealing with the longer timeouts, but you may find it easier to 
simply set that default and deal with the long timeouts on anything else 
when and if some other unit does actually break and start following the 
longer default timeouts.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

