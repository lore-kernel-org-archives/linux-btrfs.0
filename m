Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:42940 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaF0Qa1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 12:30:27 -0400
Message-ID: <53AD9D1A.4050703@libero.it>
Date: Fri, 27 Jun 2014 18:34:34 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Zhe Zhang <zhe.zhang.research@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [Question] Btrfs on iSCSI device
References: <CAMXuLLrhMv82LPveRemDU_v_Kru2US6sKVn377gS3t9p-VFrag@mail.gmail.com>
In-Reply-To: <CAMXuLLrhMv82LPveRemDU_v_Kru2US6sKVn377gS3t9p-VFrag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
On 06/27/2014 05:44 PM, Zhe Zhang wrote:
> Hi,
> 
> I setup 2 Linux servers to share the same device through iSCSI. Then I
> created a btrfs on the device. Then I saw the problem that the 2 Linux
> servers do not see a consistent file system image.
> 
> Details:
> -- Server 1 running kernel 2.6.32, server 2 running 3.2.1
> -- Both running btrfs v0.20-rc1
> -- Server 2 has device /dev/vdc, exposed as iSCSI target
>  -- Server 1 mounts the device as /dev/sda
> -- Server 1 'mount /dev/sda /mnt/btrfs'; server 2 'mount /dev/vdc /mnt/btrfs',
>  -- When server 1 'touch /mnt/btrfs/foo', server 2 doesn't see any
> file under /mnt/btrfs
> -- I created /mnt/btrfs/foo on server 2 as well; then I added some
> content from both server 1 and server 2 to /mnt/btrfs/foo
> -- After that each server sees the content it adds, but not the
> content from the other server
> -- Both server 'umount /mnt/btrfs', and mount it again
> -- Then both servers see /mnt/btrfs/foo with the content added from
> server 2 (I guess it's because server 2 created the foo file later
> than server 1).
> 
> I did a similar test on ext4 and both servers see a consistent image
> of the file system. When server 1 creates a foo file server 2
> immediately sees it.
> 
> Is this how btrfs is supposed to work?

I don't think that it is possible to mount the _same device_ at the _same time_ on two different machines. And this doesn't depend by the filesystem.

The fact that you see it working, I suspect that is is casual.

When I tried this (same scsi HD connected to two machines), I had to ensure that the two machines never accessed to the HD at the same time.

> 
> Thanks,
> 
> Zhe
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
