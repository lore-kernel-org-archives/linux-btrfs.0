From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: 2.6.38 defragment compression oops...
Date: Mon, 28 Mar 2011 14:58:04 +0800
Message-ID: <4D90317C.8040409@cn.fujitsu.com>
References: <AANLkTin5EKNYUVwUMO+PoJyuEBVxubUuAHfu-ue4w+7n@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTin5EKNYUVwUMO+PoJyuEBVxubUuAHfu-ue4w+7n@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Daniel J Blueman wrote:
> I found that I'm able to provoke undefined behaviour with 2.6.38 with
> extent defragmenting + recompression, eg:
> 
> mkfs.btrfs /dev/sdb
> mount /dev/sdb /mnt
> cp -xa / /mnt
> find /mnt -print0 | xargs -0 btrfs filesystem defragment -vc
> 
> After a short time, I was seeing what looked like a secondary effect
> [1]. Reproducing with lock instrumentation reported recursive spinlock
> acquisition, probably a false-positive from the locking scheme not
> being annotated, so better report it now.
> 

Thanks for the report! I'll investigate this.
