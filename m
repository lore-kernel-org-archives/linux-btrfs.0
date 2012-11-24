Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50681 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab2KXDji (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Nov 2012 22:39:38 -0500
Date: Sat, 24 Nov 2012 11:39:12 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Arendt <admin@prnet.org>
Cc: "Garry T. Williams" <gtwilliams@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: extended attributes wiredness
Message-ID: <20121124033910.GA5680@gmail.com>
Reply-To: bo.li.liu@oracle.com
References: <50AFB620.6040707@prnet.org>
 <2925363.jTFvA7mLni@vfr>
 <50AFE5FC.7040304@prnet.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50AFE5FC.7040304@prnet.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 23, 2012 at 10:09:16PM +0100, David Arendt wrote:
> Well, this is only code to demonstrate the problem, the ; is normally a
> silly mistake, but for my test case valuelen is < 0 so, the ; doesn't
> change anything. With this corrected, the problem stays the same.
> 
> On 11/23/12 21:43, Garry T. Williams wrote:
> > On Friday, November 23, 2012 18:45:04 David Arendt wrote:
> >>   for (i = 0; i < attrslen; i+= strlen(&attrs[i]) + 1)
> >>   {
> >>     printf("processing attribute %s\n", &attrs[i]);
> >>
> >>     valuelen = lgetxattr(argv[1], &attrs[i], value, 1024);
> >>
> >>     if (valuelen < 0);
> >   Hmmm ----------------^

Hi David,

Any dmesg output for this?

thanks,
liubo

> >
> >
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
