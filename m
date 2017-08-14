Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:50050 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751529AbdHNHVm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 03:21:42 -0400
Subject: Re: Building a BTRFS test machine
To: Cerem Cem ASLAN <ceremcem@ceremcem.net>, linux-btrfs@vger.kernel.org
References: <CAN4oSBdO8GfBQA1CrLVa1atA+QJquCy63KBqOHhh49Uz=1sgjQ@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <22521430-e019-7ebe-4553-02a344733e52@gmx.com>
Date: Mon, 14 Aug 2017 15:21:35 +0800
MIME-Version: 1.0
In-Reply-To: <CAN4oSBdO8GfBQA1CrLVa1atA+QJquCy63KBqOHhh49Uz=1sgjQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年08月14日 09:01, Cerem Cem ASLAN wrote:
> Would that be useful to build a BTRFS test machine, which will perform
> both software tests (btrfs send | btrfs receive, read/write random
> data etc.) and hardware tests, such as abrupt power off test, abruptly
> removing a raid-X disk physically, etc.

If you want to contribute to btrfs development/bug report, then it's 
definitely helpful.

> 
> If it would be useful, what tests should it cover?

At least fstests (old xfstests, and some tests are known to fail, so you 
need some knowledge to judge which failure is real problem), selftest 
from btrfs-progs, and fs related tests from Linux Test Project.

The hard part to integrate all these different tests and make them 
automatic.

I'm not familiar with hardware crash test, but it would definitely help, 
as currently we're only using dm-flakey to *emulate* power loss, still 
not true power off.

Other test like performance test from variant other projects like 
postgresql/apache will also help.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
