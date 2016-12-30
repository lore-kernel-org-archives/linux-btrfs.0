Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:33143 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754238AbcL3U2l (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Dec 2016 15:28:41 -0500
Received: by mail-yw0-f170.google.com with SMTP id r204so232489566ywb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Dec 2016 12:28:41 -0800 (PST)
MIME-Version: 1.0
From: Peter Becker <floyd.net@gmail.com>
Date: Fri, 30 Dec 2016 21:28:40 +0100
Message-ID: <CAEtw4r0-wgdQj4nO9HxCFvzXpRVhU=nqcKxRmDUsFVBuVrfong@mail.gmail.com>
Subject: [markfasheh/duperemove] Why blocksize is limit to 1MB?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, i have a 8 TB volume with multiple files with hundreds of GB each.
I try to dedupe this because the first hundred GB of many files are identical.
With 128KB blocksize with nofiemap and lookup-extends=no option, will
take more then a week (only dedupe, previously hashed). So i tryed -b
100M but this returned me an error: "Blocksize is bounded ...".

The reason is that the blocksize is limit to

#define MAX_BLOCKSIZE (1024U*1024)

But i can't found any description why.
