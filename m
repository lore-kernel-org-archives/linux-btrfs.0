Return-Path: <SRS0=fkno=ZU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA413C432C0
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Nov 2019 03:45:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F0E42166E
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Nov 2019 03:45:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hMo4zspO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbfK1DpG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Nov 2019 22:45:06 -0500
Received: from mail-ed1-f52.google.com ([209.85.208.52]:42254 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727117AbfK1DpF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Nov 2019 22:45:05 -0500
Received: by mail-ed1-f52.google.com with SMTP id e10so1454085edv.9
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Nov 2019 19:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=J+3BDIq39RSw0qnL/ejXv9XyH/mM2u4LYVIZ4oDLnhY=;
        b=hMo4zspO3xQ1DmZPzsB/dMPS0iR1LWd74Ro75lCLtBdX89uqU4V9k/WtuplMoCrrhl
         O9+HDlDYh4H96KU1fnk110zW7B8TZBVMA5x2+1tEurIQcFG3XHl2eyxmbknDxATfzrSE
         FpcTDGJepeWBV6/sAofLVjjdO95Dxbv7xPcyBNukp+sZXA125ozn66T6PmHpY5KTzm+g
         hegVo2+UsCPq6A5ekJqcTFaH4ieMrb2/H2uxx0k8ModUBeeIHqVwGoQBVSOFVcbdHwzn
         prsOfU4JZK1YMmRhqsMe9U0fDFvG7x3yIepj+gsqq0AwJp0Eo/2mRh6fpziFuxHJHKyZ
         vudg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=J+3BDIq39RSw0qnL/ejXv9XyH/mM2u4LYVIZ4oDLnhY=;
        b=j2wjmHw8NpEhcsvVFrAaKgiMTFRodq++/sdhMCPh+saacmWC/U/N711sTGpOSebP/D
         Jrg3TnJ2lFWMYXI/68aMwVRse+jQmkgtzWMxtjMiKhMUkmsLsnO6JpdSJrWCqawMdOWi
         5zAYdS8wmq1AqC0l2e35NZjivzoDCu78oA8cr+6KpNNqkXVhczszZePWC4KUrOJzLw18
         PoT/485bnQmYjSrEpqet4LNheh38CAgwcgQZsw+o8BMSV+IDFkiFwHpqxzOIyBIM/iXe
         uoUK4lvsI94djNDC8AnfD6WquZ0DDXjt9o4uRzpWTnieEF6VchVqGVTfjG2qYHeBsp69
         pHMg==
X-Gm-Message-State: APjAAAVm9flsktkKkPnbJRd/ufG17obH8CFUkUkbQUgx4DVqQgCQ1h8q
        GKxr2F3d7Js39h6h9lfU/veQx6xj/a9oKN+Fv+uYiWB6
X-Google-Smtp-Source: APXvYqxlEgd5dazYkQJZJPL63vcC5LyZDBUnssu78pbZXwIVRcpmFC7POC7xhzzp4vweZOGDrIbOWWPT5xoCfylx7Vw=
X-Received: by 2002:a17:906:80c:: with SMTP id e12mr53327911ejd.59.1574912703863;
 Wed, 27 Nov 2019 19:45:03 -0800 (PST)
MIME-Version: 1.0
From:   Meng Xu <mengxu.gatech@gmail.com>
Date:   Wed, 27 Nov 2019 22:44:53 -0500
Message-ID: <CAAwBoOJpmhs9dQHcVYorCeAW81JySM4fGFf8Rp9LJhvBtpCw3g@mail.gmail.com>
Subject: potential data race on disk_i_size in two btrfs_endio_writer_helper()
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Btrfs Developers,

I found a potential data race around the disk_i_size in btrfs inodes.
Following is the call stack in the helper threads.

[Thread 1]
btrfs_endio_write_helper
  normal_work_helper
    finish_ordered_fn
      btrfs_finish_ordered_io
        btrfs_ordered_update_i_size
          [WRITE] BTRFS_I(inode)->disk_i_size = new_i_size;

[Thread 2]
btrfs_endio_write_helper
  normal_work_helper
    finish_ordered_fn
      btrfs_finish_ordered_io
        insert_reserved_file_extent
          __btrfs_drop_extents
            [READ] if (start >= BTRFS_I(inode)->disk_i_size && !replace_extent)

I can confirm that the read and write may happen in close proximity
(in time) and the READ may get either the old value or the new value
of the disk_i_size. Is this a valid data race or some operation
designed for lock-free accesses?

Best Regards,
Meng
