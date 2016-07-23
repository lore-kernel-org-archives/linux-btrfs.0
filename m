Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:33775 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbcGWUFD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jul 2016 16:05:03 -0400
Received: by mail-oi0-f41.google.com with SMTP id j185so205768955oih.0
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jul 2016 13:05:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQOV4gsh-Kaz6n=d9KBYCyOh9eb65-G8KBd8B_HJ_tNBg@mail.gmail.com>
References: <CAJCQCtQOV4gsh-Kaz6n=d9KBYCyOh9eb65-G8KBd8B_HJ_tNBg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 23 Jul 2016 14:05:01 -0600
Message-ID: <CAJCQCtQYicoze=jBf9ptQABLZSxgd67MYUbCs2igB2PipugxaA@mail.gmail.com>
Subject: Re: qcow2 becomes 37P in size while qemu crashes
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Using btrfs-debug-tree, I'm finding something a bit odd about some of
the items in this 39P file.

Seems normal

    item 71 key (994163 EXTENT_DATA 43689967616) itemoff 12467 itemsize 53
        extent data disk byte 617349906432 nr 80805888
        extent data offset 0 nr 80805888 ram 80805888
        extent compression(none)

Seems not normal

    item 58 key (994163 EXTENT_DATA 38345535488) itemoff 13156 itemsize 53
        extent data disk byte 0 nr 0
        extent data offset 394752000 nr 61440 ram 34626881742770176
        extent compression(none)

There are quite a large number of items that take the 2nd form, and in
each case the ram value is the same as above.


-- 
Chris Murphy
