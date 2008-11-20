From: "Alexander Beregalov" <a.beregalov@gmail.com>
Subject: Re: WARNING: at fs/btrfs/extent_io.c:3546 write_extent_buffer()
Date: Fri, 21 Nov 2008 01:02:25 +0300
Message-ID: <a4423d670811201402y4e9582dfr88816ecb65120dd7@mail.gmail.com>
References: <a4423d670811201350le43f908m6fd59b72efa9ecf4@mail.gmail.com>
	 <1227218291.9895.0.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "Chris Mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1227218291.9895.0.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

2008/11/21 Chris Mason <chris.mason@oracle.com>:
> On Fri, 2008-11-21 at 00:50 +0300, Alexander Beregalov wrote:
>> Hi
>>
>> I try to run btrfs (Linus's-git + btrfs-unstable) on sparc64:
>>
>
> On sparc64, you'll have to set the sectorsize to your page size.  What
> is the output from mkfs.btrfs?

fs created label (null) on /dev/sdb1
        nodesize 8192 leafsize 8192 sectorsize 8192 size 19.00GB
Btrfs v0.16-20-g49bc666


Page size is 8kb
