From: Stephan von Krawczynski <skraw@ithnet.com>
Subject: Re: SSD Optimizations
Date: Thu, 11 Mar 2010 18:35:06 +0100
Message-ID: <20100311183506.adce61ee.skraw@ithnet.com>
References: <4B97F7CE.4030405@bobich.net>
	<4B9829B1.1020706@bobich.net>
	<20100311073853.GA26129@attic.humilis.net>
	<201003111159.58081.hka@qbs.com.pl>
	<20100311123103.34246e95.skraw@ithnet.com>
	<20100311143905.GA20569@attic.humilis.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Hubert Kario <hka@qbs.com.pl>, linux-btrfs@vger.kernel.org,
	Gordan Bobic <gordan@bobich.net>
To: sander@humilis.net
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100311143905.GA20569@attic.humilis.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 11 Mar 2010 15:39:05 +0100
Sander <sander@humilis.net> wrote:

> Stephan von Krawczynski wrote (ao):
> > Honestly I would just drop the idea of an SSD option simply because the
> > vendors implement all kinds of neat strategies in their devices. So in the end
> > you cannot really tell if the option does something constructive and not
> > destructive in combination with a SSD controller.
> 
> My understanding of the ssd mount option is also that the fs doens't try
> to do all kinds of smart (and potential expensive) things which make
> sense for rotating media to reduce seeks and the like.
> 
> 	Sander

Such an optimization sounds valid on first sight. But re-think closely: how
does the fs really know about seeks needed during some operation? If your
disk is a single plate one your seeks are completely different from multi
plate. So even a simple case is more or less unpredictable. If you consider a
RAID or SAN as device base it should be clear that trying to optimize for
certain device types is just a fake. What does that tell you? The optimization
was a pure loss of work hours in the first place. In fact if you look at this
list a lot of talks going on are highly academic and have no real usage
scenario.
Sometimes trying to be super-smart is indeed not useful (for a fs) ...
-- 
Regards,
Stephan
