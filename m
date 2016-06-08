Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35239 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422669AbcFHLAE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jun 2016 07:00:04 -0400
Received: by mail-pa0-f46.google.com with SMTP id hl6so1586557pac.2
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jun 2016 04:00:04 -0700 (PDT)
Date: Wed, 8 Jun 2016 11:01:23 +0000
From: cdlscpmv <cdlscpmv@gmail.com>
To: Noah Massey <noah.massey@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Can't remove read-only snapshot with immutable flag set
Message-ID: <20160608110123.GB24442@localhost>
References: <20160608083757.GA30823@localhost>
 <CADfjVrhi7X6dGdKrDYNL3sxy-kcbF0SkaNxAeyiJZhRVJYCcRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CADfjVrhi7X6dGdKrDYNL3sxy-kcbF0SkaNxAeyiJZhRVJYCcRQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/06/08 06:47:52 -0400, Noah Massey wrote:
> On Wednesday, June 8, 2016, cdlscpmv <cdlscpmv@gmail.com> wrote:
> >
> > Hi!
> >
> > It happened that I set the immutable flag (via `chattr +i`) on a subvolume.
> > Then I made a read-only snapshot of that subvolume. Now I can't remove
> > this snapshot.
> >
> >         #> btrfs subvolume delete my_snapshot
> >         Delete subvolume (no-commit): 'my_snapshot'
> >         ERROR: cannot delete 'my_snapshot': Operation not permitted
> >         #> chattr -i my_snapshot
> >         chattr: Read-only file system while setting flags on my_snapshot
> >         #> btrfs --version
> >         btrfs-progs v4.4.1
> >         #> uname -r
> >         4.5.2
> >
> > Is there any other way to do this? Or is it a bug?
> >
> Try
> #> btrfs property set my_snaphot ro false
> #> chattr -i my_snapshot
> #> btrfs sub del my_snapshot

I've already tried that. It worked. Nevertheless, thanks for the reply!

