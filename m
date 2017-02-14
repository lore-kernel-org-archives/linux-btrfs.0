Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-02.prod.phx3.secureserver.net ([184.168.200.140]:45584
        "EHLO p3nlsmtpcp01-02.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751366AbdBNUHQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 15:07:16 -0500
Date: Wed, 15 Feb 2017 01:36:02 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: How to dump/find parity of RAID-5 file?
Message-ID: <20170214200602.GA24702@giis.co.in>
References: <20170203104406.GA3670@giis.co.in>
 <8c5cece7-29cf-82df-0739-ef4f0fe8bf70@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8c5cece7-29cf-82df-0739-ef4f0fe8bf70@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 06, 2017 at 09:36:58AM +0800, Qu Wenruo wrote:
> 
> Please note the following things when calculating RAID5/6 data and P/Q
> location:
> 
> 1) Basic layout
> The chunk stripe only shows the *first* full stripe layout.
> And it always follows the sequence of "Data0, Data1, ... Data N, Parity"
> 
> And one full stripe is consistent of N * 64K (fixed yet).
> 
> 
> 2) Device rotation
> RAID5/6 do device rotation.
> So the *second* full stripe will have the following layout:
> "Data 1, Data2, ... Data N, Parity, Data 0"
> 
> 
> You can refer to my offline-scrub patchset to see how it assemble the
> RAID5/6 mapping, which I believe it is easier than current btrfs_map_block()
> implementation.
> [PATCH v2 19/19] btrfs-progs: fsck: Introduce offline scrub function
> 
> Thanks,
> Qu
Sorry for the delay in response, I was offline. Thanks for the details. I think now I have 
better idea about (1)Basic layout  and (2)Device rotation. Will look into offline-scrub patches 
to explore more about exact mapping and on-disk layouts. I'm trying to understand layout for
simple Raid-5 with 3-drives with 128KB file-size. Will try to understand Raid-6 little later. 
thanks.

Cheers.
Lakshmipathi.G
