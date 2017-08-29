Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.nic.cz ([217.31.204.67]:33305 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751275AbdH2XIO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Aug 2017 19:08:14 -0400
Received: from localhost (unknown [172.20.6.218])
        by mail.nic.cz (Postfix) with ESMTPS id B8C2461DF8
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Aug 2017 01:08:12 +0200 (CEST)
Date: Wed, 30 Aug 2017 01:07:56 +0200
From: Marek Behun <marek.behun@nic.cz>
To: linux-btrfs@vger.kernel.org
Subject: Can a compressed file extent have non-zero offset?
Message-ID: <20170830010756.05d8f9f3@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I cannot find this in the documentation (and the sources are too long),
so I am trying here:

can a file_extent_item with
  item.type == BTRFS_FILE_EXTENT_REG
and
  item.compression != BTRFS_COMPRESS_NONE

have non zero offset (item.offset != 0) ?

What does it mean in such a case? That compressed data start at 0, but
in the uncompressed data, the data begin at item.offset? What does
item.num_bytes in this case mean - the valid number of bytes from
position item.offset, or the number of all bytes, even those before
position item.offset?

Thank you.

Marek
