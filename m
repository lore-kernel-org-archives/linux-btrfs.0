Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:55938 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932350AbcERQ7l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 May 2016 12:59:41 -0400
Received: from localhost
	by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 19 May 2016 02:59:38 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id AC65A3578052
	for <linux-btrfs@vger.kernel.org>; Thu, 19 May 2016 02:59:36 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u4IGxSeZ65142882
	for <linux-btrfs@vger.kernel.org>; Thu, 19 May 2016 02:59:36 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u4IGx4UF010154
	for <linux-btrfs@vger.kernel.org>; Thu, 19 May 2016 02:59:04 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Steve Capper <steve.capper@linaro.org>
Cc: linux-btrfs@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: btrfs self tests fail on arm64, kernel 4.6
Date: Wed, 18 May 2016 22:28:45 +0530
Message-ID: <2111761.fDjS2Kou6B@localhost.localdomain>
In-Reply-To: <CAPvkgC0RavB6JrfVrnM0EZGxyy4r1vBCUNAtWKfguvBSBK-JOw@mail.gmail.com>
References: <CAPvkgC0RavB6JrfVrnM0EZGxyy4r1vBCUNAtWKfguvBSBK-JOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 18 May 2016 16:46:49 Steve Capper wrote:
> Hello,
> I am running into issues running the btrfs self tests from 4.6 on an
> arm64 system with PAGE_SIZE=64K.
> Poking around in recalculate_thresholds(), I got the following values:
> size = 1073741824
> ctl->unit = 4096
> bytes_per_bg = 2147483648
> max_bitmaps = 1
> 
> I am not sure where the problem is as I'm not familiar with btrfs.
> 
> A panic log can be found below.
> 
> Is this a known problem?
> 
> Are there any more diagnostics I could perform, that would be helpful?
> 

Hi Steve,

The fixes for selftests with respect to 64K block size will be posted soon. I
am currently testing the changes that have been made.

-- 
chandan

