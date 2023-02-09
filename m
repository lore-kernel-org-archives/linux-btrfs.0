Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE2EC636D6
	for <linux-btrfs@archiver.kernel.org>; Thu,  9 Feb 2023 16:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjBIQIn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 11:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBIQIn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Feb 2023 11:08:43 -0500
X-Greylist: delayed 443 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 09 Feb 2023 08:08:42 PST
Received: from vps.thesusis.net (vps.thesusis.net [34.202.238.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52941100
        for <linux-btrfs@vger.kernel.org>; Thu,  9 Feb 2023 08:08:42 -0800 (PST)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id 7C7D4108DE8; Thu,  9 Feb 2023 11:01:18 -0500 (EST)
References: <cover.1675853489.git.johannes.thumshirn@wdc.com>
User-agent: mu4e 1.7.12; emacs 27.1
From:   Phillip Susi <phill@thesusis.net>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 00/13] btrfs: introduce RAID stripe tree
Date:   Thu, 09 Feb 2023 10:57:00 -0500
In-reply-to: <cover.1675853489.git.johannes.thumshirn@wdc.com>
Message-ID: <874jrun7zl.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Johannes Thumshirn <johannes.thumshirn@wdc.com> writes:

> A design document can be found here:
> https://docs.google.com/document/d/1Iui_jMidCd4MVBNSSLXRfO7p5KmvnoQL/edit?usp=sharing&ouid=103609947580185458266&rtpof=true&sd=true

Nice document, but I'm still not quite sure I understand the problem.
As long as both disks have the same zone layout, and the raid chunk is
aligned to the start of a zone, then shouldn't they be appended together
and have a deterministic layout?

If so, then is this additional metadata just needed in the case where
the disks *don't* have the same zone layout?

If so, then is this an optional feature that would only be enabled when
the disks don't have the same zone layout?

