Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:38293 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965275AbbGVONx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jul 2015 10:13:53 -0400
Received: by iggf3 with SMTP id f3so134434306igg.1
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2015 07:13:48 -0700 (PDT)
Received: from mail-ig0-f172.google.com (mail-ig0-f172.google.com. [209.85.213.172])
        by smtp.gmail.com with ESMTPSA id ig10sm9457841igb.21.2015.07.22.07.13.47
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jul 2015 07:13:47 -0700 (PDT)
Received: by igbij6 with SMTP id ij6so137617063igb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2015 07:13:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55AF7B84.9000009@gmail.com>
References: <CAEMJtDs=U5+YO9sbVvjxLthdxp6JvZO=07EMhcU5Smif_1m5QQ@mail.gmail.com>
	<557A890D.8080306@cn.fujitsu.com>
	<CAEMJtDu2zZJc-dg9opj0xHaKyeL78H0ppivb8mJFhChJ4J63uA@mail.gmail.com>
	<557E877E.2060704@cn.fujitsu.com>
	<CAEMJtDusywPEnDcNcMvvFKQsuZyTmSMXXgJT=eBZX1F+R8RM8w@mail.gmail.com>
	<557F7B82.2060203@cn.fujitsu.com>
	<CAEMJtDv1Tm7-O2mU03kZhPDkaSj7nVi+VAZVhPfh7BN8AuF2Bg@mail.gmail.com>
	<55A46473.8070106@cn.fujitsu.com>
	<55AE04EF.6040807@cn.fujitsu.com>
	<55AE29DA.4050201@gmail.com>
	<CAEMJtDuaOYPomha_VbTah521BZTYzmrg2D5tk6N4rd1Y8UPaog@mail.gmail.com>
	<55AEF984.9080706@cn.fujitsu.com>
	<55AF7B84.9000009@gmail.com>
Date: Wed, 22 Jul 2015 15:13:47 +0100
Message-ID: <CAC6JEv-=9LPR7XL9XJt6ZSKGuGYS4eAT+fAYHNrRQJWxe1metQ@mail.gmail.com>
Subject: Re: Can't mount btrfs volume on rbd
From: Gregory Farnum <greg@gregs42.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Steve Dainard <sdainard@spd1.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 22, 2015 at 12:16 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2015-07-21 22:01, Qu Wenruo wrote:
>>
>> Steve Dainard wrote on 2015/07/21 14:07 -0700:
>>>
>>> I don't know if this has any bearing on the failure case, but the
>>> filesystem that I sent an image of was only ever created, subvol
>>> created, and mounted/unmounted several times. There was never any data
>>> written to that mount point.
>>>
>> Subvol creation and rw mount is enough to trigger 2~3 transaction with
>> DATA written into btrfs.
>> As the first rw mount will create free space cache, which is counted as
>> data.
>>
>> But without multiple mount instants, I really can't consider another
>> method to destroy btrfs so badly but with all csum OK...
>>
> I know that a while back RBD had some intermittent issues with data
> corruption in the default configuration when the network isn't absolutely
> 100% reliable between all nodes (which for ceph means not only no packet
> loss, but also tight time synchronization between nodes and only very low
> network latency).
>
> I also heard somewhere (can't remember exactly where though) of people
> having issues with ZFS on top of RBD.
>
> The other thing to keep in mind is that Ceph does automatic background data
> scrubbing (including rewriting stuff it thinks is corrupted), so there is no
> guarantee that the data on the block device won't change suddenly without
> the FS on it doing anything.

Ceph will automatically detect inconsistent data with its scrubbing,
but it won't rewrite that data unless the operator runs a repair
command. No invisible data changes! :)

I'm also not familiar with any consistency issues around network speed
or time sync, but I could have missed something. The only corruption
case I can think of was a release that enabled some local FS features
which in combination were buggy on some common kernels in the wild.
-Greg
