Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:49532 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab2LRXTe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 18:19:34 -0500
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <clinew@linux.vnet.ibm.com>;
	Tue, 18 Dec 2012 16:19:33 -0700
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id C8F7C1FF0050
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Dec 2012 16:19:17 -0700 (MST)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id qBINJJXH280672
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Dec 2012 16:19:22 -0700
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id qBINJIkl008087
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Dec 2012 16:19:19 -0700
Message-ID: <50D0F9F1.6070209@linux.vnet.ibm.com>
Date: Tue, 18 Dec 2012 15:19:13 -0800
From: Wade Cline <clinew@linux.vnet.ibm.com>
MIME-Version: 1.0
To: Chris Samuel <chris@csamuel.org>
CC: miaox@cn.fujitsu.com, bo.li.liu@oracle.com, linux-btrfs@vger.kernel.org,
        cmm@linux.vnet.ibm.com
Subject: Re: [PATCH] [RFC v2] Btrfs: Subpagesize blocksize (WIP).
References: <1355814805-13935-1-git-send-email-clinew@linux.vnet.ibm.com> <20121218073050.GA19332@liubo.cn.oracle.com> <50D02E0A.8080505@cn.fujitsu.com> <50D0EDAA.3090202@linux.vnet.ibm.com> <50D0F5E0.2010701@csamuel.org>
In-Reply-To: <50D0F5E0.2010701@csamuel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/18/2012 03:01 PM, Chris Samuel wrote:

> On 19/12/12 09:26, Wade Cline wrote:
>
>> Yeah. Basically, if we create a btrfs filesystem with a 4k blocksize
>> then that filesystem is incompatible with architectures such as PowerPC
>> and MIPS which have a page size larger than 4k.
> What happens currently?    Does the btrfs code detect the mismatch and
> refuse to mount, or does it all go horribly wrong?
>
> cheers,
> Chris
I recall hacking the mkfs.btrfs tool, testing it, and finding that the
filesystem wouldn't mount. I haven't created a non-hacked filesystem
on x86 and ported it to PPC verbatim yet, but the same should happen
there; it shouldn't crash the kernel.

-Wade

