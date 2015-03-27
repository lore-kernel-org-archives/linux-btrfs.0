Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47325 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbbC0AVx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Mar 2015 20:21:53 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YbI1s-0006be-Tf
	for linux-btrfs@vger.kernel.org; Fri, 27 Mar 2015 01:21:40 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Mar 2015 01:21:40 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Mar 2015 01:21:40 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: btrfs-transacti causing IO problem to btrfs (skinny-metadata?)
Date: Fri, 27 Mar 2015 00:21:32 +0000
Message-ID: <mf27qc$io$1@ger.gmane.org>
References: <551271DE.9020609@strath.ac.uk> <metvnc$nmp$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <metvnc$nmp$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For anyone stumbling across this thread:

For my example, all was cleaned up by using the btrfs scrub:

btrfs scrub start /mountpoint


No data lost.

Good luck,
Martin


On 25/03/15 09:38, Martin wrote:

> 
> Is that btrfs system formatted with a previous kernel (pre-
> skinny-metadata) and is now being used with a kernel that newly has
> skinny-metadata enabled by default?...
> 
> 
> I've stumbled across a bug/change/patch listed for a mixed pre/post
> skinny-metadata whereby you get to see lots of csum errors in the logs...
> 
> For one 16TB btrfs raid1 system that brought things down to read-only...
> 
> 
> I'm now on kernel 3.18.9, and Btrfs v3.18.2. Presently copying the
> latest data onto a backup before trying a scrub! :-)
> 
> LOTs of:
> 
> kernel: parent transid verify failed on 5992676900864 wanted 70743 found
> 70709
> kernel: parent transid verify failed on 5992676900864 wanted 70743 found
> 70709
> kernel: BTRFS info (device sdj): no csum found for inode 50675726 start
> 16384
> kernel: BTRFS info (device sdj): csum failed ino 50675726 off 0 csum
> 42383870 expected csum 0
> kernel: BTRFS info (device sdj): csum failed ino 50675726 off 4096 csum
> 815939273 expected csum 0
> 
> and variations seen.
> 
> (Or advice for that one welcomed! ;-) )


