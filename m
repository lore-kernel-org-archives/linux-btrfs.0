Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40434 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751047AbdJDSIz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Oct 2017 14:08:55 -0400
Date: Wed, 4 Oct 2017 20:07:10 +0200
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Andrei Borzenkov <arvidjaar@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs-progs: subvol: change subvol set-default to
 also accept subvol path
Message-ID: <20171004180710.GF3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5008967a-9da9-ad91-65e9-bcfbfb07feb0@jp.fujitsu.com>
 <CAA91j0WQ35e5KaZAEe_amwuDMazuAa6Mx1y3P18Y7EGvpxmAHQ@mail.gmail.com>
 <20171002090129.GB3293@carfax.org.uk>
 <45a84df9-fd06-ca72-3379-4594fceb4b5a@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <45a84df9-fd06-ca72-3379-4594fceb4b5a@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 03, 2017 at 08:57:52AM +0900, Misono, Tomohiro wrote:
> On 2017/10/02 18:01, Hugo Mills wrote:
> > On Mon, Oct 02, 2017 at 11:39:05AM +0300, Andrei Borzenkov wrote:
> >> On Mon, Oct 2, 2017 at 11:19 AM, Misono, Tomohiro
> >> <misono.tomohiro@jp.fujitsu.com> wrote:
> >>> This patch changes "subvol set-default" to also accept the subvolume path
> >>> for convenience.
> >>>
> >>> This is the one of the issue on github:
> >>> https://github.com/kdave/btrfs-progs/issues/35
> >>>
> >>> If there are two args, they are assumed as subvol id and path to the fs
> >>> (the same as current behavior), and if there is only one arg, it is assumed
> >>> as the path to the subvolume. Therefore there is no ambiguity between subvol
> >>> id and subvol name, which is mentioned in the above issue page.
> >>>
> >>> Only the absolute path to the subvolume is allowed, for the safety when
> >>> multiple filesystems are used.
> >>>
> >>> subvol id is resolved by get_subvol_info() which is used by "subvol show".
> >>>
> >>> change to v2:
> >>> restrict the path to only allow absolute path.
> >>
> >> This is absolutely arbitrary restriction. Why we can do "btrfs
> >> subvolume create ./relative/path" but cannot do "btrfs subvolume
> >> set-default ./relative/path"?
> > 
> >    Indeed. In fact, it's precisely the _opposite_ of the way that
> > every other command works -- you provide the path to the subvolume in
> > the *current namespace*.
> > 
> >    This approach would be just a major misfeature at this point.
> Ok, I understood the point and want to revert this.
> Please review the first version if possible:
> https://mail-archive.com/linux-btrfs@vger.kernel.org/msg68486.html

I agree with Andrei and Hugo. We need to check that the subvolume path
belongs to the filesystem anyway. I don't see that in the first version,
so please fix it.
