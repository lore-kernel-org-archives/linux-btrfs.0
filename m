Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:51803 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbaDXVlJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 17:41:09 -0400
Date: Thu, 24 Apr 2014 14:41:08 -0700
From: Marc MERLIN <marc@merlins.org>
To: Daniel Lee <longinus00@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Which companies are using Btrfs in production?
Message-ID: <20140424214108.GU26949@merlins.org>
References: <20140424011834.GN26949@merlins.org> <20140424011952.GO26949@merlins.org> <535912E5.7080106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <535912E5.7080106@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 24, 2014 at 06:34:29AM -0700, Daniel Lee wrote:
> On 04/23/2014 06:19 PM, Marc MERLIN wrote:
> > Oh while we're at it, are there companies that can say they are using btrfs
> > in production?
> >
> > Marc
> Netgear uses BTRFS as the filesystem in their refreshed ReadyNAS line.
> They apparently use Oracle's linux distro so I assume they're relying on
> them to do most of the heavy lifting as far as support BTRFS and
> backporting goes since they're still on 3.0! They also have raid5/6
> support so they are probably running BTRFS on top of md.
> 
> http://www.netgear.com/images/BTRFS%20on%20ReadyNAS%20OS%206_9May1318-76105.pdf

Thanks for those pointers.

I've created a page where we can add these:
https://btrfs.wiki.kernel.org/index.php/Production_Users

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
