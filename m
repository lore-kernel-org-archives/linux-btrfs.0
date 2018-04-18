Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55077 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750885AbeDRSac (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 14:30:32 -0400
Date: Wed, 18 Apr 2018 20:28:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Brendan Hide <brendan@swiftspirit.co.za>, linux-btrfs@vger.kernel.org
Subject: Re: nvme+btrfs+compression sensibility and benchmark
Message-ID: <20180418182800.GR21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <271cf4a5-92d6-04eb-5f7a-471c2997ca48@swiftspirit.co.za>
 <2611a2b3-689a-10a2-50e9-9de43fc03c8c@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <2611a2b3-689a-10a2-50e9-9de43fc03c8c@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 18, 2018 at 06:14:07PM +0300, Nikolay Borisov wrote:
> 
> 
> On 18.04.2018 18:10, Brendan Hide wrote:
> > Hi, all
> > 
> > I'm looking for some advice re compression with NVME. Compression helps
> > performance with a minor CPU hit - but is it still worth it with the far
> > higher throughputs offered by newer PCI and NVME-type SSDs?
> > 
> > I've ordered a PCIe-to-M.2 adapter along with a 1TB 960 Evo drive for my
> > home desktop. I previously used compression on an older SATA-based Intel
> > 520 SSD, where compression made sense.
> > 
> > However, the wisdom isn't so clear-cut if the SSD is potentially faster
> > than the compression algorithm with my CPU (aging i7 3770).
> > 
> > Testing using a copy of the kernel source tarball in tmpfs  it seems my
> > system can compress/decompress at about 670MB/s using zstd with 8
> > threads. lzop isn't that far behind. But I'm not sure if the benchmark
> > I'm running is the same as how btrfs would be using it internally.
> > 
> > Given these numbers I'm inclined to believe compression will make things
> > slower - but can't be sure without knowing if I'm testing correctly.
> > 
> > What is the best practice with benchmarking and with NVME/PCI storage?
> 
> btrfs doesn't support DAX so using it on NVME doesn't make much sense
> performance wise.

Is'nt NVMe just "the faster SSD"? Not the persistent memory thing.
