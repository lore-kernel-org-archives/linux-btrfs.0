Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:51984 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751268AbaB0VNl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 16:13:41 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: BUG: >16TB Btrfs volumes are mountable on 32 bit kernels
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <530FA8FA.9020700@fb.com>
Date: Thu, 27 Feb 2014 14:13:35 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <EC51F734-E235-4481-8470-49A34BAED15C@colorremedies.com>
References: <994B6F86-9AF0-4826-8352-8573EE8003B6@colorremedies.com> <530FA8FA.9020700@fb.com>
To: Josef Bacik <jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 27, 2014, at 2:07 PM, Josef Bacik <jbacik@fb.com> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 02/27/2014 04:05 PM, Chris Murphy wrote:
>> User reports successfully formatting and using an ~18TB Btrfs
>> volume on hardware raid5 using i686 kernel for over a year, and
>> then suddenly the file system starts behaving weirdly:
>> 
>> https://urldefense.proofpoint.com/v1/url?u=http://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg31856.html&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=6eUt5RgBggFh930oFrH19iR4z%2BFVzT%2F0%2F4dYPt3g48U%3D%0A&s=5ac126734d7fa1d3238ab09a2ddc021a8dcc8fff7b022560a4d068be2de37c00
>> 
>> 
>> 
>> I think this is due to the kernel page cache address space being
>> 16TB limited on 32-bit kernels, as mentioned by Dave Chinner in
>> this thread:
>> 
>> https://urldefense.proofpoint.com/v1/url?u=http://oss.sgi.com/pipermail/xfs/2014-February/034588.html&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=6eUt5RgBggFh930oFrH19iR4z%2BFVzT%2F0%2F4dYPt3g48U%3D%0A&s=3e45f9288e6a77bc1a24dded368802c2ab46b812bf59953f74d4ee1d4141f7d2
>> 
>> So it sounds like it shouldn't be possible to mount a Btrfs volume
>> larger than 16TB on 32-bit kernels. This is consistent with ext4
>> and XFS which refuse to mount large file systems.
>> 
>> 
> 
> Well that's not good, I'll fix this up.  Thanks,

Is it a valid or goofy work around to partition this 21TB volume into two equal portions, and then:

mkfs.btrfs -d single -m raid1 /dev/sdb[12]

Maybe it's too much of an edge case to permit it even if it worked?


Chris Murphy