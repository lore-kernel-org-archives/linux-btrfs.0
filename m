Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:33711 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755207Ab3HLBPx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Aug 2013 21:15:53 -0400
Date: Mon, 12 Aug 2013 11:15:39 +1000
From: Dave Chinner <david@fromorbit.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Schmidt <list.xfs@jan-o-sch.net>, xfs@oss.sgi.com,
        sbehrens@giantdisaster.de, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 1/2] xfstests: add fssum tool
Message-ID: <20130812011539.GM12779@dastard>
References: <1375949833-1104-1-git-send-email-list.xfs@jan-o-sch.net>
 <1375949833-1104-2-git-send-email-list.xfs@jan-o-sch.net>
 <5203D827.3050909@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5203D827.3050909@sandeen.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 08, 2013 at 12:40:55PM -0500, Eric Sandeen wrote:
> On 8/8/13 3:17 AM, Jan Schmidt wrote:
> >  SUBDIRS =
> >  
> >  LLDLIBS = $(LIBATTR) $(LIBHANDLE) $(LIBACL)
> >  
> > +OPT_LDLIBS = -lssl -lcrypto
> 
> Hm, new deps.  I guess it's not a huge problem, these should always
> be available, right?

Please, let's keep crypto out of xfstests if we can. That's just
going to add a nightmare of US export compliance garbage to any
distro that wants to package and ship this....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
