Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36440 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbbBVSFE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Feb 2015 13:05:04 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YPatq-0000jX-Hk
	for linux-btrfs@vger.kernel.org; Sun, 22 Feb 2015 19:05:02 +0100
Received: from pd953e69f.dip0.t-ipconnect.de ([217.83.230.159])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Feb 2015 19:05:02 +0100
Received: from holger.hoffstaette by pd953e69f.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Feb 2015 19:05:02 +0100
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Suddenly cannot change metadata profile any longer (BISECTED)
Date: Sun, 22 Feb 2015 18:01:07 +0000 (UTC)
Message-ID: <pan.2015.02.22.18.01.07@googlemail.com>
References: <pan.2015.02.15.21.01.07@googlemail.com>
	<pan.2015.02.16.15.18.40@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 16 Feb 2015 15:18:40 +0000, Holger Hoffstätte wrote:

>> What works is the very first balance after the mkfs - it successfully
>> changes from the initial default dup to single, but subsequent balances
>> don't work. They also don't really fail.
> 
> Bisection found that commit 2f0810880f082fa8ba66ab2c33b02e4ff9770a5e [1]
> in the integration tree is the cause:
> 
>   btrfs: delete chunk allocation attemp when setting block group ro
> 
> Reverting/omitting this patch lets me rebalance/convert at will.

Just for the list archives: Chris mailed me privately that they could
reproduce the problem and will provide a fix post-3.20-rc1
(since that commit already went in with the merge window).

-h

