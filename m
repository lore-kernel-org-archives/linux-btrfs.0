From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 1/1] btrfs: btrfs_calc_avail_data_space cope with no read/write
 devices V2
Date: Mon, 01 Aug 2011 11:24:32 -0400
Message-ID: <4E36C530.5030003@redhat.com>
References: <1312205910-13053-1-git-send-email-apw@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Andy Whitcroft <apw@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1312205910-13053-1-git-send-email-apw@canonical.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/01/2011 09:38 AM, Andy Whitcroft wrote:
> When we mount a btrfs filesystem from read-only media there will be no
> read/write devices; for example mounting an SD card with its lock enabled.
> This triggers an immediate BUG during mount:
> 
>   kernel BUG at .../fs/btrfs/super.c:984!
> 
> This is triggered by statfs when calculating the free space in the
> filesytem.  We bug if the number of read/write devices is 0.
> 
> This check seems spurious as the information collected is valid regardless
> of whether the devices are read-only or not.  As the count is used to
> size the sort array it seems more correct to switch it to the number of
> open devices.
> 
> BugLink: http://bugs.launchpad.net/bugs/816770
> Signed-off-by: Andy Whitcroft <apw@canonical.com>

Acked-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
