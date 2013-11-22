Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:59725 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756Ab3KVAeH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 19:34:07 -0500
Message-ID: <528EA660.6000307@zytor.com>
Date: Thu, 21 Nov 2013 16:33:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: stan@hardwarefreak.com, joystick <joystick@shiftmail.org>
CC: James Plank <plank@cs.utk.edu>, Ric Wheeler <rwheeler@redhat.com>,
        Andrea Mazzoleni <amadvance@gmail.com>, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, David Brown <david.brown@hesbynett.no>,
        David Smith <creamyfish@gmail.com>
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com> <CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com> <528BCA2D.5010500@redhat.com> <73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu> <528D61C5.70902@hardwarefreak.com> <528DBF85.6010303@shiftmail.org> <528EA5B9.3000801@hardwarefreak.com>
In-Reply-To: <528EA5B9.3000801@hardwarefreak.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/21/2013 04:30 PM, Stan Hoeppner wrote:
> 
> The rebuild time of a parity array normally has little to do with CPU
> overhead.>

Unless you have to fall back to table driven code.

Anyway, this looks like a great concept.  Now we just need to implement
it ;)

	-hpa

