Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60808 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757352AbcIOOHc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 10:07:32 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C1B6E7F6A4
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2016 14:07:31 +0000 (UTC)
Received: from [IPv6:::1] (ovpn03.gateway.prod.ext.phx2.redhat.com [10.5.9.3])
        by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u8FE7UvL027959
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2016 10:07:31 -0400
Subject: Re: mkfs+mount failure of small fs on ppc64
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <2210b649-c379-106a-2de4-923a0ce55593@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <e5b1dbda-c244-a550-0a58-443b17408d59@redhat.com>
Date: Thu, 15 Sep 2016 09:07:30 -0500
MIME-Version: 1.0
In-Reply-To: <2210b649-c379-106a-2de4-923a0ce55593@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9/13/16 4:44 PM, Eric Sandeen wrote:
> on ppc64, 4.7-rc kernel, git btrfs-progs, v4.7.2:
> 
> # truncate --size=500m testfile
> # ./mkfs.btrfs testfile
> # mkdir -p mnt
> # mount -o loop testfile mnt

Same failure on aarch64 if that makes it any more interesting.  ;)

# mount -o loop testfile mnt
mount: mount /dev/loop0 on /root/mnt failed: No space left on device

Sector size issue I guess, driven by page size.

-Eric

> btrfs-progs v4.7.2
> See http://btrfs.wiki.kernel.org for more information.
> 
> Label:              (null)
> UUID:               c531b759-a491-4c9f-a954-4787cea9106d
> Node size:          65536
> Sector size:        65536
> Filesystem size:    500.00MiB
> Block group profiles:
>   Data:             single            8.00MiB
>   Metadata:         DUP              32.00MiB
>   System:           DUP               8.00MiB
> SSD detected:       no
> Incompat features:  extref, skinny-metadata
> Number of devices:  1
> Devices:
>    ID        SIZE  PATH
>     1   500.00MiB  testfile
> 
> 
> # dmesg -c
> [   61.210287] loop: module loaded
> [   61.247105] BTRFS: device fsid a8d79cd0-977f-4b93-8410-246dc08b3683 devid 1 transid 5 /dev/loop0
> [   61.247391] BTRFS info (device loop0): disk space caching is enabled
> [   61.247397] BTRFS info (device loop0): has skinny extents
> [   61.270492] BTRFS info (device loop0): creating UUID tree
> [   61.312149] BTRFS warning (device loop0): failed to create the UUID tree: -28
> [   61.483028] BTRFS: open_ctree failed
> 
> 2nd mount works:
> 
> # mount -o loop testfile mnt
> # dmesg -c
> [   87.504564] BTRFS info (device loop0): disk space caching is enabled
> [   87.504579] BTRFS info (device loop0): has skinny extents
> [   87.506979] BTRFS info (device loop0): creating UUID tree
> 
> Any ideas?  This seems to have regressed since 3.9.1, but there are a couple
> other mkfs breakages in between, and my bisect was not fruitful.
> 
> Thanks,
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

