Return-Path: <SRS0=b0aI=NP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14064C32789
	for <linux-btrfs@archiver.kernel.org>; Sun,  4 Nov 2018 19:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B3932081D
	for <linux-btrfs@archiver.kernel.org>; Sun,  4 Nov 2018 19:55:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B3932081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=angband.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbeKEFLl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 00:11:41 -0500
Received: from tartarus.angband.pl ([54.37.238.230]:53394 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbeKEFLl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Nov 2018 00:11:41 -0500
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.89)
        (envelope-from <kilobyte@angband.pl>)
        id 1gJOUc-0004lh-0r
        for linux-btrfs@vger.kernel.org; Sun, 04 Nov 2018 20:55:30 +0100
Date:   Sun, 4 Nov 2018 20:55:30 +0100
From:   Adam Borowski <kilobyte@angband.pl>
To:     linux-btrfs@vger.kernel.org
Subject: Re: Filesystem mounts fine but hangs on access
Message-ID: <20181104195530.6q2pkiy2aad5u53g@angband.pl>
References: <f0e1900a-b242-06e0-b68f-0ddc146eca56@cs.uni-bonn.de>
 <pan$e6d53$e629c484$21f89be5$9bcbe392@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <pan$e6d53$e629c484$21f89be5$9bcbe392@cox.net>
X-Junkbait: aaron@angband.pl, zzyx@angband.pl
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Nov 04, 2018 at 06:29:06PM +0000, Duncan wrote:
> So do consider adding noatime to your mount options if you haven't done 
> so already.  AFAIK, the only /semi-common/ app that actually uses atimes 
> these days is mutt (for read-message tracking), and then not for mbox, so 
> you should be safe to at least test turning it off.

To the contrary, mutt uses atimes only for mbox.
 
> And YMMV, but if you do use mutt or something else that uses atimes, I'd 
> go so far as to recommend finding an alternative, replacing either btrfs 
> (because as I said, relatime is arguably enough on a traditional non-COW 
> filesystem) or whatever it is that uses atimes, your call, because IMO it 
> really is that big a deal.

Fortunately, mutt's use could be fixed by teaching it to touch atimes
manually.  And that's already done, for both forks (vanilla and neomutt).


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ Have you heard of the Amber Road?  For thousands of years, the
⣾⠁⢰⠒⠀⣿⡁ Romans and co valued amber, hauled through the Europe over the
⢿⡄⠘⠷⠚⠋⠀ mountains and along the Vistula, from Gdańsk.  To where it came
⠈⠳⣄⠀⠀⠀⠀ together with silk (judging by today's amber stalls).
