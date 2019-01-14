Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 947D1C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 13:06:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5667D20657
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 13:06:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=virtall.com header.i=@virtall.com header.b="DA55ZZXj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfANNGa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 08:06:30 -0500
Received: from mail.virtall.com ([46.4.129.203]:55298 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726449AbfANNGa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 08:06:30 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id 333BB496F82;
        Mon, 14 Jan 2019 13:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtall.com;
        s=default; t=1547471188;
        bh=qo6O7EKpn8FLpJN4zGciF5ARrzN27BUrPAaNvBqng5I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=DA55ZZXjmY8w+WQeGX5Tx/OvTBEq6drZzKJhW8ytltNCYPWoyTBi7boynd9gLWMkA
         uK8mpHJFmY+QUuhbYw5Seo9SbN1Ld/MOXS+wn38VAHVHcDjhMXtOAbuuLvVTVInnSs
         46Aiu564fIYg5NeF0pDKVP0/ogoMBoYv2ccRuNn0tG+gfPCu2Avl2/SZ4jA1FYlWQu
         o3Jf/RcKhXo12dbzCL4pHsoVGKfR/n7RfjCQcUlcgoByyvvDSi4xKmmo4ODW6vyooR
         IgX9P4o7VManAXy5lLdQd1ti1F5eUsUJjqOZzEVvd+L93nJR2Z+pzGnr69B/+5aK0s
         LR2PJmdgKzwnw==
X-Fuglu-Suspect: a4ec1b38cfd343559e42730434e5822e
X-Fuglu-Spamstatus: NO
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA;
        Mon, 14 Jan 2019 13:06:27 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 14 Jan 2019 22:06:26 +0900
From:   Tomasz Chmielewski <tch@virtall.com>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [REGRESSION] Super slow balance in v5.0-rc1
In-Reply-To: <2c1782e8-b68a-4992-84e8-adeef34ca688@gmx.com>
References: <7c6234aaeaf813400da5ff1e68f8c898@virtall.com>
 <2c1782e8-b68a-4992-84e8-adeef34ca688@gmx.com>
Message-ID: <0b0e3f49ebec07edcb9ac4dafd3afa55@virtall.com>
X-Sender: tch@virtall.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-01-14 21:34, Qu Wenruo wrote:
> On 2019/1/14 下午7:47, Tomasz Chmielewski wrote:
>>> When rebasing my qgroup + balance optimization patches, I found one 
>>> very
>>> obvious performance regression for balance.
>>> 
>>> For normal 4G subvolume, 16 snapshots, balance workload, v4.20 kernel
>>> only takes 3s to relocate a metadata block group, while for v5.0-rc1, 
>>> I
>>> don't really know how it will take as it hasn't finished yet.
>> 
>> Are you sure it's v5.0-rc1 regression, not earlier?
> 
> At least for what I'm describing, yes. v5.0-rc1 introduced bug, and
> already pinned down.
> 
> So I'm afraid you're hitting another different bug.
> 
>> 
>> I'm trying to do a metadata-only balance from RAID-5 to RAID-1, with
>> 4.19.8.
>> 
>> It was going relatively "normal", until it got stuck and showing no
>> progress.
>> 
>> I've canceled the balance, upgraded to 4.20, started the balance 
>> again.> For straight 11 days, it rewrote terabytes of data on the 
>> disks, with no
>> progress at all.> Also, 4.19.8 had a balance interrupted because of 
>> "out
>> of space", despite we have terabytes free.
>> 
>> Metadata RAID-5 usage stays at 4.12GiB for the past 11 days (and a few
>> more days with 4.19.8).
> 
> Are you using qgroup? Which is another huge cause of slow balance.

No, no qgroups.

# btrfs quota rescan /data
ERROR: quota rescan failed: Invalid argument
