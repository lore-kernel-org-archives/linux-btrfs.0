Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:35182 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbbEJWRd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 May 2015 18:17:33 -0400
Received: by pdbqd1 with SMTP id qd1so131005116pdb.2
        for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2015 15:17:32 -0700 (PDT)
Received: from android-a3079a374005daa4.lan (124-171-101-175.dyn.iinet.net.au. [124.171.101.175])
        by mx.google.com with ESMTPSA id oj10sm11064361pdb.38.2015.05.10.15.17.31
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 10 May 2015 15:17:32 -0700 (PDT)
Date: Mon, 11 May 2015 08:17:27 +1000
From: csirac2@gmail.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <6e30a94c-52bb-4ca1-bc5b-96b36c18c54d.maildroid@localhost>
Subject: Re: Are there plans for full btrfs filesystem backups?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Full-filesystem backups also beg the question of full-filesystem snapshots; this level of atomicity may be desirable for such a thing.

Perhaps this off topic (and I am sorry to bring it up again :D), but normal snazzer [1] usage operates on all subvolumes on all mounted btrfs filesystems, although I should revisit docker assumptions (I normally exclude them). snazzer-receive man page is at [2]. Still working on coping with manually mounted subvols [3].

[1] https://github.com/csirac2/snazzer
[2] https://github.com/csirac2/snazzer/blob/master/doc/snazzer-receive.md
[3] https://github.com/csirac2/snazzer/issues/2



Sent from my android device.

-----Original Message-----
From: Paul Harvey <csirac2@gmail.com>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Sent: Mon, 11 May 2015 8:13
Subject: Re: Are there plans for full btrfs filesystem backups?

Full-filesystem backups also beg the question of full-filesystem snapshots;
this level of atomicity may be desirable for such a thing.

Perhaps this off topic (and I am sorry to bring it up again :D), but normal
snazzer [1] usage operates on all subvolumes on all mounted btrfs
filesystems, although I should revisit docker assumptions (I normally
exclude them). snazzer-receive man page is at [2]. Still working on coping
with manually mounted subvols [3].

[1] https://github.com/csirac2/snazzer
[2] https://github.com/csirac2/snazzer/blob/master/doc/snazzer-receive.md
[3] https://github.com/csirac2/snazzer/issues/2
On 11 May 2015 02:56, "Marc MERLIN" <marc@merlins.org> wrote:

> I use send/receive to backup some subvolumes, but there is no good way
> to back up all of my subvolumes in one swoop.
> Backing up with tar/cp/rsync is of course no good since it loses all the
> btrfs attributes including COW deduped blocks.
>
> For one, my recent btrfs filesystem crash reminded me that docker
> creates a boatload of subvolumes which my backups didn't cacch, so now
> it's all gone.
>
> Are there any plans for a full filesystem send/receive, not just a
> subvolume send/receive?
>
> Note that this is the same problem when you are migtrating to new drives
> or bcache, and you can't play tricks with adding a virtual drive of 8TB
> just to mirror to it and remove the original mirror later.
>
> Thanks,
> Marc
> --
> "A mouse is a device used to point at the xterm you want to type in" -
> A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet
> cooking
> Home page: http://marc.merlins.org/                         | PGP
> 1024R/763BE901
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
