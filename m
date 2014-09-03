Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39411 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935108AbaICXud (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Sep 2014 19:50:33 -0400
Message-ID: <5407A942.2030701@fb.com>
Date: Wed, 3 Sep 2014 19:50:26 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: =?UTF-8?B?SG9sZ2VyIEhvZmZzdMOkdHRl?=
	<holger.hoffstaette@googlemail.com>,
        <linux-btrfs@vger.kernel.org>
CC: <stable@vger.kernel.org>
Subject: Re: Btrfs stable updates for v3.16
References: <54077F27.1040603@fb.com> <pan.2014.09.03.23.36.00@googlemail.com>
In-Reply-To: <pan.2014.09.03.23.36.00@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/03/2014 07:36 PM, Holger Hoffstätte wrote:
> On Wed, 03 Sep 2014 16:50:47 -0400, Chris Mason wrote:
> 
>> Hi everyone,
>>
>> For 3.16, please pull these into stable, I've cherry picked and tested
>> them here.  For 3.15 and earlier there are a few conflicts, so I'll make
>> a git tree with things to pull.
>>
>> 8d875f95da43c6a8f18f77869f2ef26e9594fecc v3.15+
> 
> This ("fix filemap_flush call in btrfs_file_release") is the only one 
> that requires some work for 3.14.
> 
> There is one conflict in ordered.data.c - just a sligh work queue 
> submission change - and the second in transaction.c where the patch does 
> not delete enough from btrfs_flush_all_pending_stuffs(), since 3.14 still 
> has the old qgroup calls in place. I removed it wholesale and that makes 
> everything fit.
> 
> The followup ("fix filemap_flush call in btrfs_file_release") then also 
> applies.
> 
> Should they also go into the next 3.14.x stable cycle? This rename 
> deadlock sounds like a possible problem with rsync, which seems like a 
> popular use case, and I guess nobody will complain about slightly better 
> performance either.

Right, the btrfs_flush_all_pending_stuffs function can just be deleted.
 But, Liu Bo's patch isn't required on 3.14 (since the regression he
fixed came with 3.15).

And these changes are big enough that I like to test them a little here
before sending out.  I did mark that patch as 3.15+, but really that
deadlock has been there forever.  We only started seeing it with 3.15+
because other waitqueue problems made it stand out.

-chris
