Return-Path: <SRS0=qcWT=ZF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57757C43331
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Nov 2019 01:37:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03059222D0
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Nov 2019 01:37:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=raptorengineering.com header.i=@raptorengineering.com header.b="HX5y8T4Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfKMBhR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 20:37:17 -0500
Received: from mail.rptsys.com ([23.155.224.45]:10519 "EHLO mail.rptsys.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726936AbfKMBhR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Nov 2019 20:37:17 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 38CFFC39A4097
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Nov 2019 19:37:16 -0600 (CST)
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id xxppSmJMOCL8 for <linux-btrfs@vger.kernel.org>;
        Tue, 12 Nov 2019 19:37:15 -0600 (CST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id BD173C39A3F8D
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Nov 2019 19:37:15 -0600 (CST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com BD173C39A3F8D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
        t=1573609035; bh=S1uzsxzNGIVwfmQB8CUC8a1xZ/+mEpcMBd8Iiv5l+ss=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=HX5y8T4Y6g2BHmcFGNdqgJF2I9Wu94JHqILlzPxzn6K5Pkv6HFEJ+pzcb++hL7rSh
         wUKD/cnwag3r4nax0YkT0015z4Vp+opujGNTtLQqPrFAa6uuOCDEww67QrmVQIY5gi
         hd+EaI9Vg8ARlVbSVy5X4CfNkjsbjcS5Hm7ZO4Ok=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Q6yEYVdC9vkZ for <linux-btrfs@vger.kernel.org>;
        Tue, 12 Nov 2019 19:37:15 -0600 (CST)
Received: from vali.starlink.edu (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id A6859C39A3F5B
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Nov 2019 19:37:15 -0600 (CST)
Date:   Tue, 12 Nov 2019 19:37:15 -0600 (CST)
From:   Timothy Pearson <tpearson@raptorengineering.com>
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <1204250219.669.1573609035591.JavaMail.zimbra@raptorengineeringinc.com>
Subject: Potential CVE due to malicious UUID conflict?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.5.0_GA_3042 (ZimbraWebClient - GC65 (Linux)/8.5.0_GA_3042)
Thread-Index: f+d0XqVXmcQFh1Eux+qwALmMtFCWbw==
Thread-Topic: Potential CVE due to malicious UUID conflict?
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I was recently informed on #btrfs that simply attaching a device with the same UUID as an active BTRFS filesystem to a system would cause silent corruption of the active disk.

Two questions, since this seems like a fairly serious and potentially CVE-worthy bug (trivial case would seem to be a USB thumbdrive with a purposeful UUID collision used to quietly corrupt data on a system that is otherwise secured):

1.) Is this information correct?
2.) Does https://lkml.org/lkml/2019/2/10/23 offer sufficient protection against a malicious device being attached iff the malicious device is never mounted?

Thank you!
