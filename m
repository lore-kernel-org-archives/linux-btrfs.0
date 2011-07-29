From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] Btrfs: reserve enough space for file clone
Date: Fri, 29 Jul 2011 05:32:30 -0400
Message-ID: <20110729093230.GA1050@infradead.org>
References: <4E32475E.2080404@cn.fujitsu.com>
 <4E326A48.107@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E326A48.107@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 29, 2011 at 04:07:36PM +0800, Li Zefan wrote:
>   # mount -t btrfs /dev/sda7 /mnt
>   # dd if=/dev/zero of=/mnt/src bs=10K count=1
>   # sync
>   # clone 4K from /mnt/src to /mnt/dst
> 
> kernel BUG at fs/btrfs/delayed-inode.c:1693!

Sounds like a regression test you should add to xfstests.
