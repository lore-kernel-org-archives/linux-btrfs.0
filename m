From: Stephan von Krawczynski <skraw@ithnet.com>
Subject: Re: SSD Optimizations
Date: Sat, 13 Mar 2010 18:02:10 +0100
Message-ID: <20100313180210.4eb1b705.skraw@ithnet.com>
References: <4B97F7CE.4030405@bobich.net>
	<201003120207.40740.hka@qbs.com.pl>
	<20100312101528.8e87810f.skraw@ithnet.com>
	<201003121700.09553.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Chris Mason <chris.mason@oracle.com>,
	Gordan Bobic <gordan@bobich.net>, linux-btrfs@vger.kernel.org
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201003121700.09553.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 12 Mar 2010 17:00:08 +0100
Hubert Kario <hka@qbs.com.pl> wrote:
> > Even on true
> > spinning disks your assumption is wrong for relocated sectors.
> 
> Which we don't have to worry about because if the drive has less than 5 of 
> 'em, the impact of hitting them is marginal and if there are more, the user 
> has much more pressing problem than the performance of the drive or FS.

Are you really sure that a drive firmware tells you about the true number of
relocated sectors? I mean if it makes the product look better in comparison to
another product, are you really sure that the firmware will not tell you what
you expect to see only to make you content and happy with your drive?

> > Which
> > basically means that every disk controller firmware fiddles around with
> > the physical layout since decades. Please accept that you cannot do a
> > disks' job in FS. The more advanced technology gets the more disks become
> > black boxes with a defined software interface. Use this interface and drop
> > the idea of having inside knowledge of such a device. That's other
> > peoples' work. If you want to design smart SSD controllers hire at a
> > company that builds those.
> 
> And I don't think that doing disks' job in the FS is good idea, but I think 
> that we should be able to minimise the impact of the translation layer.
> 
> The way to do this, is to threat the device as a block device with sectors the 
> size of erase-blocks. That's nothing too fancy, don't you think?

I don't believe anyone is able to tell the size of erase-blocks of some device
- current and future - for sure. I do believe that making this guess only
reduces the future design options for new devices - if its creators care at
all about your guess.
Why not let the fs designer take his creative options in fs layer and let the
device designer use his brain on the device level and all meet at the
predefined software interface in between - and nowhere _else_.


> -- 
> Hubert Kario

-- 
Regards,
Stephan
