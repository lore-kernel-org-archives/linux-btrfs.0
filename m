Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8957 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750869AbaHOART (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 20:17:19 -0400
Message-ID: <53ED517E.9010600@fb.com>
Date: Thu, 14 Aug 2014 20:17:02 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: Austin S Hemmelgarn <ahferroin7@gmail.com>, <linux-btrfs@vger.kernel.org>,
        <jbacik@fb.com>, <takeuchi_satoru@jp.fujitsu.com>
Subject: Re: btrfs-zero-log fails, can't mount FS
References: <20140814160902.GA25370@merlins.org> <53ECE953.70009@gmail.com> <20140814172743.GC27531@merlins.org> <53ED321D.1040702@fb.com> <20140814222818.GL27531@merlins.org>
In-Reply-To: <20140814222818.GL27531@merlins.org>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/14/2014 06:28 PM, Marc MERLIN wrote:
> On Thu, Aug 14, 2014 at 06:03:09PM -0400, Chris Mason wrote:
>> At least I'll get to buy you a beer this time.
>  
> Haha, no worries :)
> 
>> Lets just see if the log root is the only problem.  This will get you
>> through btrfs-zero-log
> 
> It sure did, thanks much for the patch.
> It output absolutely nothing instead of the wanted got lines it usually
> spits out, and the filesystem mounted without problems.
> 
> I'll add this better btrfs-zero-log in my initrd for next time.
> 
> Would it be ok to modify btrfs-zero-log to simply remove the return -EIO
> line?
> 
> Does it really matter whether it can setup the log root tree when it's being
> asked to nuke the log?

Yes, btrfs-zero log doesn't need that root to be read.  I'll fix it up,
really glad it worked for you.

-chris
