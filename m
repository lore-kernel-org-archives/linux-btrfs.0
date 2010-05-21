From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH 06/10] btrfs: fix remap_file_pages error
Date: Fri, 21 May 2010 16:54:45 +0800
Message-ID: <4BF64A55.9040707@cn.fujitsu.com>
References: <4BF4E30E.3070402@cn.fujitsu.com> <20100520083237.GA11920@infradead.org>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100520083237.GA11920@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

on 2010-5-20 16:32, Christoph Hellwig wrote:
> On Thu, May 20, 2010 at 03:21:50PM +0800, Miao Xie wrote:
>> +	if (!mapping->a_ops->readpage)
>> +		return -ENOEXEC;
> 
> I don't think there's any instance of address_space operations without
> a readpage method in btrfs.

But, Btrfs is being developing. Maybe someone implement a instance of
address_space without a readpage method in the future. So it is better
to check it, just like ext4.

Thanks

