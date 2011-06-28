From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: fix error check of btrfs_lookup_dentry()
Date: Tue, 28 Jun 2011 10:22:23 -0400
Message-ID: <4E09E39F.1070408@redhat.com>
References: <201106280334.AA00027@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201106280334.AA00027@T-ITOH1.jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/27/2011 11:34 PM, Tsutomu Itoh wrote:
> The return value of btrfs_lookup_dentry is checked so that
> the panic such as illegal address reference should not occur.
> 
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>

Nack, please fix btrfs_lookup_dentry to return ERR_PTR(-ENOENT) if it
doesn't find something.  Thanks,

Josef
