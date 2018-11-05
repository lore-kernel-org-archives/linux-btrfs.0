Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2DC6ECDE44
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 00:32:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F40AE2081D
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 00:32:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F40AE2081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cox.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729718AbeKEJs6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 04:48:58 -0500
Received: from [195.159.176.226] ([195.159.176.226]:59683 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbeKEJs5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Nov 2018 04:48:57 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1gJSm7-0008Jq-V0
        for linux-btrfs@vger.kernel.org; Mon, 05 Nov 2018 01:29:51 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-btrfs@vger.kernel.org
From:   Duncan <1i5t5.duncan@cox.net>
Subject: Re: Filesystem mounts fine but hangs on access
Date:   Mon, 5 Nov 2018 00:29:45 +0000 (UTC)
Message-ID: <pan$49114$16bcec88$40791165$93248047@cox.net>
References: <f0e1900a-b242-06e0-b68f-0ddc146eca56@cs.uni-bonn.de>
        <pan$e6d53$e629c484$21f89be5$9bcbe392@cox.net>
        <20181104195530.6q2pkiy2aad5u53g@angband.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@blaine.gmane.org
User-Agent: Pan/0.146 (Hic habitat felicitas; 22c743dad)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Adam Borowski posted on Sun, 04 Nov 2018 20:55:30 +0100 as excerpted:

> On Sun, Nov 04, 2018 at 06:29:06PM +0000, Duncan wrote:
>> So do consider adding noatime to your mount options if you haven't done
>> so already.  AFAIK, the only /semi-common/ app that actually uses
>> atimes these days is mutt (for read-message tracking), and then not for
>> mbox, so you should be safe to at least test turning it off.
> 
> To the contrary, mutt uses atimes only for mbox.

Figures that I'd get it reversed.
 
>> And YMMV, but if you do use mutt or something else that uses atimes,
>> I'd go so far as to recommend finding an alternative, replacing either
>> btrfs (because as I said, relatime is arguably enough on a traditional
>> non-COW filesystem) or whatever it is that uses atimes, your call,
>> because IMO it really is that big a deal.
> 
> Fortunately, mutt's use could be fixed by teaching it to touch atimes
> manually.  And that's already done, for both forks (vanilla and
> neomutt).

Thanks.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

