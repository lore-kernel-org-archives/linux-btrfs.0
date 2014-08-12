Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26872 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbaHLC4v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 22:56:51 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s7C2uobH025598
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 02:56:50 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7C2unVj012388
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 02:56:49 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s7C2umxB013054
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 02:56:48 GMT
Date: Tue, 12 Aug 2014 10:56:42 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Blocked tasks on 3.15.1
Message-ID: <20140812025641.GA9244@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com>
 <53C7CD0F.7070603@fb.com>
 <CAPoQQ-1PcyPgJ4eoicP4xM8RShA2qo77fM7kqU5eKKUM2cmuUQ@mail.gmail.com>
 <1745216.hDa4tC2HJJ@merkaba>
 <53CE7ACF.7070109@fb.com>
 <20140812025521.GA6730@pyropus.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140812025521.GA6730@pyropus.ca>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 11, 2014 at 08:55:21PM -0600, Charles Cazabon wrote:
> The blocked tasks issue that got significantly worse in 3.15 -- did anything
> go into 3.16 related to this?  I didn't see a single "btrfs" in Linus' 3.16
> announcement, so I don't know whether it should be better, the same, or worse
> in this respect...
> 
> I haven't seen a definite statement about this on this list, either.
> 
> Can someone more familiar with the state of development comment on this?

Good news is that we've figured out the bug and the patch is already under
testing :-) 

thanks,
-liubo
