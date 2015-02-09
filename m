Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36724 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759936AbbBIUsG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Feb 2015 15:48:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YKvFT-0008LK-Pv
	for linux-btrfs@vger.kernel.org; Mon, 09 Feb 2015 21:48:03 +0100
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Feb 2015 21:48:03 +0100
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Feb 2015 21:48:03 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Replacing a (or two?) failed drive(s) in RAID-1 btrfs filesystem
Date: Mon, 09 Feb 2015 21:30:09 +0100
Message-ID: <ivhnqb-40b.ln1@hurikhan77.spdns.de>
References: <CANcfdL0x_LTSnyL1FP8vVV4=MaFrewT4pd0MZgu3qzxOviXDgg@mail.gmail.com> <CAJCQCtT+8+02KkYOcRUOhscj3AP0av8PpNmsK526hvJY=3ucRw@mail.gmail.com> <CANcfdL0twe-pi4f1ZVNG=m82gQTKc5QL3pcodY6diJ6uLj2Q9A@mail.gmail.com> <CAJCQCtSJ+kgxKb-gGnuOCFEVBsr2UP0aUWg_M60Ts_OQaSL8oQ@mail.gmail.com> <CANcfdL2aSfE5uwgwt1KYGRsucF_wTGSyEVT=LfX+COd2gywJ+A@mail.gmail.com> <CANcfdL3qEG8HPDzRE8z8rEuuBpkcbMF4ZjV0oQrH9sZ8FSpxXg@mail.gmail.com> <CAJCQCtRy=Duyd9T5_rnPF06=a-fuqjhR=0yos0UtA1vm1r2v2A@mail.gmail.com> <CANcfdL1rT7BMM05cO7=Kd1JzKYSbUXXW+23YdzMc3+SYVra=TQ@mail.gmail.com> <54D85452.9070306@swiftspirit.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Brendan Hide <brendan@swiftspirit.co.za> schrieb:

> I have the following two lines in
> /etc/udev/rules.d/61-persistent-storage.rules for two old 250GB
> spindles. It sets the timeout to 120 seconds because these two disks
> don't support SCT ERC. This may very well apply without modification to
> other distros - but this is only tested in Arch:
> ACTION=="add", KERNEL=="sd*", SUBSYSTEM=="block",
> ENV{ID_SERIAL}="ST3250410AS_6RYF5NP7" RUN+="/bin/sh -c 'echo 120 >
> /sys$devpath/device/timeout'"
> ACTION=="add", KERNEL=="sd*", SUBSYSTEM=="block",
> ENV{ID_SERIAL}="ST3250820AS_9QE2CQWC" RUN+="/bin/sh -c 'echo 120 >
> /sys$devpath/device/timeout'"

Wouldn't it be easier and more efficient to use this:

ACTION=="add|change", KERNEL=="sd[a-z]", ENV{ID_SERIAL}=="...", 
ATTR{device/timeout}="120"

Otherwise you always spawn a shell and additional file descriptors, and you 
could spare a variable interpolation. Tho it probably depends on your udev 
version...

I'm using this and it works setting the attributes (set deadline on SSD):

ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", 
ATTR{queue/scheduler}="deadline"

And, I think you missed the double-equal "==" behind ENV{}... Right? 
Otherwise you just assign a value. Tho, you could probably match on 
ATTR{devices/model} instead to be more generic (the serial is probably too 
specific). You can get those from the /sys/block/sd* subtree.

-- 
Replies to list only preferred.

