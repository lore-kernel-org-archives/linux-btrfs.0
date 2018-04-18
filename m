Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55489 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752247AbeDRScW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 14:32:22 -0400
Subject: Re: nvme+btrfs+compression sensibility and benchmark
To: dsterba@suse.cz, Brendan Hide <brendan@swiftspirit.co.za>,
        linux-btrfs@vger.kernel.org
References: <271cf4a5-92d6-04eb-5f7a-471c2997ca48@swiftspirit.co.za>
 <2611a2b3-689a-10a2-50e9-9de43fc03c8c@suse.com>
 <20180418182800.GR21272@twin.jikos.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <547705c5-7a73-cce9-e8af-2f2e7dadc52c@suse.com>
Date: Wed, 18 Apr 2018 21:32:19 +0300
MIME-Version: 1.0
In-Reply-To: <20180418182800.GR21272@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 18.04.2018 21:28, David Sterba wrote:
> On Wed, Apr 18, 2018 at 06:14:07PM +0300, Nikolay Borisov wrote:
>>
>>
>> On 18.04.2018 18:10, Brendan Hide wrote:
>>> Hi, all
>>>
>>> I'm looking for some advice re compression with NVME. Compression helps
>>> performance with a minor CPU hit - but is it still worth it with the far
>>> higher throughputs offered by newer PCI and NVME-type SSDs?
>>>
>>> I've ordered a PCIe-to-M.2 adapter along with a 1TB 960 Evo drive for my
>>> home desktop. I previously used compression on an older SATA-based Intel
>>> 520 SSD, where compression made sense.
>>>
>>> However, the wisdom isn't so clear-cut if the SSD is potentially faster
>>> than the compression algorithm with my CPU (aging i7 3770).
>>>
>>> Testing using a copy of the kernel source tarball in tmpfs  it seems my
>>> system can compress/decompress at about 670MB/s using zstd with 8
>>> threads. lzop isn't that far behind. But I'm not sure if the benchmark
>>> I'm running is the same as how btrfs would be using it internally.
>>>
>>> Given these numbers I'm inclined to believe compression will make things
>>> slower - but can't be sure without knowing if I'm testing correctly.
>>>
>>> What is the best practice with benchmarking and with NVME/PCI storage?
>>
>> btrfs doesn't support DAX so using it on NVME doesn't make much sense
>> performance wise.
> 
> Is'nt NVMe just "the faster SSD"? Not the persistent memory thing.

Indeed, brain fart on my part. NVDIMM is the persistent memory thing.

> 
