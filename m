Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:34281 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750695Ab3ALFBv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Jan 2013 00:01:51 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Errors not found by btrfsck or scrub
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAHX0HSbWj6vywv56x32F6EyGkh_yt2WkZOXcEpUn4P0pmxoANw@mail.gmail.com>
Date: Fri, 11 Jan 2013 22:01:49 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <D3A9620E-DD04-4FB9-950C-75D61436F7D3@colorremedies.com>
References: <CAHX0HSbVxW0HvvXi-LXPqGUDu5AZgNRJssMeWRp_MetvVc_gwQ@mail.gmail.com> <CAHX0HSZGuE_N1x3DTRPcQZ66B4Sqs7T9sj33=pyVs64wQSWwtw@mail.gmail.com> <20130111185449.GU19051@carfax.org.uk> <CAHX0HSby06a7x9iDgvRwtMJbcysQGkFYxeQf0XTM35rRHp=m2w@mail.gmail.com> <D6893685-FF9E-43CE-817A-6799ED518FAC@colorremedies.com> <CAHX0HSbWj6vywv56x32F6EyGkh_yt2WkZOXcEpUn4P0pmxoANw@mail.gmail.com>
To: chris.r.carlin@gmail.com, Chris Carlin <chrisrcarlin@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 11, 2013, at 9:43 PM, Chris Carlin <chrisrcarlin@gmail.com> wrote:

>> Based on some experiences I've had, and also seen on the list recently, you might be able to back out of this situation by adding another device to the volume. It almost doesn't matter how big it is. It could be a small partition on another disk, or even a USB stick. I can't tell you how much space. It might only need a few MB, but I'd give it what you can. And then see if you can redo the balance. But it sounds to me like the file system is very close to full, at least it can't allocate more space for metadata it seems.
> 
> Aha! Worked fine.
> 
> I added a temporary 10GB device, and everything instantly started
> working. After I ran another balance command with -dusage=5, I deleted
> the new device and everything's fine with the original two devices.
> The temporary device was barely touched by the filesystem, if it was
> touched at all.
> 
> A weird thing is "btrfs fi show" showed tens of gigs of unallocated
> space the whole time.
> 
> Anyway, so for anyone who might have a similar problem in the future,
> giving btrfs a little temporary scratch space did the trick.

Well you never did show us your before btrfs fi show, but going back to your fi df from the original email:

Metadata, RAID1: total=512.00MB, used=511.60MB
Metadata, DUP: total=1.00GB, used=1022.39MB

It's out of space for metadata, is the problem I see above. There's not even 2 MB of space left.

Yes in this portion for data:

Data, RAID0: total=776.32GB, used=717.56GB
Data: total=81.00GB, used=29.44GB

This implies  you have lots of space, but actually it's the first value that matters in these cases because data and metadata allocations are separate. This space you think you have free is allocated for data. I don't know the details of whether, when, or how Btrfs can deallocate a data chunk and reallocate it for metadata but clearly it was unable or unwilling to do so in this case. So when you added the temporary space, it was immediately able to allocate some additional for metadata chunk and unwind itself.

Chris Murphy