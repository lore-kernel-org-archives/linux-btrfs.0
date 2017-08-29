Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.nic.cz ([217.31.204.67]:55679 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751180AbdH2Qvl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Aug 2017 12:51:41 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPS id 2F7AD615D7
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Aug 2017 18:44:41 +0200 (CEST)
Date: Tue, 29 Aug 2017 18:43:42 +0200
From: Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To: linux-btrfs@vger.kernel.org
Subject: Decompression success/failure dependent on PAGE_SIZE?
Message-ID: <20170829184342.2f6ec0b0@dellmb.labs.office.nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

so I've been studying the linux btrfs code and have come across this:

in inode.c function uncompress_inline the max_size size variable is set
to min(max_size, PAGE_SIZE) and only max_size of output data are
decompressed.

The code for compression (in lzo.c for example) uses PAGE_SIZEd chunks
to compress an inline extent.

If I understand it correctly, then if the filesystem is created and used
on a computer with PAGE_SIZE for example 16KB, and an extent of size
16KB is compressed to (for example 9KB) and stored as inline extent,
and then the filesystem is mounted on a computer with PAGE_SIZE = 4KB,
reading the extent will result in a failure or incomplete read.

Is this a bug, or is this behaviour a feature?

Thank you.

Marek
