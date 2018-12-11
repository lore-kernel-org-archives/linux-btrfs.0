Return-Path: <SRS0=yXFy=OU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5CD2C07E85
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Dec 2018 15:21:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A72D20849
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Dec 2018 15:21:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=virtall.com header.i=@virtall.com header.b="hPgGNWtu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A72D20849
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=virtall.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbeLKPVM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 11 Dec 2018 10:21:12 -0500
Received: from mail.virtall.com ([46.4.129.203]:41346 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726241AbeLKPVK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Dec 2018 10:21:10 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id 800BE1984A1;
        Tue, 11 Dec 2018 15:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtall.com;
        s=default; t=1544541667;
        bh=bd2llKny71p56VsRbUwKn6NdBYYTPaJm+Oax1nfxsSA=;
        h=Date:From:To:Cc:Subject;
        b=hPgGNWtu+bF3qbnYmyHAo0sikdIDi+0S/ZyDohCoRyB9j8KQyOfJs09Gnd7jaVbYO
         Ts2xQeX2xo1mQvyXV10hDj59iWow/7odmmHjiEDQJSwytb0Gx1wVs+Z5O2Fh9UYJAu
         MSDuFpHlN1NJKxJDwOmt4ksIDL/dRpDRZoodXrSBScPGAkR/tSW2PzWL5vHHjGVZA3
         LQNo9OOBehYBjhb7IcQo69efESp7oVMHMc3Do05rckisfIrVzvJfKkBoj6ysfdn3+V
         dTROf9VmgEK43YkulNZVXAiDV/MN9nmRyiuNTEYEBYg9tUnnkBtZLKgXORT0RlWKcr
         lXqvO8PVvKGhw==
X-Fuglu-Suspect: 8cb9193dee164578b2c7d30b37fccebe
X-Fuglu-Spamstatus: NO
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA;
        Tue, 11 Dec 2018 15:21:06 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 12 Dec 2018 00:21:05 +0900
From:   Tomasz Chmielewski <tch@virtall.com>
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc:     srb@cuci.nl
Subject: Re: Kernel traces
Message-ID: <17869db912a3d4ec0bfb523a3ac9d132@virtall.com>
X-Sender: tch@virtall.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> (The most recent ones are from v4.19.7):

Please, don't run 4.19.x lower than v4.19.8. It will likely eat your 
filesystem.

Reference: 
https://www.phoronix.com/scan.php?page=news_item&px=Linux-4.19.8-Released

With btrfs, the chances are that data and metadata checksumming will 
detect the introduced corruption and fix the error, but still, it's not 
safe (especially if you don't have btrfs RAID i.e. on other partitions).


Tomasz Chmielewski
https://lxadm.com
