Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:39116 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750707Ab3LJWla convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Dec 2013 17:41:30 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Feature Req: "mkfs.btrfs -d dup" option on single device
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAK5rZE5KokaDhqCCzpAPipqYbf--qr5s2DLQgULtQVr3wMcOrQ@mail.gmail.com>
Date: Tue, 10 Dec 2013 15:41:25 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <01BDC0F3-CD4E-4BF1-898C-92AD50B66B41@colorremedies.com>
References: <CAK5rZE5KokaDhqCCzpAPipqYbf--qr5s2DLQgULtQVr3wMcOrQ@mail.gmail.com>
To: Imran Geriskovan <imran.geriskovan@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 10, 2013, at 1:31 PM, Imran Geriskovan <imran.geriskovan@gmail.com> wrote:

> Currently, if you want to protect your data against bit-rot on
> a single device you must have 2 btrfs partitions and mount
> them as Raid1.

No this also works:

mkfs.btrfs -d dup -m dup -M <device>


Chris Murphy

