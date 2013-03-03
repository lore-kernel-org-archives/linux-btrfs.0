Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:35127 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab3CCXm2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Mar 2013 18:42:28 -0500
Received: by mail-wi0-f182.google.com with SMTP id hi18so1307088wib.9
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Mar 2013 15:42:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOcd+r1C_tHGzZ3WQejkW3xycFhNLisOpk7BtUv70pog5Og6xQ@mail.gmail.com>
References: <CAEx9m45BO=McK-NrL3fX7QiJMtf-T+bKoc1D1G=6vHxYT8b36g@mail.gmail.com>
	<20130220175410.GB2062@localhost.localdomain>
	<CAEx9m46b9rW4xDiQi8QiTmyC5Wa9hNcasL_nXF4Y2qdyPE+D6g@mail.gmail.com>
	<CAEzrpqcGeiq=tHEvcH9625vZpCZaD94PrpjYO1_r4nS2GP9ByA@mail.gmail.com>
	<CAEx9m45V6aUkNQe0PTf+qJjpkJLHyMc4UBfSex9mxGOy-X7GrQ@mail.gmail.com>
	<20130225172719.GA2434@localhost.localdomain>
	<CAEx9m44BBv-rZqF_tv5PgKkHjfzBYo9p-4h3WeGLdykA+s+71A@mail.gmail.com>
	<CAOcd+r1C_tHGzZ3WQejkW3xycFhNLisOpk7BtUv70pog5Og6xQ@mail.gmail.com>
Date: Sun, 3 Mar 2013 18:42:26 -0500
Message-ID: <CAEzrpqcWbw16oWg3BfjdxgYsapnVpFzZLXERdVMHm12Dj+-KCA@mail.gmail.com>
Subject: Re: basic questions regarding COW in Btrfs
From: Josef Bacik <josef@toxicpanda.com>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
Cc: Josef Bacik <jbacik@fusionio.com>, Aastha Mehta <aasthakm@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 2, 2013 at 4:07 PM, Alex Lyakas
<alex.btrfs@zadarastorage.com> wrote:
> Hi Josef,
> I hope it's ok to piggy back on this thread for the following question:
>
> I see that in btrfs_cross_ref_exist()=>check_committed_ref() path,
> there is the following check:
>
> if (btrfs_extent_generation(leaf, ei) <=
>     btrfs_root_last_snapshot(&root->root_item))
>         goto out;
>
> So this basically means that after we have taken a snap of a subvol,
> then all subvol's extents must be COW'ed, even if we delete the snap a
> minute later.
> I wonder, why is that so?
> Is this because file extents can be shared indirectly, like when we
> create a snap, we only COW the root and only mark all root's
> *immediate* children shared in the extent tree?

Yes that's exactly it.  We have no way of knowing that there are no
snapshots left for this particular root so if there ever was a
snapshot we have to err on the side of caution.

> Can the new backref walking code be used here to check more
> accurately, if the extent is shared by anybody else?
>

Probably, if we could figure out if there is a way for more than one
root to point to this extent then yes this would be ideal so we don't
have to force COW in cases we would rather not.  Thanks,

Josef
