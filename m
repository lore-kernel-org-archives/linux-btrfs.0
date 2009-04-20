From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Unstable tree updated to 2.6.29-rc2
Date: Mon, 20 Apr 2009 17:06:46 -0400
Message-ID: <1240261606.7114.4.camel@think.oraclecorp.com>
References: <1240259539.7114.3.camel@think.oraclecorp.com>
	 <89ed0c690904201348t617a4dcck3ce13aaff2a41f12@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: "Mitch Harder (aka DontPanic)" <mmharder@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <89ed0c690904201348t617a4dcck3ce13aaff2a41f12@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-04-20 at 15:48 -0500, Mitch Harder (aka DontPanic) wrote:
> I believe you mean 2.6.30-rc2
> 

Sorry, updated to 2.6.30-rc2

thanks
Chris

> On Mon, Apr 20, 2009 at 3:32 PM, Chris Mason <chris.mason@oracle.com> wrote:
> > Hello everyone,
> >
> > I've updated the unstable tree to 2.6.29-rc2 and pushed out some of the
> > pending fixes.  This has my current fixes for fsync latency, which make
> > btrfs behave much better when mixing synchronous and async writes.
> >
> > -chris
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

