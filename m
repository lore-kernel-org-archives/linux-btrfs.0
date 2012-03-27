From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: btrfs crash after disk reconnect
Date: Wed, 28 Mar 2012 01:26:04 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1203280125360.15111@frira.zrqbmnf.qr>
References: <alpine.LNX.2.01.1203231303520.2601@frira.zrqbmnf.qr> <4F6FC99F.3010209@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F6FC99F.3010209@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 2012-03-26 03:42, Liu Bo wrote:

>On 03/23/2012 08:07 PM, Jan Engelhardt wrote:
>> Observed on Linux 3.2.9 after the controller/disk flaked in-out.
>> (The world still needs a SCSI error decoding tool to tell normal people 
>> what cmd and res are about.)
>> 
>
>I'm not that sure if your 3.2.9-jng4-default build contains this commit or not:
>
>commit 8bedd51b6121c4607784d75f852828d25d119c52
>(Btrfs: Check for NULL page in extent_range_uptodate)

8bedd isn't in 3.2.9; thanks for the hint, I will try that one.
