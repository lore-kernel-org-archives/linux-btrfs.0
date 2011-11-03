From: WuBo <wu.bo@cn.fujitsu.com>
Subject: Re: [PATCH 1/3] xfstests 264: add a copy and reserve test
Date: Thu, 03 Nov 2011 16:04:43 +0800
Message-ID: <4EB24B1B.2030304@cn.fujitsu.com>
References: <4EB20505.7070005@cn.fujitsu.com> <4EB205C7.6010906@cn.fujitsu.com> <20111103065525.GA6800@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org,
	Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20111103065525.GA6800@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/03/2011 02:55 PM, Christoph Hellwig wrote:
> On Thu, Nov 03, 2011 at 11:08:55AM +0800, WuBo wrote:
>> This test is a stress test. It creates a set of threads for coping small files 
>> into disk. I use a 2G disk for test, the ENOSPC arises usually but the disk is 
>> not full under kenerl 3.0 with intel64.
> 
> It seems like you really want to use _scratch_mkfs_sized instead of the
> btrfs-specific resize option and make the test generic.  Also we already
OK, thanks for _scratch_mkfs_sized, It's will make these tests generic.

> have used up these test numbers in the xfstests-dev repository, and I
> will commit another batch of tests today.
I will change my test numbers in next version.

thanks,
wubo

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
