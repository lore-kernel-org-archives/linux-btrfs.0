Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from wie.mywh.net ([62.109.39.47]:50048 "EHLO wie.mywh.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752479AbcLQWRU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Dec 2016 17:17:20 -0500
Received: from [128.77.16.244] (port=37274 helo=[192.168.1.169])
        by wie.mywh.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.87)
        (envelope-from <btrfs+list@olstad.com>)
        id 1cINI5-0006rI-8s
        for linux-btrfs@vger.kernel.org; Sat, 17 Dec 2016 23:17:17 +0100
From: Kai Stian Olstad <btrfs+list@olstad.com>
Subject: Re: mount raid1 gives open_ctree failed
To: linux-btrfs@vger.kernel.org
References: <603b293e-8b74-a8ed-893b-c9c041af20ef@olstad.com>
Message-ID: <8282163c-1fc7-0d67-ab78-61717d2a40bc@olstad.com>
Date: Sat, 17 Dec 2016 23:17:17 +0100
MIME-Version: 1.0
In-Reply-To: <603b293e-8b74-a8ed-893b-c9c041af20ef@olstad.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25. nov. 2016 21:19, Kai Stian Olstad wrote:
> I have problem mounting my 3 disk raid1.
> This happened after upgrading from Kubuntu 14.04 to 16.04.

I finally found the problem.
Since I needed to reboot after the upgrade I decided to add some disks,
and in order to do that I needed to move around some of the other disks.
And the disk(6TB) for this btrfs raid1 happened to land on a HBA that 
doesn't support disk lager than 2 TB.

Moved them to the motherboards SATA connection and they mounted like 
nothing had happened.

-- 
Kai Stian Olstad
PS: I really need to replace those HBAs
