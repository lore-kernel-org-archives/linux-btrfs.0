Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641AbcEDR7B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 May 2016 13:59:01 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Mike Christie <mchristi@redhat.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        konrad.wilk@oracle.com, drbd-dev@lists.linbit.com,
        philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
        linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org,
        target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 00/42] v7: separate operations from flags in the bio/request structs
References: <1460747777-8479-1-git-send-email-mchristi@redhat.com>
	<x49d1p2c1nx.fsf@segfault.boston.devel.redhat.com>
	<572A36BF.3070208@redhat.com>
Date: Wed, 04 May 2016 13:58:57 -0400
In-Reply-To: <572A36BF.3070208@redhat.com> (Mike Christie's message of "Wed, 4
	May 2016 12:51:59 -0500")
Message-ID: <x49a8k5aen2.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mike Christie <mchristi@redhat.com> writes:

> On 05/03/2016 03:44 PM, Jeff Moyer wrote:
>> Hi, Mike,
>> 
>> That git tree doesn't seem to exist.  I did manage to apply your patch
>> set on top of next-20160415, though.
>> 
>> So... what testing did you do? ;-) I ran into the following problems
>
> I normally run xfstests and run it on my daily workstation and laptop. I
> did not do this for every FS this time and hit a regression.
>
> What FS were you using?

I'm using xfs, scsi disk, no blk-mq, no dm.

>> - git clone fails
>> - yum segfaults
>
> In v7/v6, I missed a new submit_bio call, so I hit issues like the two
> above. I have this fixed in the next version.

OK, does this mean you're posting another version, or you already did
and I somehow missed it?

>> - many blktrace/blkparse issues, including incorrect cpu recorded in
>>   traces, null task names, and blkparse outputting nothing for a trace
>>   file several gigabytes in size.
>
> I will double check for these issues.

Thanks.  I'll stop digging for now, then.

Cheers,
Jeff
