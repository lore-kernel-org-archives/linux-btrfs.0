From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: How to see raid level?!
Date: Mon, 1 Nov 2010 13:14:08 +0100
Message-ID: <20101101121408.GA2837@scooter>
References: <20101101101755.GA2814@scooter>
 <AANLkTinc0zL1hmLOD0YpHShu5Jg8eiZwZtJdcVZaG5QO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinc0zL1hmLOD0YpHShu5Jg8eiZwZtJdcVZaG5QO@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Ah, the magic one :)

Is that a patch for the kernel or the btrfs progs?


If you know where to get that patch it would be nice. It isn't an important issue but it
would be nice to see if my home really uses raid1 for data :)


Regards,
FElix


On 01. November 2010 - 04:33, cwillu wrote:
> Date: Mon, 1 Nov 2010 04:33:30 -0600
> From: cwillu <cwillu@cwillu.com>
> To: Felix Blanke <felixblanke@gmail.com>
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: How to see raid level?!
> 
> On Mon, Nov 1, 2010 at 4:17 AM, Felix Blanke <felixblanke@gmail.com> wrote:
> > Hi,
> >
> > I saw some reports of ppl in this list who did a "btrfs fi df /path" and saw the
> > raidlevel of the data, metadata etc.
> >
> > How? :)
> >
> > I'm using the git version of the btrfs progs and 2.6.36, but I don't see those
> > informations.
> >
> > Btrfs v0.19-35-g1b444cd-dirty
> >
> >
> > What am I doing wrong? :(
> 
> You didn't include the magic patch.  :p
> 
> Raid level reporting was broken for a while, josef sent some patches
> recently that fixed it, which I saw in cmason's pull request for
> 2.6.37.
---end quoted text---
