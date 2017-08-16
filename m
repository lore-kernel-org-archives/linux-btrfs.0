Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:41586 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751580AbdHPMqf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 08:46:35 -0400
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: slow btrfs with a single kworker process using 100% CPU
To: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>,
        Roman Mamedov <rm@romanrm.net>
Cc: Marat Khalili <mkh@rqc.ru>, linux-btrfs@vger.kernel.org,
        Peter Grandi <pg@btrfs.list.sabi.co.uk>
References: <eab2f725-ab6e-d2ac-30e1-d9c964ce8be8@profihost.ag>
 <4772c3f2-0074-d86f-24c4-02ff0730fce7@rqc.ru>
 <064eaaed-7748-7064-874e-19d270d0854e@profihost.ag>
 <4669553.344.1502874134710.JavaMail.gkos@dynomob>
 <f6f3998b-3ca7-7344-a577-6b02a5b11359@profihost.ag>
 <18522132.418.1502884115575.JavaMail.gkos@dynomob>
 <20170816170003.3f47321d@natsu>
 <31057849.442.1502886546489.JavaMail.gkos@dynomob>
Message-ID: <c750108a-f769-9061-93fa-ce0843989495@profihost.ag>
Date: Wed, 16 Aug 2017 14:46:34 +0200
MIME-Version: 1.0
In-Reply-To: <31057849.442.1502886546489.JavaMail.gkos@dynomob>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Am 16.08.2017 um 14:29 schrieb Konstantin V. Gavrilenko:
> Roman, initially I had a single process occupying 100% CPU, when sysrq it was indicating as "btrfs_find_space_for_alloc"
> but that's when I used the autodefrag, compress, forcecompress and commit=10 mount flags and space_cache was v1 by default.
> when I switched to "relatime,compress-force=zlib,space_cache=v2" the 100% cpu has dissapeared, but the shite performance remained.
> 
> 
> As to the chunk size, there is no information in the article about the type of data that was used. While in our case we are pretty certain about the compressed block size (32-128). I am currently inclining towards 32k as it might be ideal in a situation when we have a 5 disk raid5 array.
> 
> In theory
> 1. The minimum compressed write (32k) would fill the chunk on a single disk, thus the IO cost of the operation would be 2 reads (original chunk + original parity)  and 2 writes (new chunk + new parity)
> 
> 2. The maximum compressed write (128k) would require the update of 1 chunk on each of the 4 data disks + 1 parity  write 
> 
> 
> 
> Stefan what mount flags do you use?

noatime,compress-force=zlib,noacl,space_cache,skip_balance,subvolid=5,subvol=/

Greets,
Stefan


> kos
> 
> 
> 
> ----- Original Message -----
> From: "Roman Mamedov" <rm@romanrm.net>
> To: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>
> Cc: "Stefan Priebe - Profihost AG" <s.priebe@profihost.ag>, "Marat Khalili" <mkh@rqc.ru>, linux-btrfs@vger.kernel.org, "Peter Grandi" <pg@btrfs.list.sabi.co.uk>
> Sent: Wednesday, 16 August, 2017 2:00:03 PM
> Subject: Re: slow btrfs with a single kworker process using 100% CPU
> 
> On Wed, 16 Aug 2017 12:48:42 +0100 (BST)
> "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com> wrote:
> 
>> I believe the chunk size of 512kb is even worth for performance then the default settings on my HW RAID of  256kb.
> 
> It might be, but that does not explain the original problem reported at all.
> If mdraid performance would be the bottleneck, you would see high iowait,
> possibly some CPU load from the mdX_raidY threads. But not a single Btrfs
> thread pegging into 100% CPU.
> 
>> So now I am moving the data from the array and will be rebuilding it with 64
>> or 32 chunk size and checking the performance.
> 
> 64K is the sweet spot for RAID5/6:
> http://louwrentius.com/linux-raid-level-and-chunk-size-the-benchmarks.html
> 
