Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:48637 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710Ab3DYUjD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Apr 2013 16:39:03 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id AB6FF9A069A
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2013 14:39:02 -0600 (MDT)
Date: Thu, 25 Apr 2013 16:39:00 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Matt Pursley <mpursley@gmail.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: One random read streaming is fast (~1200MB/s), but two or more
 are slower (~750MB/s)?
Message-ID: <20130425203900.GL2631@localhost.localdomain>
References: <CAG42UxdVpz7a0FPEc7Ajm+jHHrqG7zT2=JaPZcFzMQT18eqzww@mail.gmail.com>
 <20130417065506.GA21083@panda>
 <CAG42Uxcjk-T9e-9uO6L+dLzqo3N7c+RMvUyaS2WE_aFWK9niJA@mail.gmail.com>
 <CAG42Uxccx7NzJN2oyyAqU9mWN8q-6==V2zg1OQ2mOfvBZtbs1w@mail.gmail.com>
 <20130418215856.GA2305@localhost.localdomain>
 <CAG42Uxeajo=RESm531A7WWtFzKsFVDRJXuve1BRQXFPceFTMgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAG42Uxeajo=RESm531A7WWtFzKsFVDRJXuve1BRQXFPceFTMgw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 25, 2013 at 01:52:44PM -0600, Matt Pursley wrote:
> Hey Josef,
> 
> Were you able to look into this any further?
> It's still pretty reproducible on my machine...
> 

Nope I've been tracking down random problems, I'll try it now.  Thanks,

Josef
