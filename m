Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7016DC7618E
	for <linux-btrfs@archiver.kernel.org>; Sat, 22 Apr 2023 00:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbjDVAn3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 21 Apr 2023 20:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjDVAn2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Apr 2023 20:43:28 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7E11BD5
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Apr 2023 17:43:27 -0700 (PDT)
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N6KYb-1qMvHD1FeL-016eDJ; Sat, 22
 Apr 2023 02:42:47 +0200
Message-ID: <cd4024f7-3ff6-328a-08f5-7f405d5a9491@gmx.com>
Date:   Sat, 22 Apr 2023 08:42:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: Does btrfs filesystem defragment -r also include the trees?
Content-Language: en-US
To:     joshua <joshua@mailmag.net>, Qu Wenruo <wqu@suse.com>
Cc:     waxhead@dirtcellar.net, Remi Gauvin <remi@georgianit.com>,
        dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <44-64431b80-5-7f085200@250139773>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <44-64431b80-5-7f085200@250139773>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:ynhDkYMnapqQKrQHwRmhWPjTKukIoqINz9Yi2IH2AjjWr5V/S+c
 jZts4+9heLrGSUsT8bJlTapoq3cKJTMqcS9nlQrCp59Wsh8Lj4Ur73DigP5vLYrDK4ci9gP
 CiSwD+9IhTpKCLVb3Sd9VXOniWGyqdCbU3Wnia27PPCJb6QSfZHY0WCyzbA78scVHWkdBU1
 x3g9efb9aEPalClWr4c4w==
UI-OutboundReport: notjunk:1;M01:P0:MdSPcd2AcIU=;Aw5rV/m95BqzZssG7U9UOGhFi0M
 zFThqgrsRHZJ/KcjR9SQ0S7JBnvSix5eES9+y1ushlr1hT+G5bZk7g/TJ7TlfE4mzjsSX1dch
 7/uyV6Bdm8FSI3Cp2ArcOUZlvo1b967fFrN1y4fiD4Kedxhe7W2ceZ+mhGe57kRtVQk7o1HAN
 YkS7AUfUo/hcMciTezsu12TPitW1OVG8j57Ehwn7qqIFnP1/52orpG1a2QIF9uI3fE/wHvAJr
 O5Qd0hN2YsauuTjD2D0xNw9+EsJCllLkJ2g0iCJeX84WijGqKwVk+2/aNku8hSJLT5e07oBe6
 ChSYldn/HCK3lakRd8f3bvO1eyvkQ3NjgRPelky/xOj7pdcqtUc91LnLsgrgV4MwSpqKyOxnR
 XBqPl71PhWgbtDoasgzXx8WA6csGcte3sDqRviRyNnlvBeJK/7nr/5YX2pM9UZ2boQmr9O3i/
 XgTgez4LrnSxs5usPNhwOl0Zv81vxkMfy1ikMFkocapRGM/TuKZ5iEraJ0BW0KTuEekFjDeji
 dHkk8RErcmvdwcvi0+Sld+bMsOc1BraQWjfbC4jbRZpF1RJsVxNrn4MteLt2MupSPBnipaJXG
 jC4E+4AEwK1UGaVXIKfvZev8VJX2bi0TuNzjiWTFmo27e9aTnMkfMzi6pahmoLsSd4RjMuUKr
 vp/RU4bpVCHtSV0TPxmKBJPOqCvNnTZBhROzrbWcmkGzmHuZ0IbjRArrYSDM+xCCk2CWOq1sA
 2AQEnaRMiyBJTATwdNLgILsqqMjGX7YWPZ+5I0zanmOT7WCXMGZ7rCvSLrLEtJ0h0aEi6NESd
 r6IgmUsDI+pLENSBSzuUz8GLsi9uftVj2XVXmDltlXPbOO8jKLcTIyfEW7oVtLvKMoGUrcDGW
 j7SItlLJOiapMcGi+Xh88kgHkFGt861RVsFlS6OMSG0YIyMEmGr/Nx8RpznSXHZMa4A7lSeQ4
 rxJfhc1f2CpZdvhASV4huL6UA9Q=
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2023/4/22 07:25, joshua wrote:
> For my situation, (and others with large arrays) yes definitely.
> It's definitely the feature I'm most interested in patiently waiting for....
> 

You can already compile the current btrfs-progs release with 
experimental features, which enables the "btrfstune -b" command to 
convert your existing btrfs to the new feature.

I believe David would release the next btrfs-progs with bg tree moved to 
regular features.

And even better, the new bg-tree feature is compat_ro, meaning 
unsupported kernel can still mount the fs RO.

Thanks,
Qu
