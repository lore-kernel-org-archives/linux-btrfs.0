Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37103 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378AbbA2KIu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Jan 2015 05:08:50 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YGm1h-0005jd-Pg
	for linux-btrfs@vger.kernel.org; Thu, 29 Jan 2015 11:08:41 +0100
Received: from pd953ef1f.dip0.t-ipconnect.de ([217.83.239.31])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Jan 2015 11:08:41 +0100
Received: from holger.hoffstaette by pd953ef1f.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Jan 2015 11:08:41 +0100
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Indefinite hang in reserve_metadata_bytes on kernel 3.18.3
Date: Thu, 29 Jan 2015 10:08:32 +0000 (UTC)
Message-ID: <pan.2015.01.29.10.08.32@googlemail.com>
References: <868704D3-B79F-476F-A4CF-33C41274E6D4@opentable.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 29 Jan 2015 01:44:02 +0000, Steven Schlansker wrote:

[..snip..]

> The symptoms are an endlessly increasing stream of hung tasks and high

Please try 3.18.5 (-rc1 is good) which contains the following fix:

"workqueue: fix subtle pool management issue which can stall whole
 worker_pool"

see: http://article.gmane.org/gmane.linux.kernel.stable/122074

No promises but it seems sufficiently causally related..

-h

