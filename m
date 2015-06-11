Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34686 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933310AbbFKNtZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jun 2015 09:49:25 -0400
Message-ID: <557991D6.8090501@fb.com>
Date: Thu, 11 Jun 2015 09:49:10 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <bo.li.liu@oracle.com>, Julia Lawall <julia.lawall@lip6.fr>
CC: kbuild test robot <fengguang.wu@intel.com>, <kbuild@01.org>,
        David Sterba <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [btrfs:integration-4.2 29/57] fs/btrfs/disk-io.c:2325:17-30:
 ERROR: reference preceded by free on line 2324
References: <201506110750.oOHGNTQE%fengguang.wu@intel.com> <alpine.DEB.2.02.1506110800020.2014@localhost6.localdomain6> <20150611062319.GA9634@localhost.localdomain>
In-Reply-To: <20150611062319.GA9634@localhost.localdomain>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/11/2015 02:23 AM, Liu Bo wrote:
> On Thu, Jun 11, 2015 at 08:07:09AM +0200, Julia Lawall wrote:
>> This does not look correct.  Please check.
> 
> Oops, thanks for pointing it out.
> 
> Sorry for my miss, here is the fix.
> 
> (Chris, if you prefer me to fold this into the original patch, I'll do
> it.)
> 
> Thanks,
> 
> -liubo
> 

Thanks Julia! Liu, lets leave it as an incremental so we can give Julia
the reported-by.

-chris

