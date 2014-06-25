Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f175.google.com ([209.85.128.175]:51995 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660AbaFYNdz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 09:33:55 -0400
Received: by mail-ve0-f175.google.com with SMTP id jx11so1982218veb.34
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jun 2014 06:33:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140625074713.GE31096@carfax.org.uk>
References: <CACQTm-go5jGan9kP-dVq7Oi4b+AGWuFkb0Nudc2i9V1SG-oc3Q@mail.gmail.com>
	<20140625074713.GE31096@carfax.org.uk>
Date: Wed, 25 Jun 2014 15:33:54 +0200
Message-ID: <CAK5rZE6CdStsxW_HJ_m_8OL1nU0JcNBVQkohrCnYGq6ZeKVQoQ@mail.gmail.com>
Subject: Re: btrfs data dup on single device?
From: Imran Geriskovan <imran.geriskovan@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6/25/14, Hugo Mills <hugo@carfax.org.uk> wrote:
>> Storage is pretty cheap now, and to have multiple copies in btrfs is
>> something that I think could be used a lot. I know I will use multiple
>> copies of my data if made possible.

>    The question is, why? If you have enough disk media errors to make
> it worth using multiple copies, then your storage device is basically
> broken and needs replacing, and it can't really be relied on for very
> much longer.

Because btrfs single data profile can detect bitrot but can not recover
from it. Hardware Raid may be the solution. But you can not use it on
a laptop, or backup usb drive. However, you can still have 2 partitions
and mount them as Raid1.

Ofcourse we all have backups. But loss of certain files in a big file
set may have gone unnoticed if you do not scan though whole
backup log each time.

You will definetly lose some files unless you keep 5-10 years of
incremental backups. Even if you keep them they are too susceptible
to bitrots too.

Thus, there is definetely a need for ensured/enhanced data integrity.

Note that deduplication features of modern drives makes duplication
useless unless you used encrypted disk.

Regard, Imran
