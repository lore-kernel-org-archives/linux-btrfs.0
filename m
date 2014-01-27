Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49081 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbaA0Wrj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 17:47:39 -0500
Date: Mon, 27 Jan 2014 14:47:31 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Daniel =?utf-8?B?Q2VnaWXFgmth?= <daniel.cegielka@gmail.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: update INSTALL file
Message-ID: <20140127224731.GA9325@birch.djwong.org>
References: <1390371577-1789-1-git-send-email-anand.jain@oracle.com>
 <CAPLrYES8sRMKPpDcAJC+cxj4D3osHz-x1x_RRqpECbvhNB6m2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAPLrYES8sRMKPpDcAJC+cxj4D3osHz-x1x_RRqpECbvhNB6m2A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 27, 2014 at 10:21:32PM +0100, Daniel Cegiełka wrote:
> 2014-01-22 Anand Jain <anand.jain@oracle.com>:
> > with the changes that has happened since last time it was updated
> >
> > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> > ---
> >  INSTALL |    6 ++----
> >  1 files changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/INSTALL b/INSTALL
> > index 8ead607..a86878a 100644
> > --- a/INSTALL
> > +++ b/INSTALL
> > @@ -12,7 +12,8 @@ complete:
> >  modprobe libcrc32c
> >  insmod btrfs.ko
> >
> > -The Btrfs utility programs require libuuid to build.  This can be found
> > +The Btrfs utility programs (btrfs-progs) require libattr zlib libacl
> > +e2fsprogs libblkid lzo2 to build.  This can be found
> >  in the e2fsprogs sources, and is usually available as libuuid or
> >  e2fsprogs-devel from various distros.
> 
> Which version of libblkid should we use? From e2fsprogs or from util-linux?

I think most of the world uses the util-linux version now.  I don't think
there's been much development to the e2fsprogs one in years, aside from
bugfixes.

--D
> 
> libattr/libacl: these libraries are not necessary - you need it only to convert.
> 
> Daniel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
