From: Calvin Walton <calvin.walton@gmail.com>
Subject: Re: Horrible btrfs performance on cold cache
Date: Mon, 11 Oct 2010 11:46:19 -0400
Message-ID: <1286811979.9645.5.camel@ayu>
References: <AANLkTin8mAaHz_PypS9j4vQ35WozgD==U493e3OW_sy2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTin8mAaHz_PypS9j4vQ35WozgD==U493e3OW_sy2@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2010-10-11 at 03:30 +0300, Felipe Contreras wrote:
> Hi,
> 
> I use btrfs on most of my volumes on my laptop, and I've always felt
> booting was very slow, but definitely sure is slow, is starting up
> Google Chrome:
> 
> encrypted ext4: ~20s
> btrfs: ~2:11s
> 
> I have tried different things to find out exactly what is the issue,
> but haven't quite found it yet.

If you've been using this volume for a while, it could just have become
badly fragmented. You could try btrfs's fancy online defragmentation
abilities to see if that'll give you an improvement:

# btrfs filesystem defragment /mountpoint/of/volume

Let us know if that helps, of course :)

-- 
Calvin Walton <calvin.walton@gmail.com>

