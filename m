Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55705 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753843AbbI1BW3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Sep 2015 21:22:29 -0400
Subject: Re: mkfs.btrfs(8) --data outdated?
To: Juan Francisco Cantero Hurtado <iam@juanfra.info>,
        <linux-btrfs@vger.kernel.org>
References: <mu9jpv$l25$1@ger.gmane.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56089651.6080803@cn.fujitsu.com>
Date: Mon, 28 Sep 2015 09:22:25 +0800
MIME-Version: 1.0
In-Reply-To: <mu9jpv$l25$1@ger.gmane.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Juan Francisco Cantero Hurtado wrote on 2015/09/27 22:33 +0200:
> kernel: 4.1.7
> btrfs-progs: 4.2
>
> mkfs.btrfs(8) man page says:
> -d|--data <type>
>      Specify how the data must be spanned across the devices
>      specified. Valid values are raid0, raid1, raid5, raid6,
>      raid10 or single.
>
> $ sudo mkfs.btrfs -d dup -m dup -M -O no-holes -f /dev/sdb1
> SMALL VOLUME: forcing mixed metadata/data groups
> btrfs-progs v4.2
> See http://btrfs.wiki.kernel.org for more information.
>
> Label:              (null)
> UUID:               29de8c3e-92da-4fe1-aa31-830c1068f532
> Node size:          4096
> Sector size:        4096
> Filesystem size:    3.00GiB
> Block group profiles:
>    Data+Metadata:    DUP             161.56MiB
>    System:           DUP              12.00MiB
> SSD detected:       no
> Incompat features:  mixed-bg, extref, skinny-metadata, no-holes
> Number of devices:  1
> Devices:
>     ID        SIZE  PATH
>      1     3.00GiB  /dev/sdb1
>
>
> The man page doesn't mention the option "-d dup". Am I missing something
> or the man page is outdated?. The partition will contain two copies of
> the data blocks?

-d dup is possible if and only if for mixed block group case, which 
require data and metadata shares the same profile.

And yes, the partition will contains two copies of mixed chunk on disk, 
which has data and metadata in it.
(Btrfs will store data and metadata into different chunks if not using 
mixed block groups)

We're planning to add support for -d dup on single disk case, and will 
update man page at that time.

Thanks,
Qu

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
