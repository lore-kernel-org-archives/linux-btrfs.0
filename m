Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:60476 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaF0RyG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 13:54:06 -0400
Received: by mail-pd0-f174.google.com with SMTP id y10so4676883pdj.33
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Jun 2014 10:54:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMXuLLrhMv82LPveRemDU_v_Kru2US6sKVn377gS3t9p-VFrag@mail.gmail.com>
References: <CAMXuLLrhMv82LPveRemDU_v_Kru2US6sKVn377gS3t9p-VFrag@mail.gmail.com>
Date: Fri, 27 Jun 2014 10:54:05 -0700
Message-ID: <CAN05THSmkeikPp1h-O_c=8n1gp8GoY-ocui_Lc15kbT_O9rp+g@mail.gmail.com>
Subject: Re: [Question] Btrfs on iSCSI device
From: ronnie sahlberg <ronniesahlberg@gmail.com>
To: Zhe Zhang <zhe.zhang.research@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

You can't do that, it doesn't work.

The only way you can access the same block device from multiple hosts
at the same time is if you use a cluster filesystem.
Using a non-cluster filesystem like this is highly unsafe and will
very likely quickly lead to total dataloss.

(
I am a little bit surprised that you managed to mount ext4 from both
hosts at the same time.
ext4 SHOULD have put a SCSI [PERSISTENT] RESERVATION on the disk on
the first mount
in order to prevent a second host from accessing the device.

Does btrfs put a reservation on the underlying SCSI device when it
mounts the filesystem?
If not, it should.
)

If you want to share data read/write across multiple hosts you should
either use a file server and a network file system such as NFS or
CIFS.
Or if you want to use block/iSCSI, then you must use a proper cluster
filesystem of which there are several available for linux.


 regards
ronnie sahlberg


On Fri, Jun 27, 2014 at 8:44 AM, Zhe Zhang <zhe.zhang.research@gmail.com> wrote:
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
>
> Thanks,
>
> Zhe
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
