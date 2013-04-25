Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:40925 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab3DYVKW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Apr 2013 17:10:22 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id C687A7C0425
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2013 15:10:21 -0600 (MDT)
Date: Thu, 25 Apr 2013 17:10:19 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Matt Pursley <mpursley@gmail.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: One random read streaming is fast (~1200MB/s), but two or more
 are slower (~750MB/s)?
Message-ID: <20130425211019.GM2631@localhost.localdomain>
References: <CAG42UxdVpz7a0FPEc7Ajm+jHHrqG7zT2=JaPZcFzMQT18eqzww@mail.gmail.com>
 <20130417065506.GA21083@panda>
 <CAG42Uxcjk-T9e-9uO6L+dLzqo3N7c+RMvUyaS2WE_aFWK9niJA@mail.gmail.com>
 <CAG42Uxccx7NzJN2oyyAqU9mWN8q-6==V2zg1OQ2mOfvBZtbs1w@mail.gmail.com>
 <20130418215856.GA2305@localhost.localdomain>
 <CAG42Uxeajo=RESm531A7WWtFzKsFVDRJXuve1BRQXFPceFTMgw@mail.gmail.com>
 <20130425203900.GL2631@localhost.localdomain>
 <CAG42UxcVhXT5=kgUedAWDbSnPuW_Nu---PsG+WRuNCFn9Kdeng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAG42UxcVhXT5=kgUedAWDbSnPuW_Nu---PsG+WRuNCFn9Kdeng@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 25, 2013 at 03:01:18PM -0600, Matt Pursley wrote:
> Ok, awesome, let me know how it goes..  I don't have the raid
> formatted to btrfs right now, but I could probably do that in about 30
> minutes or so.
> 

Huh so I'm getting the full bandwidth, 120 mb/s with one thread and 60 mb/s with
two threads.  These are just cheap sata drives tho, I'll try and dig up a box
with 3 fusion cards for something a little closer to the speeds you are seeing
and see if that makes a difference.  Thanks,

Josef
