Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40537 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755709AbbESLcO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 May 2015 07:32:14 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Yufkq-0002vt-DP
	for linux-btrfs@vger.kernel.org; Tue, 19 May 2015 13:32:12 +0200
Received: from pd953ec41.dip0.t-ipconnect.de ([217.83.236.65])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2015 13:32:12 +0200
Received: from holger.hoffstaette by pd953ec41.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2015 13:32:12 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: [PATCH] Btrfs: fix racy system chunk allocation when setting
 block group ro
Date: Tue, 19 May 2015 11:32:06 +0000 (UTC)
Message-ID: <pan.2015.05.19.11.32.06@googlemail.com>
References: <1431972715-16833-1-git-send-email-fdmanana@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 18 May 2015 19:11:40 +0100, Filipe Manana wrote:

> If while setting a block group read-only we end up allocating a system
> chunk, through check_system_chunk(), we were not doing it while holding
> the chunk mutex which is a problem if a concurrent chunk allocation is
> happening, through do_chunk_alloc(), as it means both block groups can
> end up using the same logical addresses and physical regions in the
> device(s). So make sure we hold the chunk mutex.
> 
> Cc: stable@vger.kernel.org  # 4.0+
> Fixes: 2f0810880f08 ("btrfs: delete chunk allocation attemp when
>                       setting block group ro")

Hello Filipe,

good find, as usual. But from the description it's not clear to me whether
this also fixes rebalance seemingly not having an effect (as reported many
times now) or "just" the on-disk block data getting munched together on a
racy day? Just thought I'd ask for clarification before I start patching.

Thanks!

Holger


