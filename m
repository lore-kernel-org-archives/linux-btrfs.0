Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f180.google.com ([209.85.128.180]:62246 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab3LJXdR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Dec 2013 18:33:17 -0500
Received: by mail-ve0-f180.google.com with SMTP id jz11so5485026veb.11
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Dec 2013 15:33:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <01BDC0F3-CD4E-4BF1-898C-92AD50B66B41@colorremedies.com>
References: <CAK5rZE5KokaDhqCCzpAPipqYbf--qr5s2DLQgULtQVr3wMcOrQ@mail.gmail.com>
	<01BDC0F3-CD4E-4BF1-898C-92AD50B66B41@colorremedies.com>
Date: Wed, 11 Dec 2013 01:33:16 +0200
Message-ID: <CAK5rZE7bdfhD0FOe04+YoDRBfFWOy0rNfeamgDtP-=hv=SLFrw@mail.gmail.com>
Subject: Re: Feature Req: "mkfs.btrfs -d dup" option on single device
From: Imran Geriskovan <imran.geriskovan@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> Currently, if you want to protect your data against bit-rot on
>> a single device you must have 2 btrfs partitions and mount
>> them as Raid1.

> No this also works:
> mkfs.btrfs -d dup -m dup -M <device>

Thanks a lot.

I guess docs need an update:

https://btrfs.wiki.kernel.org/index.php/Mkfs.btrfs:
"-d": Data profile, values like metadata. EXCEPT DUP CANNOT BE USED

man mkfs.btrfs (btrfs-tools 0.19+20130705)
-d, --data type
              Specify  how  the data must be spanned across
              the devices specified. Valid values are raid0, raid1,
              raid5,  raid6,  raid10  or single.

Imran
