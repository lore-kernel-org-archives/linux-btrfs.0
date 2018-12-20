Return-Path: <SRS0=ilb6=O5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D38C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Dec 2018 22:23:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 853D4218FD
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Dec 2018 22:23:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=petezilla.co.uk header.i=@petezilla.co.uk header.b="XMnAvFZS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390139AbeLTWXF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 20 Dec 2018 17:23:05 -0500
Received: from phi.wiserhosting.co.uk ([77.245.66.218]:45994 "EHLO
        phi.wiserhosting.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbeLTWXE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Dec 2018 17:23:04 -0500
X-Greylist: delayed 3825 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2018 17:23:04 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=petezilla.co.uk; s=default; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Date:Message-ID:Subject:From:To:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=AUn23gnI+BoMaRKZueK8QvM5r4sthmoXjsElmAKD21g=; b=XMnAvFZS0f5JqcLSqgOlFffQxV
        MMtz5JZkcmBmnHER3cVuk9m+lu8t04Iq+lcYsaab6Z+A/2zh2JZuOZlE/ZnTUcqYGG9T2l7TZmaL8
        +PWhdehbE3VBkDEJp/9Yp84ryJW0CYv0n4/r2kBKUl34A5+6myHf4NmXGppQZAoiThHmTSmqcwlNQ
        pr3mEbEkySrnAk9cJrSOTjowHcXQe303PioPm6mZjhFJ0f86LfP8+TrkleqUebiNu4POzpvjI/2cU
        0YVkT/l7Fstb0etyYX6uDMyk0cfQV/dB1WJPHBpIPRVDoBgjPuxcof5YtYLKgqb3rMPZhRG0LejPC
        Gz9gOuNA==;
Received: from cpc75874-ando7-2-0-cust841.15-1.cable.virginm.net ([86.12.75.74]:51894 helo=[172.16.100.105])
        by phi.wiserhosting.co.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <pete@petezilla.co.uk>)
        id 1ga5iv-004urq-Et; Thu, 20 Dec 2018 21:19:17 +0000
To:     linux-btrfs@vger.kernel.org
From:   Peter Chant <pete@petezilla.co.uk>
Subject: Mount issue, mount /dev/sdc2: can't read superblock
Message-ID: <1aa82e28-3331-bc64-071c-6cf87b08ad94@petezilla.co.uk>
Date:   Thu, 20 Dec 2018 21:21:27 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-OutGoing-Spam-Status: No, score=-0.1
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - phi.wiserhosting.co.uk
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - petezilla.co.uk
X-Get-Message-Sender-Via: phi.wiserhosting.co.uk: authenticated_id: pete@petezilla.co.uk
X-Authenticated-Sender: phi.wiserhosting.co.uk: pete@petezilla.co.uk
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I managed to break my root partition today.  Playing with GPU
passthrough to a second graphics card, unsuccessfully, I suspect lead to
some lockups and/or unclean mounts.

I've Googled a bit and tried a number of things stopping just before
'btrfs check --repair'.  I'm running kernel 4.19.10.  I now have the
latest version of btrfs-progs, but I do admit to 'having a go' with
btrfs-progs 4.4.something from a Mint installation.

I've tried btrfs-find-root - and got the following:

btrfs-find-root /dev/sdc2
Superblock thinks the generation is 793794
Superblock thinks the level is 1
Found tree root at 1113905790976 gen 7937947 level 1

(transcribed by reading off PC and typing into laptop, any errors are mine)

Not sure what to do with the above info.  Should I just reformat and
re-install (inc backups) or is there something worth trying?

Pete
