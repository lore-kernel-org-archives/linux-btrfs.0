Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14811 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752071AbaHUJnP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Aug 2014 05:43:15 -0400
Message-ID: <1408614180.11298.0.camel@localhost.localdomain>
Subject: Re: [PATCH] btrfs-progs: init uninitialized output buf for
 btrfs-restore
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Marc Dietrich <marvin24@gmx.de>
CC: <linux-btrfs@vger.kernel.org>
Date: Thu, 21 Aug 2014 17:43:00 +0800
In-Reply-To: <2179924.d4q2ELedVV@fb07-iapwap2>
References: <1408592136-7606-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <2179924.d4q2ELedVV@fb07-iapwap2>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2014-08-21 at 10:14 +0200, Marc Dietrich wrote:
> Hi Gui,
> 
> Am Donnerstag, 21. August 2014, 11:35:36 schrieb Gui Hecheng:
> > A memory problem reported by valgrind as follows:
> > 	=== Syscall param pwrite64(buf) points to uninitialised byte(s)
> > When running:
> > 	# valgrind --leak-check=yes btrfs restore /dev/sda9 /mnt/backup
> > 
> > Because the output buf size is alloced with malloc, but the length of
> > output data is shorter than the sizeof(buf), so valgrind report
> > uninitialised byte(s).
> > We could use calloc to repalce malloc and clear this WARNING away.
> 
> yes, the warning vanished. But the reads from free'd memory make me more 
> worring...

Ah, yeah, I am looking into it, hope that I can do some help :)

> Marc


