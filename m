Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from black.maple.relay.mailchannels.net ([23.83.214.19]:45114 "EHLO
        black.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752135AbeDRPLB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 11:11:01 -0400
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 08D1D3E046D
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Apr 2018 15:11:00 +0000 (UTC)
Received: from lnxwebr13.cpt.wa.co.za (unknown [100.96.32.20])
        (Authenticated sender: webafrica)
        by relay.mailchannels.net (Postfix) with ESMTPA id 11E053E1FAC
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Apr 2018 15:10:58 +0000 (UTC)
Received: from [41.74.182.178] (port=41292 helo=tricky-laptop.valid.co.za)
        by lnxwebr13.cpt.wa.co.za with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.89_1)
        (envelope-from <brendan@swiftspirit.co.za>)
        id 1f8ojY-001qAn-CY
        for linux-btrfs@vger.kernel.org; Wed, 18 Apr 2018 17:10:56 +0200
To: linux-btrfs@vger.kernel.org
From: Brendan Hide <brendan@swiftspirit.co.za>
Subject: nvme+btrfs+compression sensibility and benchmark
Message-ID: <271cf4a5-92d6-04eb-5f7a-471c2997ca48@swiftspirit.co.za>
Date: Wed, 18 Apr 2018 17:10:54 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, all

I'm looking for some advice re compression with NVME. Compression helps 
performance with a minor CPU hit - but is it still worth it with the far 
higher throughputs offered by newer PCI and NVME-type SSDs?

I've ordered a PCIe-to-M.2 adapter along with a 1TB 960 Evo drive for my 
home desktop. I previously used compression on an older SATA-based Intel 
520 SSD, where compression made sense.

However, the wisdom isn't so clear-cut if the SSD is potentially faster 
than the compression algorithm with my CPU (aging i7 3770).

Testing using a copy of the kernel source tarball in tmpfs  it seems my 
system can compress/decompress at about 670MB/s using zstd with 8 
threads. lzop isn't that far behind. But I'm not sure if the benchmark 
I'm running is the same as how btrfs would be using it internally.

Given these numbers I'm inclined to believe compression will make things 
slower - but can't be sure without knowing if I'm testing correctly.

What is the best practice with benchmarking and with NVME/PCI storage?

