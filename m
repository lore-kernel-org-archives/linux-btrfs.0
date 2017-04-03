Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:55022 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751647AbdDCIur (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Apr 2017 04:50:47 -0400
Date: Mon, 3 Apr 2017 13:41:07 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Marat Khalili <mkh@rqc.ru>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: mix ssd and hdd in single volume
Message-ID: <20170403134107.30e923d8@natsu>
In-Reply-To: <c3b00962-6ab2-d289-be77-2586bf57cd6f@rqc.ru>
References: <CAEgruXvAEBfpQaAxCi42Vq6v8w7v1dqthpn9TpE3FDDHoTWRcw@mail.gmail.com>
        <pan$dda3$b8e27938$5de5fd9$136342b5@cox.net>
        <c3b00962-6ab2-d289-be77-2586bf57cd6f@rqc.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 3 Apr 2017 11:30:44 +0300
Marat Khalili <mkh@rqc.ru> wrote:

> You may want to look here: https://www.synology.com/en-global/dsm/Btrfs 
> . Somebody forgot to tell Synology, which already supports btrfs in all 
> hardware-capable devices. I think Rubicon has been crossed in 
> 'mass-market NAS[es]', for good or not.

AFAIR Synology did not come to this list asking for (any kind of) advice
prior to implementing that (else they would have gotten the same kind of post
from Duncan and others), and it's not Btrfs developers job to have an outreach
program to contact vendors and educate them to not use Btrfs.

I don't remember seeing them actively contribute improvements or fixes
especially for the RAID5 or RAID6 features (which they ADVERTISE on that page
as a fully working part of their product). That doesn't seem honest to end
users or playing nicely with the upstream developers. What the upstream gets
instead is just those end-users coming here one by one some years later,
asking how to fix a broken Btrfs RAID5 on an embedded box running some 3.10 or
3.14 kernel.

-- 
With respect,
Roman
