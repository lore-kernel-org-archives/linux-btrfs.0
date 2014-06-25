Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21208 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752423AbaFYBZS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 21:25:18 -0400
Message-ID: <1403659201.22912.2.camel@localhost.localdomain>
Subject: Re: Assertion `!(exist->nmirrors >= 2)' failed
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Karl-Philipp Richter <krichter722@aol.de>
CC: <linux-btrfs@vger.kernel.org>
Date: Wed, 25 Jun 2014 09:20:01 +0800
In-Reply-To: <53A9809C.30705@aol.de>
References: <53A9809C.30705@aol.de>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2014-06-24 at 15:43 +0200, Karl-Philipp Richter wrote:
> Hi together,
> I wondered whether
> 
>     $ sudo btrfs rescue chunk-recover -y /dev/loop2p1
>     btrfs: chunk-recover.c:124: process_extent_buffer: Assertion
> `!(exist->nmirrors >= 2)' failed.
>     $ echo $?
>     134

Hi, Karl
For the Assertion above, this one below may do a help.
https://patchwork.kernel.org/patch/4339091/

-Gui

> is an error in btrfs or an error message of (the correctly working)
> btrfs. Any ideas what this could mean? I'm having this trouble with a
> system which is so messed up that I even can't restore
> 
>     $ sudo btrfs restore /dev/loop2p1 /mnt/data_extension/restore
>     parent transid verify failed on 1068982272 wanted 47618 found 47575
>     parent transid verify failed on 1068982272 wanted 47618 found 47575
>     parent transid verify failed on 1068982272 wanted 47618 found 47575
>     parent transid verify failed on 1068982272 wanted 47618 found 47575
>     Ignoring transid failure
>     leaf parent key incorrect 1068982272
>     Couldn't setup extent tree
>     parent transid verify failed on 1068982272 wanted 47618 found 47575
>     Ignoring transid failure
>     leaf parent key incorrect 1068982272
>     Couldn't read fs root: -1
> 
> I'm issueing the command because it seems to be the last thing I can do
> to rescue any data of that partition.
> 
> This occurs with v3.12 (output of `btrfs --version`) as well as the
> latest commit 24cf4d8c3ee924b474f68514e0167cc2e602a48d of btrfs-progs.
> 
> Best regards,
> Kalle Richter
> 


