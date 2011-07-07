From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: fix return value check of btrfs_alloc_path()
Date: Thu, 07 Jul 2011 11:03:30 -0400
Message-ID: <4E15CAC2.6000702@redhat.com>
References: <201107070931.AA00030@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201107070931.AA00030@T-ITOH1.jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/07/2011 05:31 AM, Tsutomu Itoh wrote:
> The return value check of btrfs_alloc_path() in several places is
> changed from BUG_ON() to error return.
>
> Signed-off-by: Tsutomu Itoh<t-itoh@jp.fujitsu.com>

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
