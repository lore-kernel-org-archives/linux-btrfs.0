Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:38375 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942Ab3C2M6f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Mar 2013 08:58:35 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 005899A068E
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2013 06:58:34 -0600 (MDT)
Date: Fri, 29 Mar 2013 08:58:32 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: scrub "correcting" tons of errors ?
Message-ID: <20130329125832.GB1876@localhost.localdomain>
References: <515563D7.3020706@petaramesh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <515563D7.3020706@petaramesh.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 29, 2013 at 03:50:15AM -0600, Swâmi Petaramesh wrote:
> Hi there,
> 
> I've started "btrfs scrub start /" on one of my machines (Kernel
> 3.8.0-15 Ubuntu AMD64), which typically "behaves well" so I wasn't
> suspected any disk issue.
> 
> After having ran for only 165 seconds, "scrub status" shows it pretends
> having found and corrected 22926 CSUM errors ??!?!?!?!!???
> 
> This is a rather new HDD, in perfect shape (SMART all OK, never
> reallocated a single sector, less than 200 hours total runtime...)
> 
> WTF ?!?
> 
> I've cancelled scrub for now, until I get further understanding of what
> can be happening...
> 

So this is probably because of the extent tree corruption you had, it's just
cleaning things up and you should be fine once it finishes.  Thanks,

Josef
