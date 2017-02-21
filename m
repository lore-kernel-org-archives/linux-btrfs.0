Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-02.prod.phx3.secureserver.net ([184.168.200.140]:46012
        "EHLO p3nlsmtpcp01-02.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751099AbdBUJnO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Feb 2017 04:43:14 -0500
Date: Tue, 21 Feb 2017 15:11:40 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, kreijack@inwind.it
Subject: Re: [PATCH] btrfs-progs: RAID5:Inject data stripe corruption and
 verify scrub fixes it.
Message-ID: <20170221094140.GB5217@giis.co.in>
References: <20170215090338.GA11666@giis.co.in>
 <e0a04535-80ad-671c-15b7-4a37305c1be4@cn.fujitsu.com>
 <20170215205622.GA2518@giis.co.in>
 <6fee8854-fc3f-c664-4004-b3579208b234@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6fee8854-fc3f-c664-4004-b3579208b234@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> >
> >Looked into patch description:
> >
> >After scrubbing dev3 only:
> >0xcdcd (Good)  |      0xcdcd      | 0xcdcd (Bad)
> >    (D1)              (D2)            (P)
> >
> >So the Parity stripe (P) always get replaced by exact content of D1/D2 (data-stripe)
> >or by random  data?
> 
> Neither. it's just XOR result of D2(never changed, 0xcdcd) and old D1(wrong,
> 0x0000).
> 0xcdcd XOR 0x0000 = 0xcdcd
> 
> So you got 0xcdcd, bad result.
> 
> If you corrupt D1 with random data, then parity will be random then.
> 
> >If it always  get replaced by exact value from either
> >D1 or D2.  I think current script can be modified to detect that bug. If parity gets
> >replaced by random value, then it will the make task more difficult.
> 
> Not hard to detect.
> As the content is completely under your control, you know the correct parity
> value, and you can verify it very easy.
> 

version-3 of this script calculates exact data/parity location, instead of dumping data 
and searching locations. Tested with upto 8MB file, from the output all 128 data-stripes 
and 64 parity stripe location seems fine. It constantly hit the parity bug with the script.


If the script gets accepted, will add slightly other corruption variants likes:
- corrupt all even stripe (D2,D4..)
- corrupt all odd stripe  (D1,D3..)
- corrupt all parity stripes
- corrupt all both data stripe (D0 & D1) and expect error message
(Cover above cases for RAID6)

thanks.

Cheers.
Lakshmipathi.G

