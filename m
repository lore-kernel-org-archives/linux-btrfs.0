Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f178.google.com ([209.85.128.178]:37938 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaA2Wi6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 17:38:58 -0500
Received: by mail-ve0-f178.google.com with SMTP id oy12so1708642veb.9
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 14:38:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52E96BF8.3000601@fb.com>
References: <52E430F7.7030801@gmail.com>
	<52E96BF8.3000601@fb.com>
Date: Thu, 30 Jan 2014 00:38:56 +0200
Message-ID: <CAK5rZE6THupbp08FJaF1P2XFtDnWTX339-uFwPDqMd=Nm6+L9A@mail.gmail.com>
Subject: Re: Rapid memory exhaustion during normal operation
From: Imran Geriskovan <imran.geriskovan@gmail.com>
To: BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> I'm trying to track this down - this started happening without changing
>> the kernel in use, so probably
>> a corrupted filesystem. The symptoms are that all memory is suddenly used
>> by no apparent source.  OOM
>> killer is invoked on every task, still can't free up enough memory to
>> continue.

I don't know if it is related or not, but my experience (Kernel
3.12.8) is as follows:

If a process traverses a directory tree of millions of subdirectories and files,
memory consumption increases by Gigabytes and the memory is NEVER freed.

The traversal includes no reads, no writes but just getting the directory
contents. However a second run for the same dirs does NOT increase
memory usage.

Interestingly process list gives no clues about what consumed that much
memory.

Regards,
Imran
