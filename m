Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:35924 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab2LRXCN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 18:02:13 -0500
Message-ID: <50D0F5E0.2010701@csamuel.org>
Date: Wed, 19 Dec 2012 10:01:52 +1100
From: Chris Samuel <chris@csamuel.org>
MIME-Version: 1.0
To: Wade Cline <clinew@linux.vnet.ibm.com>
CC: miaox@cn.fujitsu.com, bo.li.liu@oracle.com, linux-btrfs@vger.kernel.org,
        cmm@linux.vnet.ibm.com
Subject: Re: [PATCH] [RFC v2] Btrfs: Subpagesize blocksize (WIP).
References: <1355814805-13935-1-git-send-email-clinew@linux.vnet.ibm.com> <20121218073050.GA19332@liubo.cn.oracle.com> <50D02E0A.8080505@cn.fujitsu.com> <50D0EDAA.3090202@linux.vnet.ibm.com>
In-Reply-To: <50D0EDAA.3090202@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19/12/12 09:26, Wade Cline wrote:

> Yeah. Basically, if we create a btrfs filesystem with a 4k blocksize
> then that filesystem is incompatible with architectures such as PowerPC
> and MIPS which have a page size larger than 4k.

What happens currently?    Does the btrfs code detect the mismatch and
refuse to mount, or does it all go horribly wrong?

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
