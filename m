Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38504 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933768Ab2JXBT6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 21:19:58 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so845850pbb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2012 18:19:58 -0700 (PDT)
Message-ID: <50873AE3.4020700@gmail.com>
Date: Wed, 24 Oct 2012 08:48:35 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: Alex Lyakas <alex@zadarastorage.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Questions about mkfs -A option
References: <507E57F6.6000805@gmail.com> <CAOcd+r1aPGGh4zHYzeMMuE01j4Nr+aiMmHBCAWqqCXvZZTb2XQ@mail.gmail.com>
In-Reply-To: <CAOcd+r1aPGGh4zHYzeMMuE01j4Nr+aiMmHBCAWqqCXvZZTb2XQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012年10月23日 01:49, Alex Lyakas wrote:

> Wang,
> I would say that zeroing is done to prevent from seeing some other superblock (besides btrfs) there.


That make sense.

> 
> Alex.
> 
> 


But I still confused by the -A option?

In mkfs, we always write the sb info into BTRFS_SUPER_INFO_OFFSET.
>From the -A comment, I think btrfs would be places after the -A value.
What would happen if we specify a -A value larger than it?


Thanks,
Sheng-Hui
