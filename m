Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:37569 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752327Ab3H0AQ7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 20:16:59 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Ability to free space on a full btrfs filesystem
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <521BCBFA.8040506@dalmat.net>
Date: Mon, 26 Aug 2013 18:16:54 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <E188878A-91BE-4D63-AFE7-D6D7EE32A30E@colorremedies.com>
References: <521A2F78.908@dalmat.net> <502292E7-02F9-4398-905B-BA58D186CA7E@colorremedies.com> <521BCBFA.8040506@dalmat.net>
To: Matthieu Dalstein <matthieu.dalstein@dalmat.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 26, 2013, at 3:43 PM, Matthieu Dalstein <matthieu.dalstein@dalmat.net> wrote:

> Thanks for the tip. I would have expected another less intrusive recovery but this one worked well. I did not fully rebalance the fs (could have lasted days!) but with the d/m usage balance parameters I managed to get back to a good state.
> 
> I guess this means I should find ways to avoid full fs unless there is a plan to recover gracefully from such situations.

The FAQ describes doing a partial balance to fix this problem as a first step. I think it's a good first step for this problem, rather than full balance, or adding a device. Next step would be add a device and see if a partial balance works, then delete that device and carry on (with normal usage or resuming a full balance).

In my few cases I didn't try partial balances, rather full ones and they almost immediately failed which is how I decided to add a USB flash stick to the volume.


Chris Murphy