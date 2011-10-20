From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH 3/3] 266: Functional test case for the btrfs raid operations
Date: Thu, 20 Oct 2011 23:32:47 +0800
Message-ID: <4EA03F1F.4050109@oracle.com>
References: <20111013005652.GM3159@dastard> <1318919336-32206-1-git-send-email-Anand.Jain@oracle.com> <1318919336-32206-4-git-send-email-Anand.Jain@oracle.com> <20111019094527.GD3083@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com, david@fromorbit.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111019094527.GD3083@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>


On 19/10/2011 17:45, Christoph Hellwig wrote:
>> +    if [ $dev_removed == 1 ]; then
>> +	umount $SCRATCH_MNT
>> +        _devmgt_add "${DEVHTL}"
>> +    fi
> 
> messy indendation.

  got it. thanks.

>> +	btrfs filesystem balance $SCRATCH_MNT || _fail "balance failed"
>> +	#btrfs filesystem show $SCRATCH_DEV 2>&1 | egrep devid |awk '{
>> +	#	if ( $6 == "0.00" ) { exit 1 }
>> +	#}' || _fail "test6_add... failed"
> 
> what is the point of the commented out code?
> 
> otherwise looks good to me.

  yes that has to be removed.
