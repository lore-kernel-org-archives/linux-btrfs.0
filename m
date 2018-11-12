Return-Path: <SRS0=fY4Z=NX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE6BC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 12:26:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15F7C22419
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 12:26:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 15F7C22419
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=pignat.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729476AbeKLWTY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 12 Nov 2018 17:19:24 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:36961 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729244AbeKLWTY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Nov 2018 17:19:24 -0500
X-Originating-IP: 153.109.5.233
Received: from [153.109.5.233] (unknown [153.109.5.233])
        (Authenticated sender: marc@pignat.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id E34F6C0011
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Nov 2018 12:26:18 +0000 (UTC)
To:     linux-btrfs@vger.kernel.org
From:   Marc Pignat <marc@pignat.org>
Subject: why /dev/ptmx is in the snapshots?
Openpgp: preference=signencrypt
Autocrypt: addr=marc@pignat.org; keydata=
 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 F9p4
Message-ID: <8f13b640-f50e-9134-57de-96993dfb0fa4@pignat.org>
Date:   Mon, 12 Nov 2018 13:26:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I have a btrfs root partition and I use snapper to automatically take snapshots (ubuntu 18.04 LTS). 

The `/dev/ptmx` file change between each snapshots despite `/dev` is mounted as a devtmpfs file system.

I have tried creating a file in `/dev`, and as expected it is not snapshotted.

My first intuition was that one service was started before `/dev` is mounted as a devtmpfs and still using it, but `sudo fuser /dev/ptmx` show no use of that file.


Can someone explain this behavior?

Thank you in advance and best regards






Marc


P.S: This is a repost of one of my questions on askubuntu.com, since I still don't have any answer.
