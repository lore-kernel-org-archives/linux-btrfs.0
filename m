Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37904 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127AbaLDNPC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Dec 2014 08:15:02 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XwWFI-0006hd-9E
	for linux-btrfs@vger.kernel.org; Thu, 04 Dec 2014 14:15:00 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Dec 2014 14:15:00 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Dec 2014 14:15:00 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their
 snapshots
Date: Thu, 4 Dec 2014 13:14:48 +0000 (UTC)
Message-ID: <pan$9ccf9$a87459dd$86742743$307606ba@cox.net>
References: <CAE8gLhm8Oma6kWdeJtdc1-U2e4+TJDzhmw2Vfr=CYwvJ78GRJQ@mail.gmail.com>
	<547CA4E7.8060209@pobox.com>
	<CAE8gLhmbws6E7YQVBLHfaUXF6Jz1qob9iOFiAEW7pRTq65YCyw@mail.gmail.com>
	<547CF8B1.4000303@pobox.com>
	<CAE8gLhkxgi8nTab0rzmLNzhsek_v2zs6RxPDL9GU_EAen9+kvA@mail.gmail.com>
	<547D6F42.9000009@inwind.it>
	<CAE8gLhmVqPTArDKxBenbRasUwifGOEoy+askejqneEA9WH-iOQ@mail.gmail.com>
	<547D9F18.3030400@inwind.it> <547DA86C.4050100@oracle.com>
	<547DAF2A.7020902@gmail.com> <547E0EE5.2040504@ubuntu.com>
	<547EC8B5.1060002@inwind.it> <547FD069.5050407@ubuntu.com>
	<pan$98ead$1818dba6$1ce717a3$590ca971@cox.net>
	<CAE8gLhkb4SP0MJzWtfZwohnfNaM+efPb9EXWS2jq1VxFwnN50w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

MegaBrutal posted on Thu, 04 Dec 2014 09:20:12 +0100 as excerpted:

> Are you sure it isn't fixed? At least, it parses "rootflags=subvol=@"
> well, which also has multiple = signs. And last time I've tried this,
> and didn't cause any problems:
> "rootflags=device=/dev/mapper/vg-rootlv,subvol=@". Though "device="
> shouldn't have an effect in this case anyway, but I didn't get any
> complaints against it. Though I use an initrd.

AFAIK lvm requires userspace anyway, thus an initr*, and once you have 
that initr* handling the lvm, it's almost certainly the initr* parsing 
the rootflags= from the kernel commandline as well.  So in that case the 
kernel doesn't /need/ to be able to parse rootflag=, as all it does is 
pass the kernel commandline straight thru to the initr*, which would 
seem, in your case at least, to parse it correctly.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

