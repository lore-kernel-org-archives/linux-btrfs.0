Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab3B0XLJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 18:11:09 -0500
Message-ID: <512E9285.30005@redhat.com>
Date: Wed, 27 Feb 2013 17:11:01 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Wang Sheng-Hui <shhuiw@gmail.com>, xfstests <xfs@oss.sgi.com>,
        linux-btrfs@vger.kernel.org, list.btrfs@jan-o-sch.net
Subject: Re: [PATCH] xfstests 276: fix error 'FIBMAP: Invalid argument'
References: <512DB284.1090806@gmail.com> <20130227230443.GB5551@dastard>
In-Reply-To: <20130227230443.GB5551@dastard>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/27/13 5:04 PM, Dave Chinner wrote:
> On Wed, Feb 27, 2013 at 03:15:16PM +0800, Wang Sheng-Hui wrote:
>> Btrfs doesn't support FIEMAP_FLAG_XATTR, which is enabled by
>> -x option of filefrag, and will fail with
>> 	'FIBMAP: Invalid argument'
>> for 'filefrag -vx'. 'filefrag -vx' fails on btrfs with
>>     'FIEMAP failed with unsupported flags 2'
>> Remove the '-x' option.
>>
>> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> 
> I can see that this changes what gets dumped into the $seq.full
> file, but it seems to me that also changes the extent list returned
> to the checking functions. So either the test previously worked and
> now it fails with this change, or the test never worked and now it
> does, or perhaps something else?

Agreed - I wondered as well.

> IOWs, I can't tell why you want to change this from the patch
> description, hence I don't know if the original behaviour was
> intentional or not.  Can you say describe what the overall effect of
> the change is in the commit description?

It looks like -x is only recently rejected:

commit 05dadc09f52ad5a631da1aa8767c5b80e121f0c4
Author: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date:   Thu Nov 29 05:08:26 2012 +0000

    Btrfs: add fiemap's flag check

+#define BTRFS_FIEMAP_FLAGS     (FIEMAP_FLAG_SYNC)

+       ret = fiemap_check_flags(fieinfo, BTRFS_FIEMAP_FLAGS);

-Eric

> Cheers,
> 
> Dave.
> 

