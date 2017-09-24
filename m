Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29706 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751813AbdIXKDK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Sep 2017 06:03:10 -0400
Subject: Re: [PATCH v3 07/14] btrfs-progs: Doc/mkfs: Add extra condition for
 rootdir option
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz
References: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
 <20170918072139.6300-8-quwenruo.btrfs@gmx.com>
 <7cec48bd-c007-618f-b361-d4425c757c5c@oracle.com>
 <trinity-eef9a61f-60ab-47a3-9771-d638cb0083c9-1506076766926@3c-app-mailcom-bs16>
 <9f598cb9-0267-158d-c54b-13f4372eadd5@gmail.com>
 <9652f4f4-b91c-0382-fa2a-01d45dde7fbb@gmx.com>
 <5e079410-cd64-3d40-8914-b3d48ecdebfd@gmail.com>
 <808d11d8-f22b-f26e-ba3f-7d148915db5a@gmx.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <5b26f9dd-8bae-a35a-4920-4a617b52f9f7@oracle.com>
Date: Sun, 24 Sep 2017 18:10:46 +0800
MIME-Version: 1.0
In-Reply-To: <808d11d8-f22b-f26e-ba3f-7d148915db5a@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> All my points are clear for this patchset:
> I know I removed one function, and my reason is:
> 1) No or little usage
>     And it's anti intuition.
> 2) Dead code (not tested nor well documented)
> 3) Possible workaround
> 
> I can add several extra reasons as I stated before, but number of 
> reasons won't validate anything anyway.

  End user convenience wins over the developer's technical difficulties.

  Pls don't remove this feature, it needs fix such as #2 (above) to 
improve on #1 (above) as in your list.

Thanks, Anand
