Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12515 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750767AbbJVEKw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Oct 2015 00:10:52 -0400
Subject: Re: [RFC PATCH 2/3] btrfs-progs: kernel based default features for
 mkfs
To: Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1445417149-804-1-git-send-email-anand.jain@oracle.com>
 <1445417149-804-2-git-send-email-anand.jain@oracle.com>
 <562756ED.1090302@cn.fujitsu.com> <56285367.6010705@oracle.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <562861AF.7000306@cn.fujitsu.com>
Date: Thu, 22 Oct 2015 12:10:23 +0800
MIME-Version: 1.0
In-Reply-To: <56285367.6010705@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Anand Jain wrote on 2015/10/22 11:09 +0800:
>
> Hi,
>
>   more details about this RFC as below..
>
>
>> So a user with old kernel won't be able to create a filesystem with
>> newer feature forever.
>
>   Thats not true. Here below is an example of the problem and fix
>   in action.
>
>> Maybe the user are just making btrfs for his or her newer kernel?
>
>   Yes. Thats still possible as below.
>
>
>
> [[current problem]]
>
> I am on 3.8 kernel which does not support the skinny-metadata feature.
> ---------
> # uname -r
> 3.8.13-98.4.1.el6uek.x86_64
> -------------
>
> Lets say customer upgraded the latest btrfs-progs as they wanted better
> cli interface, reporting and document which is only available in the
> latest btrfs-progs.
>
> As btrfs-progs is backward kernel compatible, they don't have to
> upgrade the kernel.
>
> But as skinny-metadata is part of the "mkfs default feature", thats get
> enabled by default during mkfs.

For real customer case, that's really a problem.
Customer is god, right?

But on the other hand, normally support team only provides support for 
their own product.
Here "product" may be their distribution or other software, but never 
any software customer build from source by themselves.

If customer want to upgrade btrfs-progs, they should use the repo from 
distribution, not compile by themselves.

And it will be the responsibility of backport team to backport needed 
features for kernel/btrfs-progs or change default features.

But unfortunately(or fortunately?), we are not backport team.

>
> ----------
> # mkfs.btrfs -f /dev/sdc
> btrfs-progs v4.2.2-7-g03cf344
> See http://btrfs.wiki.kernel.org for more information.
>
> Label:              (null)
> UUID:               bb85b156-35eb-49a5-be5a-512fec1abab4
> Node size:          16384
> Sector size:        4096
> Filesystem size:    3.00GiB
> Block group profiles:
>    Data:             single            8.00MiB
>    Metadata:         DUP             161.56MiB
>    System:           DUP              12.00MiB
> SSD detected:       no
> Incompat features:  extref, skinny-metadata         <-----
> Number of devices:  1
> Devices:
>     ID        SIZE  PATH
>      1     3.00GiB  /dev/sdc
> -------------------
>
> mount on the running kernel 3.8 fails, as there is no kernel support
> for skinny-metadata
> -----------
> # mount /dev/sdc /btrfs
> mount: wrong fs type, bad option, bad superblock on /dev/sdc,
>         missing codepage or helper program, or other error
>         In some cases useful info is found in syslog - try
>         dmesg | tail  or so
>
> BTRFS: couldn't mount because of unsupported optional features (100).
> btrfs: open_ctree failed
> ----------
>
> Customers need to upgrade the kernel also to mount this FS.
>
>
> [[current solution]]
>
> User must know that their running kernel does not support
> skinny metadata and disable features accordingly as below.
>
> ------------
> # mkfs.btrfs -f -O ^skinny-metadata /dev/sdc > /dev/null && mount
> /dev/sdc /btrfs
> # echo $?
> 0
> ------------
>
>
> [[problem with the current solution]]
>
> btrfs-progs is backward kernel compatible.
>
> But the default feature as set during mkfs is very btrfs-progs centric,
> and is not in sync with the current running kernel.
>
>
> [[new proposed, with the patch]]
>
> - the default-features that are not supported by the running kernel
>   are masked.
>
>   So now the default mkfs.btrfs and mount works. As progs finds that
>   kernel version is too old to support skinny-metadata and remotes is
>   from the default feature list.
>
> -------------------
> # uname -r
> 3.8.13-98.4.1.el6uek.x86_64
>
>
> # mkfs.btrfs -f /dev/sdc
> btrfs-progs v4.2.2-7-g03cf344
> See http://btrfs.wiki.kernel.org for more information.
>
> Label:              (null)
> UUID:               f2513ff0-6d94-4b6a-8bbf-ff53d343fa62
> Node size:          16384
> Sector size:        4096
> Filesystem size:    3.00GiB
> Block group profiles:
>    Data:             single            8.00MiB
>    Metadata:         DUP             161.56MiB
>    System:           DUP              12.00MiB
> SSD detected:       no
> Incompat features:  extref  <-----
> Number of devices:  1
> Devices:
>     ID        SIZE  PATH
>      1     3.00GiB  /dev/sdc
>
> # mount /dev/sdc /btrfs
> -------------------
>
>
> However as Qu pointed out if user wants to create FS with a feature that
> is not supported by running kernel. They still have the choice to enable
> it using -O option. as below. however they won't be able to mount it
> unless kernel is upgraded as well.
>
> -------
> # mkfs.btrfs -f -O skinny-metadata /dev/sdc
> btrfs-progs v4.2.2-7-g03cf344
> See http://btrfs.wiki.kernel.org for more information.
>
> Label:              (null)
> UUID:               30c018ab-3d2a-4acc-8287-3f28c5324fca
> Node size:          16384
> Sector size:        4096
> Filesystem size:    3.00GiB
> Block group profiles:
>    Data:             single            8.00MiB
>    Metadata:         DUP             161.56MiB
>    System:           DUP              12.00MiB
> SSD detected:       no
> Incompat features:  extref, skinny-metadata   <----
> Number of devices:  1
> Devices:
>     ID        SIZE  PATH
>      1     3.00GiB  /dev/sdc
>
> # mount /dev/sdc /btrfs
> mount: wrong fs type, bad option, bad superblock on /dev/sdc,
>         missing codepage or helper program, or other error
>         In some cases useful info is found in syslog - try
>         dmesg | tail  or so
> #
> ---------
>
> In nut shell this patch makes _mkfs and btrfs-convert default features_
> dynamically aligned with the running kernel.

Maybe just personal choice, I still prefer not to change default 
features, output warning should be good enough for such case,
due to the unreliableness of version check.

Thanks,
Qu

>
> Thanks, Anand
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
