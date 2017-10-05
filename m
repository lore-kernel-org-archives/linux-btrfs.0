Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45838 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751083AbdJEPPo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Oct 2017 11:15:44 -0400
Date: Thu, 5 Oct 2017 17:14:00 +0200
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: dsterba@suse.cz, Hugo Mills <hugo@carfax.org.uk>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs-progs: subvol: change subvol set-default to
 also accept subvol path
Message-ID: <20171005151400.GI3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5008967a-9da9-ad91-65e9-bcfbfb07feb0@jp.fujitsu.com>
 <CAA91j0WQ35e5KaZAEe_amwuDMazuAa6Mx1y3P18Y7EGvpxmAHQ@mail.gmail.com>
 <20171002090129.GB3293@carfax.org.uk>
 <45a84df9-fd06-ca72-3379-4594fceb4b5a@jp.fujitsu.com>
 <20171004180710.GF3521@twin.jikos.cz>
 <22943aba-b9c5-b16b-755f-d0c795280d51@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <22943aba-b9c5-b16b-755f-d0c795280d51@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 05, 2017 at 09:57:25AM +0900, Misono, Tomohiro wrote:
> > I agree with Andrei and Hugo. We need to check that the subvolume path
> > belongs to the filesystem anyway. I don't see that in the first version,
> > so please fix it.
> > 
> 
> I'm a bit confusing, but what is the meaning of "We need to check that the subvolume
> path belongs to the filesystem"? Do you mean we should check whether the fs of current
> directory and the fs of the subvolume specified are the same or not? However, current 
> "set-default <id> <path>" does not check the <path> belong the same fs or not either.
> Also, what if the subvolume is specified by absolute path?

Ah my bad, specifying by path is enough of course. So the expected use
is:

filesystem mounted under /mnt

$ cd /mnt
$ btrfs subvol set-default ./subvol1

or 

$ cd /
$ btrfs subvol set-default /mnt/subvol1
