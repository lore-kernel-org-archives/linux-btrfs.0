Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:41972 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbaHYMA6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Aug 2014 08:00:58 -0400
Received: from merkaba.localnet (host-188-174-199-55.customer.m-online.net [188.174.199.55])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id E3157AC
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Aug 2014 14:00:56 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Most recent stable enough btrfs-tools?
Date: Mon, 25 Aug 2014 14:00:56 +0200
Message-ID: <2350809.UalJ0KWvmX@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

I am a bit confused about btrfs-progs git repo URLs and branches.

What is the latest stuff that stills supposed to work okay?

My /home BTRFS RAID 1 on two SSDs filesystem has an error with btrfs check that 
btrfs-tools 3.14.1 cannot repair.

The repo I found on git.kernel.org

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

seems to be stuck at 3.14.2.

But well, now I see, there is an integration branch, buts its also just at:

commit 7b050795a01acb2bec0db84991b4bc9c8680e275
Author: Chris Mason <clm@fb.com>
Date:   Wed May 28 17:01:39 2014 -0400

    scrub: fix uninit return variable in scrub_progress_cycle
    
    Signed-off-by: Chris Mason <clm@fb.com>


Before posting details on this I would like to make sure trying with the most 
recent stuff.

What version do you recommend to try? Kernel wise I am on 3.16.1 plus to BTRFS 
hang / corruption fix patches from this mailing list. But I intend to switch to 
3.17-rc2 once it is out.

Thanks, 
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
