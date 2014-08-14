Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33519 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751521AbaHNFVj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 01:21:39 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
	by gateway1.nyi.internal (Postfix) with ESMTP id 0EB8E22F1D
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Aug 2014 01:21:36 -0400 (EDT)
Message-Id: <1407993696.3962313.152559325.65391308@webmail.messagingengine.com>
From: Rasmus Abrahamsen <me@rasmusa.net>
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
In-Reply-To: <C14B310E-5F2B-4762-884B-AA11108373D3@colorremedies.com>
References: <53EAF935.4040605@rasmusa.net> <20140813145155.GA20611@merlins.org>
 <1407944166.3763056.152323965.0FFD88B6@webmail.messagingengine.com>
 <pan$d18a1$d124172b$7cfbfa6b$9072ec25@cox.net>
 <C14B310E-5F2B-4762-884B-AA11108373D3@colorremedies.com>
Subject: Re: delete missing /dev/sdd which is now added as /dev/sdd1
Date: Thu, 14 Aug 2014 07:21:36 +0200
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wow, such a long and detailed message. Thank you so much for taking the
time to do this.

Well, to be honest, I am starting to like the idea of starting over,
although it will be a pain.

Besides, I would have to wait for any distro to make a live disk with
the new btrfs version because my linux partition is also on that raid.

I also learned that "btrfs delete missing" should only be used if the
drive is gone forever, not to force remove it because of a mistake I did
myself (tried to replace it with the 1,5 GB partition).

On Thu, Aug 14, 2014, at 04:06 AM, Chris Murphy wrote:
> 
> On Aug 13, 2014, at 5:19 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> > 
> > 2) Wait for the patch to make it into kernel 3.17 and go from there.
> 
> Based on integration right now it looks like a lot of stuff.
> 
> 
> > 3) Go read the list and find and cherrypick that patch, then rebuild with
> > it included, and go from there.
> 
> Could be this one:
> http://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/patch/?id=0c414ebcd5ba515b58249099619a5d9dbcc1a3b8
> 
> 
> Chris Murphy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
