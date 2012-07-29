Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42550 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363Ab2G2T5U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Jul 2012 15:57:20 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1SvZc7-0007AX-Kz
	for linux-btrfs@vger.kernel.org; Sun, 29 Jul 2012 21:57:19 +0200
Received: from 176.50.240-63.xdsl.ab.ru ([176.50.240-63.xdsl.ab.ru])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Jul 2012 21:57:19 +0200
Received: from ksee.zelgadis by 176.50.240-63.xdsl.ab.ru with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Jul 2012 21:57:19 +0200
To: linux-btrfs@vger.kernel.org
From: Konstantin Dmitriev <ksee.zelgadis@gmail.com>
Subject: Re: severe hardlink bug
Date: Sun, 29 Jul 2012 19:57:07 +0000 (UTC)
Message-ID: <loom.20120729T215053-500@post.gmane.org>
References: <20100124015138.092c4959@simplux> <201001240909.44753.kreijack@libero.it> <20100124140837.5efcd526@simplux> <201001241415.47519.kreijack@inwind.it> <20100124142711.4afe8a81@simplux> <loom.20120729T205902-38@post.gmane.org> <CAGAVQTFADbS95X9NbtOBx7m=R3tXB1exauQtSpPfBc2m72tNqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

C Anthony Risinger <anthony <at> xtfx.me> writes:

> btrfs only fails when you have hundreds of hardlinks to the same file
> in the *same* directory ... certainly not a standard use case.
> 
> use snapshots to your advantage:
>  - snap source
>  - rsync --inplace source to target (with some other opts that have
> been discussed on list)
>  - snap target
>  - {rinse-and-repeat-in-24-hrs}

I understand that the case is only for *same* directory.
You can claim that it's not a standard use case, but first Michael hit that,
now me. There's at least one more case  -
https://lists.samba.org/archive/rsync/2011-December/027117.html
The count of such cases will be increasing and the sooner it will be fixed - 
the less pain it will bring to the users. I know fixing that is a big 
structural change, but it will become worse with time.
If it's not going to be fixed - I don't care. Right now I'm forced 
to migrate to old mdadm raid-1 or ZFS. The sad thing is that 
I really LOVED btrfs. Only that. ^__^

K.

