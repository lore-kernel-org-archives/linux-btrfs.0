Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:40169 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbaC3ASb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Mar 2014 20:18:31 -0400
Date: Sat, 29 Mar 2014 17:18:25 -0700
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, Lists <lists@benjamindsmith.com>,
        Avi Miller <avi.miller@oracle.com>,
        Johan =?iso-8859-1?Q?Kr=F6ckel?= <johan.kroeckel@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: RHEL/CentOS or Debian for stable deployment
Message-ID: <20140330001825.GO22552@merlins.org>
References: <CABgvyo_b19P2QPzszv6Vxc2iHOceP-ndCp1oUzO6Hc=Z4CiJ=A@mail.gmail.com>
 <CF9CC748-3700-4D4F-AB96-03F27EA9C32B@oracle.com>
 <533607E1.8060202@benjamindsmith.com>
 <20140328234503.GJ7442@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20140328234503.GJ7442@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 28, 2014 at 11:45:03PM +0000, Hugo Mills wrote:
> On Fri, Mar 28, 2014 at 04:38:09PM -0700, Lists wrote:
> > On 03/28/2014 02:42 PM, Avi Miller wrote:
> > >Have you considered Oracle Linux? We are continually backporting btrfs fixes and enhancements to our Unbreakable Enterprise Kernel releases. On Oracle Linux 6, you would run the UEK Release 3, which is based on 3.8 mainline with upstream fixes. We also provide all security and bug fix errata for free viahttp://public-yum.oracle.com, so you don’t need to buy support to run Oracle Linux at keep up-to-date.
> > 
> > Can't remember asking if btrfs is supported on 32 bit kernels?
> 
>    I can't speak for Oracle's distribution, but in the general case,
> yes, btrfs works on 32 bit systems.
> 
>    On the subject of bitness, there's a couple of rough edges with
> 64-bit kernels and 32-bit userspace. (I think there's still one ioctl
> that fails on that configuration, but I've not hit it yet on my test
> machine).

btrfs send does not work with 32bit userland and 64bit kernel when I
last tried it a few weeks ago.
Thankfully I had debian, so I was able to upgrade just btrfs-tools to
64bit without upgrading my entire system, and that solved it.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
