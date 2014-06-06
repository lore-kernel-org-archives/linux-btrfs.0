Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52306 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaFFUFn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Jun 2014 16:05:43 -0400
Received: by mail-vc0-f174.google.com with SMTP id ik5so3690947vcb.19
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Jun 2014 13:05:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140607005317.077071e0@natsu>
References: <20140606204009.261e8ec3@natsu>
	<CAL3q7H7TD8FvFwVEx+A9ABEXhQW-C2yuNr6mga+XH9uMyMt+Qw@mail.gmail.com>
	<CALOYprW2R7iN0j=M6py0pbOkibbyob5L7KXHtmT92-32wVYMdw@mail.gmail.com>
	<20140607005317.077071e0@natsu>
Date: Fri, 6 Jun 2014 21:05:42 +0100
Message-ID: <CALOYprXzPMCGxmC5nwUiLAXSBXEBcPYwSkwKb_G2sNzapqvbxQ@mail.gmail.com>
Subject: Re: btrfs module dependencies broken in 3.14?
From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: Filipe Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6 June 2014 19:53, Roman Mamedov <rm@romanrm.net> wrote:
> On Fri, 6 Jun 2014 19:31:37 +0100
> WorMzy Tykashi <wormzy.tykashi@gmail.com> wrote:
>
>> My solution was to write a patch for mkinitcpio (Arch initrd creation
>> tool) [1] so that it explicitly adds the crc32c module to the initrd
>> if btrfs is needed. I imagine it wouldn't be difficult to add the same
>> logic to debian's initrd creation tool. IIRC it already does something
>> similar in other cases where there's an invisible dependency like
>> this.
>
> It was "visible" in 3.13, see the Debian bug link, there are modinfo of the

No, it wasn't -- libcrc32c is a different module. This confused me at
first too. :)

$ modinfo libcrc32c
filename:       /lib/modules/3.15.0-rc8-mainline/kernel/lib/libcrc32c.ko.gz
license:        GPL
description:    CRC32c (Castagnoli) calculations
author:         Clay Haapala <chaapala@cisco.com>
depends:
intree:         Y
vermagic:       3.15.0-rc8-mainline SMP preempt mod_unload modversions


$ modinfo crc32c
filename:
/lib/modules/3.15.0-rc8-mainline/kernel/arch/x86/crypto/crc32c-intel.ko.gz
alias:          crc32c-intel
alias:          crc32c
license:        GPL
description:    CRC32c (Castagnoli) optimization using Intel Hardware.
author:         Austin Zhang <austin.zhang@intel.com>, Kent Liu
<kent.liu@intel.com>
alias:          cpu:type:x86,ven*fam*mod*:feature:*0094*
depends:
intree:         Y
vermagic:       3.15.0-rc8-mainline SMP preempt mod_unload modversions
filename:
/lib/modules/3.15.0-rc8-mainline/kernel/crypto/crc32c_generic.ko.gz
softdep:        pre: crc32c
alias:          crc32c
license:        GPL
description:    CRC32c (Castagnoli) calculations wrapper for lib/crc32c
author:         Clay Haapala <chaapala@cisco.com>
depends:
intree:         Y
vermagic:       3.15.0-rc8-mainline SMP preempt mod_unload modversions

Unfortunately, as you can see, libcrc32c doesn't depend on crc32c
either, but this is covered up by initrd generating tools. See my
patch above to see that mkinitcpio already had logic for libcrc32c. My
post that Felipe linked to above has the code snippet that Debian's
initramfs-tools uses to handle this. So before, when btrfs depended on
libcrc32c, initrd creation tools automagically added crc32c as well.

> 3.13 and 3.14 modules compared side by side. I wonder is there really no way to
> make it show up in the actual module dependencies as before?
>
> To me patching initrd creation tools to special-case "if btrfs then add crc32"
> seems to be a really bizarre way of dealing with the issue.

I agree, it's a hacky workaround for a problem that shouldn't exist,
but the only other solution (that I can see) would be to get crc32c to
export a symbol that other modules can depend on. I don't know enough
about kernel modules to say whether this is a good idea or not though.

>
> --
> With respect,
> Roman

Cheers,


WorMzy
