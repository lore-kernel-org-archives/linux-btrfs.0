Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:34382 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751619AbdAWWFP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jan 2017 17:05:15 -0500
Received: by mail-pg0-f43.google.com with SMTP id 14so48233734pgg.1
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jan 2017 14:05:15 -0800 (PST)
Date: Mon, 23 Jan 2017 14:04:48 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, agruenba@redhat.com
Subject: Re: read-only fs, kernel 4.9.0, fs/btrfs/delayed-inode.c:1170
 __btrfs_run_delayed_items,
Message-ID: <20170123220448.GB11778@vader.DHCP.thefacebook.com>
References: <CAJCQCtRhgxqtrpnsibOPqkMA75Cf=ryRAeTb0Gf-ygy=gjD_Yg@mail.gmail.com>
 <CAJCQCtT73Zh2F13tg3v4UZC3+rdTMhgC==Ag3LZQ-RZMTpisOg@mail.gmail.com>
 <CAJCQCtSZyfHdmsaVdEM7iQiKfK-s4Qqs4ORZrE1MCpWCgeCWbw@mail.gmail.com>
 <CAJCQCtQz5fhYymEgFuxuiactZpWeUSEeCCXFCAEmLTTA6AOZLQ@mail.gmail.com>
 <20170123213109.GA11778@vader.DHCP.thefacebook.com>
 <CAJCQCtSVXRXvGmnmfFt5yn_L33a8eCCuuFANxTOyWLrJeqrK9g@mail.gmail.com>
 <CAJCQCtRip_D7BPhCJDVP53LRoQoEcVrvCf7eyGK9sa8qv23BNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtRip_D7BPhCJDVP53LRoQoEcVrvCf7eyGK9sa8qv23BNQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 23, 2017 at 02:55:21PM -0700, Chris Murphy wrote:
> On Mon, Jan 23, 2017 at 2:50 PM, Chris Murphy
> > I haven't found the commit for that patch, so maybe it's something
> > with the combination of that patch and the previous commit.
> 
> I think that's provably not the case based on the bisect log, because
> I hit the problem with kernel that has only the commit, as well as the
> commit plus the updated patch. So the patch neither causes nor fixes
> the problem I'm experiencing.
> 
> If it's useful the btrfs-image is here; mentioned in a previous
> thread, this image mounts find, btrfs check --mode=original has no
> complaints, but btrfs check --mode=lowmem has complaints. There's no
> problem using the parent subvolume as rootfs. Only snapshots of that
> subvolume result in the problem.
> https://drive.google.com/open?id=0B_2Asp8DGjJ9ZmNxdEw1RDBPcTA

What I meant to ask was if there were false positives/false negatives in
booting from the subvolume that would lead you to doubt the results of
the git bisect, but it sounds like it's 100% reproducible for you?

I'll take a look at the image. In the meantime, could you try booting
with https://gist.github.com/osandov/9f223bda27f3e1cd1ab9c1bd634c51a4
applied on top of 4.9 so we can hopefully narrow it down? It'd also be
great to know if it always fails the same way or if it varies.
