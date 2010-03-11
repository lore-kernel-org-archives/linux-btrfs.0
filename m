From: Stephan von Krawczynski <skraw@ithnet.com>
Subject: Re: SSD Optimizations
Date: Thu, 11 Mar 2010 12:31:03 +0100
Message-ID: <20100311123103.34246e95.skraw@ithnet.com>
References: <4B97F7CE.4030405@bobich.net>
	<4B9829B1.1020706@bobich.net>
	<20100311073853.GA26129@attic.humilis.net>
	<201003111159.58081.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org, Gordan Bobic <gordan@bobich.net>
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201003111159.58081.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 11 Mar 2010 11:59:57 +0100
Hubert Kario <hka@qbs.com.pl> wrote:

> On Thursday 11 March 2010 08:38:53 Sander wrote:
> > Hello Gordan,
> > 
> > Gordan Bobic wrote (ao):
> > > Mike Fedyk wrote:
> > > >On Wed, Mar 10, 2010 at 11:49 AM, Gordan Bobic <gordan@bobich.net> wrote:
> > > >>Are there options available comparable to ext2/ext3 to help reduce
> > > >>wear and improve performance?
> > 
> > With SSDs you don't have to worry about wear.
> 
> Sorry, but you do have to worry about wear. I was able to destroy a relatively 
> new SD card (2007 or early 2008) just by writing on the first 10MiB over and 
> over again for two or three days. The end of the card still works without 
> problems but about 10 sectors on the beginning give write errors.

Sorry, the topic was SSD, not SD. SSDs have controllers that contain heavy
closed magic to circumvent all kinds of troubles you get when using classical
flash and SD cards.
Honestly I would just drop the idea of an SSD option simply because the
vendors implement all kinds of neat strategies in their devices. So in the end
you cannot really tell if the option does something constructive and not
destructive in combination with a SSD controller.
Of course you may well discuss about an option for passive flash devices like
ide-CF/SD or the like. There is no controller involved so your fs
implementation may well work out.

-- 
Regards,
Stephan

