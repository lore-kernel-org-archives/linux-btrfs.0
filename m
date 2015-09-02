Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:45317 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbbIBFCE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Sep 2015 01:02:04 -0400
From: Russell Coker <russell@coker.com.au>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Understanding BTRFS storage
Date: Wed, 2 Sep 2015 15:01:59 +1000
References: <CAG__1a4T=d_O49CnOw+0gtKr56xtrmcjRcmujtUff_s_-oL0Jw@mail.gmail.com> <CAG__1a4x_bv2DURyT0ZW0p+udh43ifcn=bHjUKM4NF1Tk=cYDw@mail.gmail.com> <20150828093502.GO23769@carfax.org.uk>
In-Reply-To: <20150828093502.GO23769@carfax.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201509021502.00043.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 28 Aug 2015 07:35:02 PM Hugo Mills wrote:
>   On Fri, Aug 28, 2015 at 10:50:12AM +0200, George Duffield wrote:
> > Running a traditional raid5 array of that size is statistically
> > guaranteed to fail in the event of a rebuild.
> 
>    Except that if it were, you wouldn't see anyone running RAID-5
> arrays of that size and (considerably) larger. And successfully
> replacing devices in them.

Let's not assume that everyone who thinks that they are "successfully" running 
a RAID-5 array is actually doing so.

One of the features of BTRFS is that you won't get undetected data corruption.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
