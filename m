Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48326 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbaHZJwp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Aug 2014 05:52:45 -0400
Message-ID: <53FC58E4.4050600@oracle.com>
Date: Tue, 26 Aug 2014 17:52:36 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/3] btrfs-progs: remove full /dev scanning
References: <53F51F4D.2090203@redhat.com>
In-Reply-To: <53F51F4D.2090203@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  Apparently we don't need -d option at all. The libblkid does
  cover both udev and /proc/partitions.

  ----
  EVALUATE=<methods>
    Defines LABEL and UUID evaluation method(s). Currently, the libblkid 
library supports "udev" and "scan" methods. More than one methods may be 
specified in a comma separated list. Default is "udev,scan". The "udev" 
method uses udev /dev/disk/by-* symlinks and the "scan" method scans all 
block devices from the /proc/partitions file.
  ----

  We could mark -d option as deprecated (in btrfs dev scan and
  btrfs fi show) or if agreed I would prefer totally removal.
  That will clean up the code quite nicely.

Thanks, Anand


On 21/08/2014 06:21, Eric Sandeen wrote:
> btrfs fileystem show and btrfs device scan today both have
> the "-d" option to scan everything under /dev.  But we also
> have a mechanism to scan everything in /proc/partitions, which
> should always be sufficient.
>
> If anyone knows why we'd find something deep under /dev but
> not in /proc/partitions, speak now or forever hold your peace...
>
> Tested this by running through a matrix of -d, -m, or "" args
> for show/scan, for a 2-device fs, with and without a symlinked
> device, with and without a symlinked mountpoint.  All output was
> identical.
>
> Thanks,
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
