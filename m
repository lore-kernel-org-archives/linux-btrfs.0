Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFA89C43334
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Jul 2022 17:55:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiGORzp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Jul 2022 13:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiGORzn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Jul 2022 13:55:43 -0400
X-Greylist: delayed 60 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 15 Jul 2022 10:55:40 PDT
Received: from libero.it (smtp-31-wd.italiaonline.it [213.209.13.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478EB371BA
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2022 10:55:40 -0700 (PDT)
Received: from [192.168.1.27] ([94.34.5.22])
        by smtp-31.iol.local with ESMTPA
        id CPWPo4VEgRKx7CPWPoGvqQ; Fri, 15 Jul 2022 19:54:37 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1657907677; bh=oJLox+d4s27vFHN6XoSGrvoU0wTqdORgtryXrqPWnJo=;
        h=From;
        b=bXMRxJTDCS2p1LWL/3EMGFR7KLuGeN2ncIFlX6+Ltu4UNOCwr1nW2kabCTFs+cNvd
         LDIBJgsydr8i+vwS0B+JA3iL1Blfd/UT87oYgivYC5CqBGSC1Eo//6Agm1tZvIyJ/x
         QpCsByL63UUk5igPnE1KEzlw8ZFWzyEyLsEUJUVceBjAGuBdQbnNH/366tX21lb5PS
         ov3J/yfH5olAhncQCUI++lUgxcLFchA6BiRO7kchI9VMH3NOiBiNB5PBN77UK12X0i
         J/Nbghwz00AzDHK0phsx2+DEYUzCSoQJCIZPVisCd+hwPLGNmeHPbv6eD5uL7pa1wg
         /oii6JIxJ6SgQ==
X-CNFS-Analysis: v=2.4 cv=BqtYfab5 c=1 sm=1 tr=0 ts=62d1a9dd cx=a_exe
 a=hwDnfLutCD/4BcDojJwT2A==:117 a=hwDnfLutCD/4BcDojJwT2A==:17
 a=IkcTkHD0fZMA:10 a=_vluBC-bBg8jSFdFxHcA:9 a=QEXdDO2ut3YA:10
Message-ID: <8b3cf3d0-4812-0e92-d850-09a8d08b8169@libero.it>
Date:   Fri, 15 Jul 2022 19:54:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.1
Reply-To: kreijack@inwind.it
Subject: Re: RAID56 discussion related to RST. (Was "Re: [RFC ONLY 0/8] btrfs:
 introduce raid-stripe-tree")
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <cover.1652711187.git.johannes.thumshirn@wdc.com>
 <78daa7e4-7c88-d6c0-ccaa-fb148baf7bc8@gmx.com>
 <PH0PR04MB74164213B5F136059236B78C9B899@PH0PR04MB7416.namprd04.prod.outlook.com>
 <03630cb7-e637-3375-37c6-d0eb8546c958@gmx.com>
 <PH0PR04MB7416D257F7B349FC754E30169B899@PH0PR04MB7416.namprd04.prod.outlook.com>
 <1cf403d4-46a7-b122-96cf-bd1307829e5b@gmx.com>
 <PH0PR04MB741638E2A15F4E106D8A6FAF9B899@PH0PR04MB7416.namprd04.prod.outlook.com>
 <96da9455-f30d-b3fc-522b-7cbd08ad3358@suse.com>
 <PH0PR04MB7416E68375C1C27C33D347119B889@PH0PR04MB7416.namprd04.prod.outlook.com>
 <61694368-30ea-30a0-df74-fd607c4b7456@gmx.com>
 <PH0PR04MB7416243FCD419B4BDDB04D8C9B889@PH0PR04MB7416.namprd04.prod.outlook.com>
Content-Language: en-US
From:   Goffredo Baroncelli <kreijack@libero.it>
In-Reply-To: <PH0PR04MB7416243FCD419B4BDDB04D8C9B889@PH0PR04MB7416.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfINWIitgIbU0w9jCNCLOtwjvm0kTMX0krK6yhHiM7+RkhYimZzJl6IdHlCHovnO3XswxVbfBwksc7WziZDYtQJ0vu9Yv4pAEZTEAagB+yiB+zbtNrn7I
 CFDDJsFSMAdKo0fi24Ia01/vMf0MFOAFEvVQWS8tWrQ6QRtGkxp0apxotLAJQUA5BIwscs4rerzg3OjsErE7kDHn2dkZUjaoELdLTYSi8nYR3DtWx0ktI+0k
 aj5mW0y2Di7W56HzRnSS5coL25J9F/7UHrn1xr/zM+VRF9s6p73huZEF/qW30vZx
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 14/07/2022 09.46, Johannes Thumshirn wrote:
> On 14.07.22 09:32, Qu Wenruo wrote:
>>[...]
> 
> Again if you're doing sub-stripe size writes, you're asking stupid things and
> then there's no reason to not give the user stupid answers.
> 

Qu is right, if we consider only full stripe write the "raid hole" problem
disappear, because if a "full stripe" is not fully written it is not
referenced either.


Personally I think that the ZFS variable stripe size, may be interesting
to evaluate. Moreover, because the BTRFS disk format is quite flexible,
we can store different BG with different number of disks. Let me to make an
example: if we have 10 disks, we could allocate:
1 BG RAID1
1 BG RAID5, spread over 4 disks only
1 BG RAID5, spread over 8 disks only
1 BG RAID5, spread over 10 disks

So if we have short writes, we could put the extents in the RAID1 BG; for longer
writes we could use a RAID5 BG with 4 or 8 or 10 disks depending by length
of the data.

Yes this would require a sort of garbage collector to move the data to the biggest
raid5 BG, but this would avoid (or reduce) the fragmentation which affect the
variable stripe size.

Doing so we don't need any disk format change and it would be backward compatible.


Moreover, if we could put the smaller BG in the faster disks, we could have a
decent tiering....


> If a user is concerned about the write or space amplicfication of sub-stripe
> writes on RAID56 he/she really needs to rethink the architecture.
> 
> 
> 
> [1]
> S. K. Mishra and P. Mohapatra,
> "Performance study of RAID-5 disk arrays with data and parity cache,"
> Proceedings of the 1996 ICPP Workshop on Challenges for Parallel Processing,
> 1996, pp. 222-229 vol.1, doi: 10.1109/ICPP.1996.537164.

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

