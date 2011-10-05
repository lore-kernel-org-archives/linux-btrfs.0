From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Honest timeline for btrfsck
Date: Wed, 5 Oct 2011 10:58:43 -0400
Message-ID: <20111005145843.GA4770@shiny.elevennetworks.com>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com>
 <4E5FE9FC.9040705@cchtml.com>
 <20110901203442.GA17928@carfax.org.uk>
 <201109101209.40759.Martin@lichtvoll.de>
 <CA+JuuGrvCTP=o8umQHQV968tMSfJzxAFOfnGO2RKV3RU4_Vshw@mail.gmail.com>
 <20111005061628.GA3702@shiny.elevennetworks.com>
 <CA+JuuGoG1rhQ9S+vfa17BKdekp-A1UeNHqeYEwxfg=Co3Ts_pQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Jeff Putney <jeffrey.putney@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CA+JuuGoG1rhQ9S+vfa17BKdekp-A1UeNHqeYEwxfg=Co3Ts_pQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 05, 2011 at 08:59:47AM -0500, Jeff Putney wrote:
> Further adoption and more commitment from Oracle for production use is
> good news.  The fact that adoption is happening without a working fsck
> seems to indicate that folks have given up waiting for it.

No, in this case it means we're confident it will get rolled out.

> 
> Not hearing anything about getting the source into the repositories is
> terrible news by omission.  It seems like doubling down on maintaining
> a single point of failure.  Having a firm date of when the source
> repository will be released regardless of its condition, or
> functionality, would go a long way to appeasing the concerns within
> the user base.

I've given a number of hard dates recently and I'd prefer to show up
with the code instead.  I don't think it makes sense to put a partial
implementation out there, we'll just have a bunch of people reporting
problems that I know exist.

-chris
