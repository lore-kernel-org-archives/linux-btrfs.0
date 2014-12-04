Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f181.google.com ([209.85.220.181]:50480 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaLDIUO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 03:20:14 -0500
Received: by mail-vc0-f181.google.com with SMTP id le20so7726300vcb.12
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Dec 2014 00:20:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$98ead$1818dba6$1ce717a3$590ca971@cox.net>
References: <CAE8gLhm8Oma6kWdeJtdc1-U2e4+TJDzhmw2Vfr=CYwvJ78GRJQ@mail.gmail.com>
	<547CA4E7.8060209@pobox.com>
	<CAE8gLhmbws6E7YQVBLHfaUXF6Jz1qob9iOFiAEW7pRTq65YCyw@mail.gmail.com>
	<547CF8B1.4000303@pobox.com>
	<CAE8gLhkxgi8nTab0rzmLNzhsek_v2zs6RxPDL9GU_EAen9+kvA@mail.gmail.com>
	<547D6F42.9000009@inwind.it>
	<CAE8gLhmVqPTArDKxBenbRasUwifGOEoy+askejqneEA9WH-iOQ@mail.gmail.com>
	<547D9F18.3030400@inwind.it>
	<547DA86C.4050100@oracle.com>
	<547DAF2A.7020902@gmail.com>
	<547E0EE5.2040504@ubuntu.com>
	<547EC8B5.1060002@inwind.it>
	<547FD069.5050407@ubuntu.com>
	<pan$98ead$1818dba6$1ce717a3$590ca971@cox.net>
Date: Thu, 4 Dec 2014 09:20:12 +0100
Message-ID: <CAE8gLhkb4SP0MJzWtfZwohnfNaM+efPb9EXWS2jq1VxFwnN50w@mail.gmail.com>
Subject: Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their snapshots
From: MegaBrutal <megabrutal@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-12-04 6:15 GMT+01:00 Duncan <1i5t5.duncan@cox.net>:
>
> Which is why I'm running an initramfs for the first time since I've
> switched to btrfs raid1 mode root, as I quit with initrds back before
> initramfs was an option.  An initramfs appended to the kernel image beats
> a separate initrd, but I'd still love to see the kernel commandline
> parsing fixed so it broke at the correct = in rootflags=device= (which
> seemed to be the problem, the kernel then didn't seem to recognize
> rootflags at all, as it was apparently seeing it as a parameter called
> rootflags=device, instead of rootflags), so I could be rid of the
> initramfs again.
>

Are you sure it isn't fixed? At least, it parses "rootflags=subvol=@"
well, which also has multiple = signs. And last time I've tried this,
and didn't cause any problems:
"rootflags=device=/dev/mapper/vg-rootlv,subvol=@". Though "device="
shouldn't have an effect in this case anyway, but I didn't get any
complaints against it. Though I use an initrd.
