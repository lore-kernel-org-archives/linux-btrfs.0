Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f50.google.com ([209.85.216.50]:39348 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab2FTSH0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 14:07:26 -0400
Received: by qafl39 with SMTP id l39so683267qaf.2
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2012 11:07:25 -0700 (PDT)
Message-ID: <1340215644.6961.12.camel@cwalton-XPS-8300>
Subject: Re: [PATCH] Allow cross subvolume reflinks (2nd attempt)
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Alexander Block <ablock84@googlemail.com>
Cc: kreijack@inwind.it, linux-btrfs@vger.kernel.org, dave@jikos.cz,
        hch@infradead.org, linux-fsdevel@vger.kernel.org,
        chris.mason@fusionio.com, linux-kernel@vger.kernel.org
Date: Wed, 20 Jun 2012 14:07:24 -0400
In-Reply-To: <CAB9VWqB8z_faPNRJo8+9JWsQFDe507iTxwQK4sctUYGF9zCL4Q@mail.gmail.com>
References: <1340188512-5761-1-git-send-email-ablock84@googlemail.com>
	 <4FE205CF.9020509@libero.it>
	 <CAB9VWqB8z_faPNRJo8+9JWsQFDe507iTxwQK4sctUYGF9zCL4Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2012-06-20 at 19:27 +0200, Alexander Block wrote:
> On Wed, Jun 20, 2012 at 7:18 PM, Goffredo Baroncelli <kreijack@libero.it> wrote:
> > Hi Alexander,
> >
> > On 06/20/2012 12:35 PM, Alexander Block wrote:
> >> The patch also does proper vfs mount checks, so cross mount
> >> point reflinks are not possible with this patch. It only allows cross
> >> reflinks between two subvolumes which are in the same mount point.
> >
> > Thanks for working on that. What happens if two subvolumes of the same
> > filesystem are mounted on two different places ?
> >
> > I usually do:
> >  mount -o subvol=__active /dev/sdX /
> >  mount -o subvol=.        /dev/sdX /var/btrfs
> >
> > So two different subvolumes of the same filesystem (the one on /dev/sdX)
> > are mounted on two different places.
> >
> > Is it possible to do
> >  cp --reflink /tmp/foo /var/btrfs/tmp/foo2
> This will fail with -EXDEV. The patch explicitly forbids reflinks crossing vfs
> mount boundaries.

Which means that if I want to do a reflink copy between two separately
mounted subvolumes, I will have to go and do a third mount with a common
subvolume above those two, then do the reflink operation within this
extra mount? This seems slightly impractical.

Is it any extra code to enable doing cross-mount reflinks? Why was the
decision made not to allow them?

Is there some particular opposition to supporting cross-mount operations
on multiple mounts of the same filesystem in general? (I'd love to have
rename() work across bind mounts, for example...)

-- 
Calvin Walton <calvin.walton@kepstin.ca>

