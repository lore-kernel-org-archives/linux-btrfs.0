Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3382 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753416AbbDGOp6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Apr 2015 10:45:58 -0400
Message-ID: <5523EDA0.9080504@fb.com>
Date: Tue, 7 Apr 2015 10:45:52 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <dm-devel@redhat.com>, <zab@redhat.com>, <fstests@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 1/3] dm: log writes target
References: <1426797070-27463-1-git-send-email-jbacik@fb.com> <1426797070-27463-2-git-send-email-jbacik@fb.com> <20150323180245.GE3172@redhat.com>
In-Reply-To: <20150323180245.GE3172@redhat.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/23/2015 02:02 PM, Vivek Goyal wrote:
> On Thu, Mar 19, 2015 at 04:31:08PM -0400, Josef Bacik wrote:
>
> [..]
>> + * We log writes only after they have been flushed, this makes the log describe
>> + * close to the order in which the data hits the actual disk, not its cache.  So
>> + * for example the following sequence (W means write, C means complete)
>> + *
>> + * Wa,Wb,Wc,Cc,Ca,FLUSH,FUAd,Cb,CFLUSH,CFUAd
>> + *
>> + * Would result in the log looking like this
>> + *
>> + * c,a,flush,fuad,b,<other writes>,<next flush>
>> + *
>
> A minor nit, Should this sequence be following.
>
> c,a,b, flush,fuad,<other writes>,<next flush>
>
> when flush completed by that time write of b has completed too. So it
> should be written first?
>

So we want to catch file systems behaving badly by not waiting for the 
IO they care about to complete before issuing their flush, so we take 
the super pessimistic view that only IO that has completed by FLUSH 
issue time can truly be safe.  For all we know the flush could have 
happened first and we just happen to get the endio called for b first 
instead of the flush, so to make it mostly likely that we catch fs bugs 
we enforce this idea that only completed IO can be sure to have been 
flushed at flush submit time.  Thanks,

Josef

