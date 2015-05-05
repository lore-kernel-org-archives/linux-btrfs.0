Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:33812 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbbEEGwR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 May 2015 02:52:17 -0400
Received: by oiko83 with SMTP id o83so132858913oik.1
        for <linux-btrfs@vger.kernel.org>; Mon, 04 May 2015 23:52:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <mi8op3$ri6$1@ger.gmane.org>
References: <mi8452$i00$1@ger.gmane.org>
	<5547E3BF.4090901@inwind.it>
	<mi8op3$ri6$1@ger.gmane.org>
Date: Tue, 5 May 2015 00:52:16 -0600
Message-ID: <CAJCQCtRy+RppYv5AnVb1BACWmud_yTN8qsRY2MHBKZv2K37Ykw@mail.gmail.com>
Subject: Re: [REQ] Help to gain access to btrfsraid6 pool that won't mount
From: Chris Murphy <lists@colorremedies.com>
To: TheJay <obiwantje@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 4, 2015 at 3:36 PM, TheJay <obiwantje@gmail.com> wrote:

> [Mon May  4 14:33:17 2015] BTRFS: bdev (null) errs: wr 3, rd 28773, flush 2, corrupt 0, gen 0

So there might be more than one thing going wrong and they're
colliding to make a worse problem. You've got three write and 2 flush
errors, and many thousands of read errors (probably due to missing
devices).

It might be worth trying -o degraded,recovery because recovery can't
work with devices missing, and degraded alone won't run the recovery
code.


-- 
Chris Murphy
