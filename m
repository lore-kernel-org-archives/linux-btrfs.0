Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:53181 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3K3KJy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Nov 2013 05:09:54 -0500
Received: by mail-wi0-f181.google.com with SMTP id hq4so2921025wib.14
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Nov 2013 02:09:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ce5ama-6he.ln1@hurikhan77.spdns.de>
References: <CAK-xaQbp8Yfgpu-Tx5CV2yhACxku6_8Zv0cXFCudyFKqoq0D=w@mail.gmail.com>
 <ce5ama-6he.ln1@hurikhan77.spdns.de>
From: Andrea Gelmini <andrea.gelmini@gmail.com>
Date: Sat, 30 Nov 2013 11:09:33 +0100
Message-ID: <CAK-xaQa0fqRh39oTRuL4y4sEgQBOsvUPia6ZGDk6r7UnbQy=mg@mail.gmail.com>
Subject: Re: Clean crash...
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2013/11/24 Kai Krakow <hurikhan77+btrfs@gmail.com>:
> Did you try to mount in recovery mode? This may, however, mount an older
> version of your superblock which does not refer to your latest additions of
> files on the disk but it may be newer than what you got in your backup.

Hi Kai,
   and thanks a lot for your deep reply.
   Actually with "-o recovery" I can access to a lot of files.

Thanks again,
Andrea
