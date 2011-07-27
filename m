From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 1/1] btrfs: btrfs_calc_avail_data_space cope with no read/write
 devices
Date: Wed, 27 Jul 2011 10:25:17 -0400
Message-ID: <4E301FCD.6060202@redhat.com>
References: <1311764491-5687-1-git-send-email-apw@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Andy Whitcroft <apw@canonical.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1311764491-5687-1-git-send-email-apw@canonical.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/27/2011 07:01 AM, Andy Whitcroft wrote:
> When we mount a btrfs filesystem from read-only media there will be no
> read/write devices; for example mounting an SD card with its lock enabled.
> This triggers an immediate BUG during mount:
> 
>   kernel BUG at .../fs/btrfs/super.c:984!
> 
> This is triggered by statfs when calculating the free space in the
> filesytem.  We bug if the number of read/write devices is 0.
> 
> It seems more appropriate to indicate we have no writable space.  Note
> that this does make df return 0 free blocks on a read-only device.
> Whether that is reasonable is debatable.

No it's not, it's wrong.  We should just look at the devices in general
and not just the rw_devices.  We can still get the right info out, if
you mount a ext* fs ro you still get the right output from df.  Thanks,

Josef
