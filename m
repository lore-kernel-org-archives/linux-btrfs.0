From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/10] btrfs: fix remap_file_pages error
Date: Thu, 20 May 2010 04:32:37 -0400
Message-ID: <20100520083237.GA11920@infradead.org>
References: <4BF4E30E.3070402@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BF4E30E.3070402@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 20, 2010 at 03:21:50PM +0800, Miao Xie wrote:
> +	if (!mapping->a_ops->readpage)
> +		return -ENOEXEC;

I don't think there's any instance of address_space operations without
a readpage method in btrfs.

