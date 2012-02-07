From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH 3/3] xfstests: add btrfs online defragments QA test
Date: Tue, 07 Feb 2012 09:21:24 +0800
Message-ID: <4F307C94.2020004@cn.fujitsu.com>
References: <1328516869-19474-1-git-send-email-liubo2009@cn.fujitsu.com> <1328516869-19474-3-git-send-email-liubo2009@cn.fujitsu.com> <20120206121155.GA16044@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120206121155.GA16044@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/06/2012 08:11 PM, Christoph Hellwig wrote:
> On Mon, Feb 06, 2012 at 04:27:49PM +0800, Liu Bo wrote:
>> +_runtest()
>> +{
>> +	$progs_dir/runtest.sh $defrag_args $SCRATCH_MNT $SCRATCH_DEV
> 
> please put the actual tests into test cases themselves instead of
> calling out into shell scripts under src.  If you have common code
> shared between multiple tests please put them into common.defrag.
> 

I see, will update it.

>> +
>> +# get standard environment, filters and checks
>> +. ./common.rc
>> +. ./common.filter
>> +. ./common.defrag
>> +
>> +# real QA test starts here
>> +_supported_fs xfs btrfs
> 
> does it really support xfs?
> 

sorry, my miss.

Thanks for reviewing!

thanks,
liubo

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

