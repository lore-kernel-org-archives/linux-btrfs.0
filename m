From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs: fix return value check of	btrfs_start_transaction()
Date: Fri, 21 Jan 2011 09:59:39 +0800
Message-ID: <4D38E88B.7030100@cn.fujitsu.com>
References: <201101200619.AA00004@T-ITOH1.jp.fujitsu.com> <20110120160959.GB6609@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Tsutomu Itoh <t-itoh@jp.fujitsu.com>, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110120160959.GB6609@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/21/2011 12:09 AM, Josef Bacik wrote:
> On Thu, Jan 20, 2011 at 03:19:37PM +0900, Tsutomu Itoh wrote:
>> The error check of btrfs_start_transaction() is added, and the mistake
>> of the error check on several places is corrected. 
>>
> 
> I'd rather we go through and have these things return an error than do a
> BUG_ON().  We're moving towards a more stable BTRFS, not one that panics more
> often :).  Thanks,

Great, seems that we all feel it is the time to focus on this. :)

> 
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

