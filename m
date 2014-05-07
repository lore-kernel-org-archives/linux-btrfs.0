Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17598 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbaEGCW7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 May 2014 22:22:59 -0400
Date: Wed, 7 May 2014 10:22:46 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Kenny MacDermid <kenny.macdermid@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs issues in 3.14
Message-ID: <20140507022245.GA15783@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAEVbaUdcCQCWhZ-ZdBr_Dkv-WaMbtBkQ0n8HRfc0p9F0xw1+0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAEVbaUdcCQCWhZ-ZdBr_Dkv-WaMbtBkQ0n8HRfc0p9F0xw1+0A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 06, 2014 at 08:49:04PM -0300, Kenny MacDermid wrote:
> Hello,
> 
> I've been having a number of issues with processes hanging due to
> btrfs using 3.14 kernels. This seems pretty new as it has been working
> fine before. I also rebuilt the filesystem and am still receiving
> hangs.
> 
> The filesystem is running on dmcrypt which is running on lvm2 which is
> running on an SSD (SAMSUNG MZMTD256HAGM-000L1).
> 
> When the issue occurs the process is unable to be killed and the
> system will not fully shutdown.
> 
> $ uname -a
> Linux orange 3.14.2-1-ARCH #1 SMP PREEMPT Sun Apr 27 11:28:44 CEST
> 2014 x86_64 GNU/Linux
> 
> $ btrfs --version
> Btrfs v3.14.1
> 
> $ btrfs fi show
> Btrfs v3.14.1
> 
> $ btrfs fi df /home
> Data, single: total=71.01GiB, used=68.72GiB
> System, DUP: total=8.00MiB, used=16.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, DUP: total=1.50GiB, used=863.33MiB
> Metadata, single: total=8.00MiB, used=0.00
> 
> I opened bugs 75181 and 75191 and I'll include the relevant journalctl
> entries. The kernel was upgraded from 3.14.1-1 to 3.14.2-1 during this
> time, and the filesystem was rebuilt after the orphan issue.
> 
> I'm not on this list so please CC me on replies.

What does sysrq+w say when the hang happens?

-liubo
