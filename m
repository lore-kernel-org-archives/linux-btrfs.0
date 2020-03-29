Return-Path: <SRS0=kgr2=5O=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3438EC43331
	for <linux-btrfs@archiver.kernel.org>; Sun, 29 Mar 2020 04:03:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0566C20659
	for <linux-btrfs@archiver.kernel.org>; Sun, 29 Mar 2020 04:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgC2EDg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 29 Mar 2020 00:03:36 -0400
Received: from 4brad.ctyme.com ([184.105.182.90]:57754 "EHLO 4brad.ctyme.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbgC2EDf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Mar 2020 00:03:35 -0400
Received: from [192.168.123.14] (c-76-102-119-11.hsd1.ca.comcast.net [76.102.119.11])
        by 4brad.ctyme.com (Postfix) with ESMTPSA id 4EFF06340A35
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Mar 2020 00:03:35 -0400 (EDT)
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From:   Brad Templeton <4brad@templetons.com>
Subject: Re: btrfs-transacti hangs system for several seconds every few
 minutes
Organization: http://www.templetons.com/brad
Message-ID: <c8513b49-1408-3d99-b1ff-95c36de2ef67@templetons.com>
Date:   Sat, 28 Mar 2020 21:03:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Not using qgroups.  Not doing snapshots.    Did a reboot with the
options to upgrade to v2 -- it failed, in that the disk check took more
than 6 minutes, but it worked, and the second time I was able to boot,
and -- knock on wood -- so far it has not hung.

I wonder why they put 5.3.0 as the standard advanced Kernel in Ubuntu
LTS if it has a data corruption bug.   I don't know if I've seen any
release of 5.4.14 in a PPA yet -- manual kernel install is such a pain
the few times I have done it.  I could revert, but the reason I switched
to 5.3, not long ago, was another problem with sound drivers.

BTW, even though it now works, it still takes 90 seconds every boot
doing a disk check, even after what I think is a clean shutdown.   I
presume that is not normal, any clues on what may cause that?
