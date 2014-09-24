Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52462 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751650AbaIXBIP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Sep 2014 21:08:15 -0400
Message-ID: <54221977.9040707@cn.fujitsu.com>
Date: Wed, 24 Sep 2014 09:08:07 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Tobias Holst <tobby@tobby.eu>, <linux-btrfs@vger.kernel.org>
Subject: Re: general thoughts and questions + general and RAID5/6 stability?
References: <8D1A2626CC69D79-11FC-A2C3@webmail-va141.sysops.aol.com> <pan$5a87e$97e2e260$54942ad0$cefe56f1@cox.net> <54208BBC.1000700@xunil.at> <542162A8.2010700@gmail.com> <5421706F.6070301@xunil.at> <542177BF.2000808@gmail.com> <CAGwxe4iqZY-GB3tREyqU0O4rkLk0_+oBdft1pRzaTxbZkr-JbQ@mail.gmail.com>
In-Reply-To: <CAGwxe4iqZY-GB3tREyqU0O4rkLk0_+oBdft1pRzaTxbZkr-JbQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: general thoughts and questions + general and RAID5/6 stability?
From: Tobias Holst <tobby@tobby.eu>
To: <linux-btrfs@vger.kernel.org>
Date: 2014年09月23日 22:24
> If it is unknown, which of these options have been used at btrfs
> creation time - is it possible to check the state of these options
> afterwards on a mounted or unmounted filesystem?
For mounted fs, sysfs can be used to see the feature enabled:
/sys/fs/btrfs/<UUID>/features/

For unmounted fs, maybe not the best one, btrfs-show-super can show the 
incompat_flags in hex,
and we can check <kernel tree>/fs/btrfs/ctree.h for 
BTRFS_FEATURE_INCOMPAT_## for the bits
and calculate by hand...
(Would it be better to add human readable output for btrfs-show-super?)

Thanks,
Qu
>
>
> 2014-09-23 15:38 GMT+02:00 Austin S Hemmelgarn <ahferroin7@gmail.com>:
>> Well, running 'mkfs.btrfs -O list-all' with 3.16 btrfs-progs gives the following list of features:
>> mixed-bg                - mixed data and metadata block groups
>> extref                  - increased hard-link limit per file to 65536
>> raid56                  - raid56 extended format
>> skinny-metadata         - reduced size metadata extent refs
>> no-holes                - no explicit hole extents for files
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

