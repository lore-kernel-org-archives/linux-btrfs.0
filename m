From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] don't OOPs when we are not raid56
Date: Tue, 8 Sep 2009 09:48:29 -0400
Message-ID: <20090908134829.GA32545@think>
References: <1249553833.568.23.camel@macbook.infradead.org>
 <774E55AE-1639-4537-B001-E8F96311F4CD@karlsbakk.net>
 <1249658554.568.214.camel@macbook.infradead.org>
 <4A9E9E00.5080608@hp.com>
 <1252401329.4483.579.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jim owens <jowens@hp.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1252401329.4483.579.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 08, 2009 at 10:15:29AM +0100, David Woodhouse wrote:
> On Wed, 2009-09-02 at 12:32 -0400, jim owens wrote:
> > @@ -2895,7 +2895,7 @@ again:
> >                 multi->num_stripes = num_stripes;
> >                 multi->max_errors = max_errors;
> >         }
> > -       if (raid_map_ret) {
> > +       if (raid_map) {
> >                 sort_parity_stripes(multi, raid_map);
> >                 *raid_map_ret = raid_map;
> >         }
> 
> Applied (manually, because I think your mail was whitespace-damaged).
> Thanks.
> 
> Chris, where do we stand with getting this merged? You were going to
> sort out the upper layers to handle the minimum write size, weren't you?

Yes, I'm working on sorting that out.  Jens distracted me with some
depressing benchmarks, but now that those are fixed I can move on ;)

> 
> I'm also going to do RAID50/60 support, and with hpa's help I'll extend
> it to do RAID7/70 too -- but you're not waiting for that, are you?

Great news, no I'm not waiting for that.

-chris

