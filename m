Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:56912 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966367AbbDWROY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 13:14:24 -0400
Received: from /spool/local
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Fri, 24 Apr 2015 03:14:22 +1000
Received: from d23relay09.au.ibm.com (d23relay09.au.ibm.com [9.185.63.181])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 3B0522CE804E
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2015 03:14:20 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t3NHEBDe36831440
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2015 03:14:20 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t3NHDknB028625
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2015 03:13:46 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: xuw2015@gmail.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fix btrfs quota rescan failed on PPC64 arch
Date: Thu, 23 Apr 2015 22:43:29 +0530
Message-ID: <4064896.UsZQ5YB6B2@localhost.localdomain>
In-Reply-To: <1429507996-28224-1-git-send-email-xuw2015@gmail.com>
References: <1429507996-28224-1-git-send-email-xuw2015@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 20 Apr 2015 13:33:16 xuw2015@gmail.com wrote:
> From: George Wang <xuw2015@gmail.com>
> 
> PPC64 arch use such following IOC values "
> \#define _IOC_NONE       1U
> \#define _IOC_READ       2U
> \#define _IOC_WRITE      4U
> " comparing to the default IOC values "
> \#define _IOC_NONE       0U
> \#define _IOC_READ       2U
> \#define _IOC_WRITE      1U"
> 
> This means the value "_IOW*" will be negative when we store it in the int
> variables. Such as the "BTRFS_IOC_QGROUP_CREATE", it will be "0x4010942e" on
> X86_64, but "0x8010942e" on PPC64.
> Notice that the IOC values are the "unsigned long" type, so we use the
> "unsigned long" to store it, and this can insure the comparison between the
> variable and BTRFS_IOC_* valid.
> 
> Signed-off-by: George Wang <xuw2015@gmail.com>

Tested-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

-- 
chandan

