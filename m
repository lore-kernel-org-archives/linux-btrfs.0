Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36512 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbcGWU2T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jul 2016 16:28:19 -0400
Received: by mail-oi0-f41.google.com with SMTP id w18so206234242oiw.3
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jul 2016 13:28:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQYicoze=jBf9ptQABLZSxgd67MYUbCs2igB2PipugxaA@mail.gmail.com>
References: <CAJCQCtQOV4gsh-Kaz6n=d9KBYCyOh9eb65-G8KBd8B_HJ_tNBg@mail.gmail.com>
 <CAJCQCtQYicoze=jBf9ptQABLZSxgd67MYUbCs2igB2PipugxaA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 23 Jul 2016 14:28:18 -0600
Message-ID: <CAJCQCtSy4teqx-d4iWDWRE=uP7R+0u4J2G07fwCspJipphwkqg@mail.gmail.com>
Subject: Re: qcow2 becomes 37P in size while qemu crashes
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kindof a rudimentary way of making a debug tree smaller, by filtering
by inode...

[root@f24m images]# btrfs-debug-tree -t 583 /dev/sda5 | grep -A 50 -B
50 994163 > inode994163_39PBfile.txt

381K gzip file
https://drive.google.com/open?id=0B_2Asp8DGjJ9Rk1qMG54MUNDWkE

But I'm going to rm this file so I can see if the problem is reproducible.

---

Chris Murphy
