From: Sander <sander@humilis.net>
Subject: Re: SSD Optimizations
Date: Thu, 11 Mar 2010 15:39:05 +0100
Message-ID: <20100311143905.GA20569@attic.humilis.net>
References: <4B97F7CE.4030405@bobich.net>
 <4B9829B1.1020706@bobich.net>
 <20100311073853.GA26129@attic.humilis.net>
 <201003111159.58081.hka@qbs.com.pl>
 <20100311123103.34246e95.skraw@ithnet.com>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Hubert Kario <hka@qbs.com.pl>, linux-btrfs@vger.kernel.org,
	Gordan Bobic <gordan@bobich.net>
To: Stephan von Krawczynski <skraw@ithnet.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100311123103.34246e95.skraw@ithnet.com>
List-ID: <linux-btrfs.vger.kernel.org>

Stephan von Krawczynski wrote (ao):
> Honestly I would just drop the idea of an SSD option simply because the
> vendors implement all kinds of neat strategies in their devices. So in the end
> you cannot really tell if the option does something constructive and not
> destructive in combination with a SSD controller.

My understanding of the ssd mount option is also that the fs doens't try
to do all kinds of smart (and potential expensive) things which make
sense for rotating media to reduce seeks and the like.

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
