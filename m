Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8E02C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 19:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AE62205C9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 19:50:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4AE62205C9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbeLETuw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 14:50:52 -0500
Received: from len.romanrm.net ([91.121.75.85]:49176 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728138AbeLETuv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 14:50:51 -0500
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by len.romanrm.net (Postfix) with SMTP id E0D2320284
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 19:50:49 +0000 (UTC)
Date:   Thu, 6 Dec 2018 00:50:49 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     linux-btrfs@vger.kernel.org
Subject: btrfs progs always assume devid 1?
Message-ID: <20181206005049.3642ebd0@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,

To migrate my FS to a different physical disk, I have added a new empty device
to the FS, then ran the remove operation on the original one.

Now my FS has only devid 2:

Label: 'p1'  uuid: d886c190-b383-45ba-9272-9f00c6a10c50
	Total devices 1 FS bytes used 36.63GiB
	devid    2 size 50.00GiB used 45.06GiB path /dev/mapper/vg-p1

And all the operations of btrfs-progs now fail to work in their default
invocation, such as:

# btrfs fi resize max .
Resize '.' of 'max'
ERROR: unable to resize '.': No such device

[768813.414821] BTRFS info (device dm-5): resizer unable to find device 1

Of course this works:

# btrfs fi resize 2:max .
Resize '.' of '2:max'

But this is inconvenient and seems to be a rather simple oversight. If what I
got is normal (the device staying as ID 2 after such operation), then count
that as a suggestion that btrfs-progs should use the first existing devid,
rather than always looking for hard-coded devid 1.

-- 
With respect,
Roman
