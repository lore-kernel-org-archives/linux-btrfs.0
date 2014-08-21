Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23302 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbaHUIle (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Aug 2014 04:41:34 -0400
Message-ID: <53F5B18B.1030801@oracle.com>
Date: Thu, 21 Aug 2014 16:44:59 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/3] btrfs-progs: remove full /dev scanning
References: <53F51F4D.2090203@redhat.com>
In-Reply-To: <53F51F4D.2090203@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  A long time back there was an attempt to remove it but
  this avoided it. Pls ref to the link in this discussion.

  https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg27272.html

Thanks, Anand

On 08/21/2014 06:21 AM, Eric Sandeen wrote:
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
