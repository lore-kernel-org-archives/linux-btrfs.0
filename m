From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 0/3] xfstests: Add a group of reservation space test
Date: Wed, 9 Nov 2011 03:38:11 -0500
Message-ID: <20111109083811.GA23248@infradead.org>
References: <4EB8A441.7090506@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com,
	Christoph Hellwig <hch@infradead.org>
To: WuBo <wu.bo@cn.fujitsu.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4EB8A441.7090506@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 08, 2011 at 11:38:41AM +0800, WuBo wrote:
> Changes v1->v2:
> - Make test-set support generic
> 
> This patch set add a group of reservation space test. Especailly for btrfs.
> It includes three parts: copy workload, prealloc and write posix.
> 
> For test 273, I hope it's usefull for Josef's reserve improve work.
> For test 274 and 275, the current btrfs is not pass yet.
> 
> Wu Bo (3):
>   xfstests 273: add a copy and reserve test
>   xfstests 274: add a prealloc and reserve test
>   xfstests 275: add a write and reserve test

The patches look good to me.  Unless someone else complains until
tomorrow I'll put them in.

