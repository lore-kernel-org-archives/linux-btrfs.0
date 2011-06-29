From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: [PATCH] Btrfs: fix error check of btrfs_lookup_dentry()
Date: Wed, 29 Jun 2011 09:15:50 +0900
Message-ID: <4E0A6EB6.8060700@jp.fujitsu.com>
References: <201106280334.AA00027@T-ITOH1.jp.fujitsu.com> <4E09E39F.1070408@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E09E39F.1070408@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

(2011/06/28 23:22), Josef Bacik wrote:
> On 06/27/2011 11:34 PM, Tsutomu Itoh wrote:
>> The return value of btrfs_lookup_dentry is checked so that
>> the panic such as illegal address reference should not occur.
>>
>> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> 
> Nack, please fix btrfs_lookup_dentry to return ERR_PTR(-ENOENT) if it
> doesn't find something.  Thanks,

OK, I will repost soon.

Thanks,
Tsutomu

