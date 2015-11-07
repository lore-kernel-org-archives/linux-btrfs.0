Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:34111 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbbKGP26 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Nov 2015 10:28:58 -0500
Received: by lbbwb3 with SMTP id wb3so75137344lbb.1
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Nov 2015 07:28:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1446908706.7774.3.camel@scientia.net>
References: <1446908706.7774.3.camel@scientia.net>
Date: Sat, 7 Nov 2015 16:28:55 +0100
Message-ID: <CAJCQCtR6zBdct2bouiau_bT6z122663Ax6yU-Avym0NWnqh-WA@mail.gmail.com>
Subject: Re: mkfs.btrfs doesn't detect SSD
From: Chris Murphy <lists@colorremedies.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 7, 2015 at 4:05 PM, Christoph Anton Mitterer
<calestyo@scientia.net> wrote:
> Hey.
>
> I'm creating a filesystem on Samsung Evo 850 Pro on top of a dm-
> crypt/LUKS container (with TRIM not being passed on, for the usual
> security reasons):
> # mkfs.btrfs --label system /dev/mapper/system
> btrfs-progs v4.2.2
> See http://btrfs.wiki.kernel.org for more information.
>
> Label:              system
> UUID:               65531196-2e43-4c49-b495-ac9abc57d7d8
> Node size:          16384
> Sector size:        4096
> Filesystem size:    937.00GiB
> Block group profiles:
>   Data:             single            8.00MiB
>   Metadata:         DUP               1.01GiB
>   System:           DUP              12.00MiB
> SSD detected:       no
> Incompat features:  extref, skinny-metadata
> Number of devices:  1
> Devices:
>    ID        SIZE  PATH
>     1   937.00GiB  /dev/mapper/system
>
>
> As you can see it doesn't detect the SSD.
> Isn't that kinda problematic cause btrfs does more when it detects and
> SSD than just using TRIM (e.g. not DUPing meta-data)?
>
> Can I somehow override this to get the SSD "detected"?
> Or what is the general suggestion here? Having it handled as SSD or as
> non-SSD, as said, when dm-crypt is used below and TRIM is not intended
> to be used.

There are three separate SSD related optimizations:

Allocation optimization is the mount time -o ssd and ssd_spread
options; which on dmcrypt devices you'll need to manually add because
the fact this is an SSD isn't passed through the device mapper
apparently.

Using single instead of duplicate metadata is a mkfs time option,
probably uses the same detection method as mount time allocation
optimization, and why you get DUP instead of single. So you have to
mkfs manually or use 'btrfs balance -mconvert=single -f' to force
changing it, forcing is required since a reduction in redunancy will
happen.

Trim, isn't used automatically, it's a mount time option, -o discard.



-- 
Chris Murphy
