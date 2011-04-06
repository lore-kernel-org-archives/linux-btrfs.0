From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at (null)
Date: Thu, 7 Apr 2011 01:42:18 +0200
Message-ID: <201104070142.18769.johannes.hirte@fem.tu-ilmenau.de>
References: <201104051938.14319.johannes.hirte@fem.tu-ilmenau.de> <20110406171541.GA5574@localhost.localdomain> <BANLkTi=hZ2i-kj70yq+=E74oSZZu9G7wtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Jordan Patterson <jordanp@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=hZ2i-kj70yq+=E74oSZZu9G7wtw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 06 April 2011 22:47:28 Jordan Patterson wrote:
> Hi Josef:
> 
> I tried your latest patch, since I had the same issue from the first
> email.  With the patch applied, I am now hitting the
> BUG_ON(block_group->total_bitmaps >= max_bitmaps); in add_new_bitmap
> in
> fs/btrfs/free-space-cache.c:1246 as soon as I mount the filesystem,
> with or without -o clear_cache.
> 
> It works fine in 2.6.38.  I get the same error after mounting with
> clear_cache under 2.6.38 and rebooting into the current kernel with
> your patch.
> 
> Jordan

What filesystem is it and how did you mount it with -o clear_cache? If it is 
your rootfs did you applied clear_cache to /etc/fstab or your bootloader? If 
it was the latter it won't work. For the rootfs you need to add it to the boot 
options. For me this worked every time.
Josef, is there any way to detect a wrong cache, saved by an pre-2.6.39 kernel 
and discard it?


regards,
  Johannes
