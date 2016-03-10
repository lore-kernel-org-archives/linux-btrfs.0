Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:41185 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbcCJGHT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Mar 2016 01:07:19 -0500
Received: from localhost
	by e23smtp05.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <xufeifei@linux.vnet.ibm.com>;
	Thu, 10 Mar 2016 16:07:14 +1000
Received: from d23relay10.au.ibm.com (d23relay10.au.ibm.com [9.190.26.77])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id C3CBA2CE8054
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Mar 2016 17:07:11 +1100 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u2A672N447382708
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Mar 2016 17:07:11 +1100
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u2A66cS8020640
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Mar 2016 17:06:38 +1100
Subject: Re: [PATCH] btrfs-progs: Replace hardcoded PAGE_CACHE_SIZE with
 getpagesize().
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, chandan@linux.vnet.ibm.com
References: <1457526133-28575-1-git-send-email-xufeifei@linux.vnet.ibm.com>
 <20160309124524.GB738@twin.jikos.cz>
From: Fiona <xufeifei@linux.vnet.ibm.com>
Message-ID: <56E10EE3.80803@linux.vnet.ibm.com>
Date: Thu, 10 Mar 2016 14:06:27 +0800
MIME-Version: 1.0
In-Reply-To: <20160309124524.GB738@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2016/3/9 20:45, David Sterba wrote:
> On Wed, Mar 09, 2016 at 08:22:13PM +0800, Feifei Xu wrote:
>> PAGE_CACHE_SIZE is hardcoded to 4K in cmds-restore.c. It makes lzo
>> decompress fail on ppc64. Fix this through replacing hardcoded 4K
>> with getpagesize().
> You're right that the hardcoded value is a bug, but the correct value is
> the sector size. Ie. when the system is 4k page size and filesystem is
> eg. from ppc64.
Hi David,

You're right, I am working to fix it.

Thanks
Fiona

