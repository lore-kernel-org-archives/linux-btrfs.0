Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17504 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbbG2XBm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jul 2015 19:01:42 -0400
Message-ID: <55B95B4C.6090007@oracle.com>
Date: Thu, 30 Jul 2015 07:01:32 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Anatol Pomozov <anatol.pomozov@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: fs got readonly after "btrfs_run_delayed_refs:2783: errno=-5
 IO failure"
References: <CAOMFOmU3rPtY-VNzXHcYzrVjzwTGNO1qgiWns5=QOgN2O3MvuA@mail.gmail.com>
In-Reply-To: <CAOMFOmU3rPtY-VNzXHcYzrVjzwTGNO1qgiWns5=QOgN2O3MvuA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi,

> I see a lot of checksum errors, but as I use RAID most of these error
> got fixed, I started scrub operation to find/fix all the problems but
> the scrub operation got cancelled at the very beginning. I see
> following error in kernel logs, it says "(device sdb):
> run_one_delayed_ref returned -5" and after that "(device sdb): forced
> readonly".

   are you using mount -o degrade option ? if not could you please try ?

Thanks, Anand
