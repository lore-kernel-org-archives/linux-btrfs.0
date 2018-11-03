Return-Path: <SRS0=HXCT=NO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57FD1C0044C
	for <linux-btrfs@archiver.kernel.org>; Sat,  3 Nov 2018 08:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFE8E2081F
	for <linux-btrfs@archiver.kernel.org>; Sat,  3 Nov 2018 08:24:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EFE8E2081F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cox.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbeKCRfS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 3 Nov 2018 13:35:18 -0400
Received: from [195.159.176.226] ([195.159.176.226]:43624 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbeKCRfR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Nov 2018 13:35:17 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1gIrCS-0004iM-Bo
        for linux-btrfs@vger.kernel.org; Sat, 03 Nov 2018 09:22:32 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-btrfs@vger.kernel.org
From:   Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS did it's job nicely (thanks!)
Date:   Sat, 3 Nov 2018 08:22:26 +0000 (UTC)
Message-ID: <pan$e0431$656787$a32d9060$a6ef81db@cox.net>
References: <d03d611b-cd2e-d267-268a-255f90348e43@dirtcellar.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@blaine.gmane.org
User-Agent: Pan/0.146 (Hic habitat felicitas; 22c743dad)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

waxhead posted on Fri, 02 Nov 2018 20:54:40 +0100 as excerpted:

> Note that I tend to interpret the btrfs de st / output as if the error
> was NOT fixed even if (seems clearly that) it was, so I think the output
> is a bit misleading... just saying...

See the btrfs-device manpage, stats subcommand, -z|--reset option, and 
device stats section:

-z|--reset
Print the stats and reset the values to zero afterwards.

DEVICE STATS
The device stats keep persistent record of several error classes related 
to doing IO. The current values are printed at mount time and
updated during filesystem lifetime or from a scrub run.


So stats keeps a count of historic errors and is only reset when you 
specifically reset it, *NOT* when the error is fixed.

(There's actually a recent patch, I believe in the current dev kernel 
4.20/5.0, that will reset a device's stats automatically for the btrfs 
replace case when it's actually a different device afterward anyway.  
Apparently, it doesn't even do /that/ automatically yet.  Keep that in 
mind if you replace that device.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

