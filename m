Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:60868 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbbK2SGc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Nov 2015 13:06:32 -0500
Received: from mh by torres.zugschlus.de with local (Exim 4.80)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1a36Mn-00042S-K6
	for linux-btrfs@vger.kernel.org; Sun, 29 Nov 2015 19:06:29 +0100
Date: Sun, 29 Nov 2015 19:06:29 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: "disk full" on a 5 GB btrfs filesystem, FAQ outdated?
Message-ID: <20151129180629.GJ31524@torres.zugschlus.de>
References: <20151129130754.GI31524@torres.zugschlus.de>
 <20151129141806.GG24333@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20151129141806.GG24333@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Hugo,

On Sun, Nov 29, 2015 at 02:18:06PM +0000, Hugo Mills wrote:
> On Sun, Nov 29, 2015 at 02:07:54PM +0100, Marc Haber wrote:
> > However, the FAQ
> > https://btrfs.wiki.kernel.org/index.php/FAQ#Help.21_Btrfs_claims_I.27m_out_of_space.2C_but_it_looks_like_I_should_have_lots_left.21
> > suggests that for small filesystems (<16 GB), the best solution would
> > be to upgrade to at least 2.6.37 and recreate the filesystem. 2.6.37
> > is ancient, from 2011, so I am pretty sure that the filesystem _was_
> > created at least with a kernel more recent than that.
> 
>    You missed the most important thing from that paragraph: Use mixed
> block groups. That's "mkfs.btrfs --mixed ..." (which I realise is
> missing from the text, and I'll be adding it after I send this email).

Yes, that was the important bit of missing information. My filesystem
now reads:

[26/512]mh@fan:/mnt/tempdisk$ df -h .
Filesystem               Size  Used Avail Use% Mounted on
/dev/mapper/banana-root  6,0G  836M  5,2G  14% /mnt/tempdisk
[27/513]mh@fan:/mnt/tempdisk$ sudo btrfs fi show .
Label: none  uuid: b2906231-70a9-46d9-9830-38a13cb73171
        Total devices 1 FS bytes used 861.29MiB
        devid    1 size 6.00GiB used 6.00GiB path /dev/mapper/banana-root

btrfs-progs v4.3
[28/514]mh@fan:/mnt/tempdisk$ sudo btrfs fi df .
System, single: total=4.00MiB, used=4.00KiB
Data+Metadata, single: total=6.00GiB, used=861.29MiB
GlobalReserve, single: total=20.00MiB, used=0.00B
[29/515]mh@fan:/mnt/tempdisk$

Can I somehow get duplicate metadata back? Or is that unnecessary?

> > My normal way to recover from this situation is to btrfs add a new
> > device, btrfs balance, btrfs --convert=single --force balance, btfs
> > device remove, btr balance start -mconvert=dup --force and finally
> > balance start again.
> > 
> > Is there any solution to solve this more elegantly?
> 
>    Recreate the FS with --mixed, and that should deal with it.

Done. Thanks!

Greetings
Marc


-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
