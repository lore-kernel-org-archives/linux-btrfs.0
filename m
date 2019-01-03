Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C539C43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 02:52:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40E1620833
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 02:52:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=virtall.com header.i=@virtall.com header.b="jAM7kWh4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729124AbfACCwJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Jan 2019 21:52:09 -0500
Received: from mail.virtall.com ([46.4.129.203]:46384 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728132AbfACCwJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Jan 2019 21:52:09 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id 26BC7370957
        for <linux-btrfs@vger.kernel.org>; Thu,  3 Jan 2019 02:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtall.com;
        s=default; t=1546483927;
        bh=kVe9Mc1+AxLNnHbXp69xVYUOQjmZQ5dNY3ymIxNUTEc=;
        h=Date:From:To:Subject;
        b=jAM7kWh4BK46XmMpe5HBBMKylUqz5htdis6b/j6ZWWNTGpNtQ97uw3aYRI4223gU+
         OSzIlUnEnpqarYGgHWvnv0RRPlgZGRGOHyTe+6c92JT5zyKyqxcxDVPmC7pfZeDOx6
         io18hhiR6p/vFxrs/4ATgsCRSpaot+Yyx9kY3YAkdg2IXln5V+tLA2CCiq/kqpjMPr
         sKTfaFJDbTFRcRHaG/QRXkOCXnbf4osmmH/e4cobxFsMcXGUzQH7DPGooQiRQFzUUg
         LsnhzzliBzGxKKV5bhS7osJi1s/E4w/fl0vneVt1wfqqwj2hdw/4I9GM+nZXwZgX0q
         v0X/u0K4ubZSA==
X-Fuglu-Suspect: 08202a94fb4c4dec8a65d409ec6cc2f6
X-Fuglu-Spamstatus: NO
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Thu,  3 Jan 2019 02:52:06 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 03 Jan 2019 11:52:05 +0900
From:   Tomasz Chmielewski <tch@virtall.com>
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS corruption: open_ctree failed
Message-ID: <155a0e09f60a0605802c459a6e119b36@virtall.com>
X-Sender: tch@virtall.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> I have several BTRFS success-stories, and I've been an happy user for 
> quite=
> a long time now. I was therefore surprised to face a BTRFS corruption 
> on a=
> system I'd just installed.
> I use NixOS, unstable branch (linux kernel 4.19.12). The system runs on 
> a S=
> SD with an ext4 boot partition, a simple btrfs root with some 
> subvolumes, a=

Did you use 4.19.x kernels earlier than 4.19.8?

They had a bug which would corrupt filesystems (mostly ext4 users would 
be reporting it, but I saw it with other filesystems, like xfs and 
btrfs, too):

https://www.phoronix.com/scan.php?page=news_item&px=Linux-4.19-4.20-BLK-MQ-Fix

Interestingly, btrfs in RAID mode would often detect and correct these 
corruptions.
