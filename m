From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: Sparse files and block devices
Date: Mon, 08 Aug 2011 15:13:40 +0900
Message-ID: <4E3F7E94.30900@jp.fujitsu.com>
References: <4E3F7A4D.50702@electronsweatshop.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Randy Barlow <randy@electronsweatshop.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E3F7A4D.50702@electronsweatshop.com>
List-ID: <linux-btrfs.vger.kernel.org>

(2011/08/08 14:55), Randy Barlow wrote:
> I started playing with btrfs last night, and I must say that I am very
> excited! I do have one question so far. Since I was learning, I created
> a sparse file, and then used mkfs to get a btrfs filesystem. I
> entertained myself with that for a while, and then decided that I wanted
> to try out the multi device support. I found that the device add command
> requires the device to be a block device, and wouldn't accept another
> sparse file that I had created. Is there a workaround, or is that just
> the way it is?

I think that you can use 'losetup' command for this end.

  -Tsutomu

>
> I ended up just making a logical volume to get the second block device.
>
> Thanks for making such a cool fs!

