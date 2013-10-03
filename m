Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:23902 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753360Ab3JCDPh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Oct 2013 23:15:37 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Corrupt btrfs filesystem recovery... What best instructions?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <l2ietn$jv1$1@ger.gmane.org>
Date: Wed, 2 Oct 2013 19:31:37 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <7912C4A1-1A0A-4CD3-A923-392D7B04DCE6@colorremedies.com>
References: <l27agq$u5a$1@ger.gmane.org> <l27mn1$squ$1@ger.gmane.org> <l2826k$1uc$1@ger.gmane.org> <pan$69794$b0c00066$a4aa3035$c87a3c3d@cox.net> <l2a635$37m$1@ger.gmane.org> <l2ietn$jv1$1@ger.gmane.org>
To: Martin <m_btrfs@ml1.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 2, 2013, at 6:49 PM, Martin <m_btrfs@ml1.co.uk> wrote:

> kernel: btrfs read error corrected: ino 1 off 907183792128 (dev /dev/sdc sector 1781821200)

Can anyone answer if this is what corrupt metadata detection and correction looks like? From the original email this is a single disk, with default mkfs.btrfs. So I guess I'm asking an almost obvious question, but I'm still going to ask it. There is only one copy of data, but two copies of metadata so it can self-correct for metadata corruption.

Next question. Why is -o recovery needed to get this correction behavior? The original post was completely devoid of messages indicating correction.


Chris Murphy