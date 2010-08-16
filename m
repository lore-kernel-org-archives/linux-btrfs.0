From: "Morten P.D. Stevens" <mstevens@imt-systems.com>
Subject: RE: 2.6.36-rc1 btrfs still unstable
Date: Mon, 16 Aug 2010 16:17:54 +0200
Message-ID: <7222A6B8ACA37D4AA1AC37810C43E8A80F5FC5BC@mail.corp.imt-systems.com>
References: <1281948382.1888.7.camel@chotu> <20100816121658.GT3315@think>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100816121658.GT3315@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 16, 2010 at 2:16 PM, Chris Mason <chris.mason@oracle.com> wrote:
>
> On Mon, Aug 16, 2010 at 11:46:22AM +0300, Ameya Palande wrote:
> > Hi Chris,
> >
> > Today I was checking the Kconfig option for btrfs and it still says,
> > "Btrfs filesystem (EXPERIMENTAL) Unstable disk format"
> >
> > I remember that some time back we had discussion about this on meego-dev
> > mailing list:
> > http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg04881.html
> >
> > In case if you have forgotten about this, then can we still change this
> > for 36-rc2?
>
> Yes, I'll go ahead and send this one in.
>
> I've spent a great deal of time trying to nail down the interaction
> between raid56 stripe size and adding/removing volumes from the FS
> (basically restriping the raid).
>
> The end result just isn't as user friendly as I wanted yet, but the raid
> code is holding up very well.
>
> -chris

Hi Chris,

the other big question is:

Is btrfs with 2.6.36 really rockstable and ready to use in productive environments?

Thanks

Morten
