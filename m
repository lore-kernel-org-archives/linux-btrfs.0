Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:59252 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab3EDLUH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 May 2013 07:20:07 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 7BCF87C04D8
	for <linux-btrfs@vger.kernel.org>; Sat,  4 May 2013 05:20:07 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Chris Mason <chris.mason@fusionio.com>
To: Dave Chinner <david@fromorbit.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <20130504011547.GB19978@dastard>
In-Reply-To: <20130504011547.GB19978@dastard>
Message-ID: <20130504112005.5844.26279@localhost.localdomain>
Subject: Re: [3.9] parallel fsmark perf is real bad on sparse devices
Date: Sat, 4 May 2013 07:20:05 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Dave Chinner (2013-05-03 21:15:47)
> Hi folks,
> 
> It's that time again - I ran fsmark on btrfs and found performance
> was awful.
> 
> tl;dr: memory pressure causes random writeback of metadata ("bad"),
> fragmenting the underlying sparse storage. This causes a downward
> spiral as btrfs cycles through "good" IO patterns that get
> fragmented at the device level due to the "bad" IO patterns
> fragmenting the underlying sparse device.
> 

Really interesting Dave, thanks for all this analysis.

We're going to have hard time matching xfs fragmentation just because
the files are zero size and we don't have the inode tables.  But, I'll
take a look at the metadata memory pressure based writeback, sounds like
we need to push a bigger burst.

-chris
