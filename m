Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:51335 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752953Ab3KUT4S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 14:56:18 -0500
Date: Thu, 21 Nov 2013 20:56:03 +0100
From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: James Plank <plank@cs.utk.edu>, Ric Wheeler <rwheeler@redhat.com>,
        Andrea Mazzoleni <amadvance@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, David Brown <david.brown@hesbynett.no>,
        David Smith <creamyfish@gmail.com>
Subject: Re: Triple parity and beyond
Message-ID: <20131121195603.GA1916@lazy.lzy>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
 <528A90B7.5010905@zytor.com>
 <CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>
 <528AA1EB.3010909@zytor.com>
 <CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com>
 <528BCA2D.5010500@redhat.com>
 <73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu>
 <528D61C5.70902@hardwarefreak.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <528D61C5.70902@hardwarefreak.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 20, 2013 at 07:28:37PM -0600, Stan Hoeppner wrote:
[...]
> It's always perilous to follow a Ph.D., so I guess I'm feeling suicidal
> today. ;)
> 
> I'm not attempting to marginalize Andrea's work here, but I can't help
> but ponder what the real value of triple parity RAID is, or quad, or
> beyond.  Some time ago parity RAID's primary mission ceased to be

Hi Stan,

my opinio is that you have to think
in terms of storage devices which are
not always available.
Those are not simply directly connected
HDDs, it could be more exotic.
The example I consider is a p2p network
storage, where the nodes are very little
reliable.
I guess that could be more.

bye,

-- 

piergiorgio
