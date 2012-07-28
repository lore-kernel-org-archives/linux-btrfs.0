Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41678 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab2G1Qau (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jul 2012 12:30:50 -0400
Received: by eeil10 with SMTP id l10so928955eei.19
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Jul 2012 09:30:49 -0700 (PDT)
Message-ID: <501413AC.1070900@gmail.com>
Date: Sat, 28 Jul 2012 18:30:36 +0200
From: Andreas Philipp <philipp.andreas@gmail.com>
MIME-Version: 1.0
To: Florian Albrechtskirchinger <falbrechtskirchinger@gmail.com>
CC: btrfs <linux-btrfs@vger.kernel.org>,
        Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: No SysRq remount because sb->s_bdev is NULL
References: <1389197.DvrDHJORPI@nezir> <5013ED4A.3070609@gmail.com> <2108513.KBpvBiH5fV@nezir>
In-Reply-To: <2108513.KBpvBiH5fV@nezir>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 

On 28.07.2012 16:50, Florian Albrechtskirchinger wrote:
> On Saturday, July 28, 2012 15:46:50 Andreas Philipp wrote:
>> On 28.07.2012 15:41, Florian Albrechtskirchinger wrote:
>>> During a SysRq emergency remount Btrfs mounts are not remounted. I
tracked
>>> the issue down to this line in do_emergency_remount() in fs/super.c:
>>> if (sb->s_root && sb->s_bdev && (sb->s_flags & MS_BORN) &&
>>> !(sb->s_flags & MS_RDONLY))
>>> s_bdev is NULL for Btrfs super blocks and subsequently
do_remount_sb() is
>>> never called. I couldn't think of a solution, besides resorting to
an ugly
>>> strcmp(sb->s_type->name, "btrfs"), without adding a field to struct
>>> super_block or similar changes.
>>> Thoughts?
>>
>> Just a first thought. Is there a possibility to write a dummy value into
>> sb->s_bdev for btrfs super blocks. Thus it will not be NULL and
>> everything in do_emergency_remount() in fs/super.c will work as wanted.
>
> Then other code paths testing sb->s_bdev for NULL and assuming a
non-NULL sb-
>> s_bdev is a valid block device would fail.
Sorry, I thought that there are separate checks whether the value of
sb->s_bdev is a valid block device.
Thanks,
Andreas
>>
>
> Flo

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQEcBAEBAgAGBQJQFBOrAAoJEIW3W1BiBxU7xCsH/RzDyJR7MneXLtDBQIQC43XS
+jdaMrUIjEjBhs390iJJWebg5H6690XEO/wSM36ZMkHi0fSeJ7dC4WKjTtLyTkAB
ok2+1Qix2LcqWxGSr9TC5OAjli3A8bl2Iy+P3bObfVOYnaTS781+ALl2PopiyZva
ineLrXzGiUQoT059BK456ckceNkQ31YTbuwAEVP85ZdC4Bk8UviUYdoVtsFBb2aH
4UnHgnGdrPhz6BqIbxhrfTLNsNbnGskQ8MrxogRChv+P1SRKHslBKTLCvXugH5t4
iwrXtm1gtpFDWkmiMfYN6HpV/vGIrqstUns7zj/kYVbC2c0u4QGBSZLhy9S7UF4=
=1I+D
-----END PGP SIGNATURE-----

