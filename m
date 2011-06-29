From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH v4 3/7] btrfs: state information for readahead
Date: Wed, 29 Jun 2011 16:58:16 -0400
Message-ID: <4E0B91E8.2020704@redhat.com>
References: <cover.1309375866.git.sensille@gmx.net> <700f178eaaca9af9d54f2ebcc939b9acf745a832.1309375866.git.sensille@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <700f178eaaca9af9d54f2ebcc939b9acf745a832.1309375866.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/29/2011 04:10 PM, Arne Jansen wrote:
> Add state information for readahead to btrfs_fs_info and btrfs_device
> 
> Changes v2:
>  - don't wait in radix_trees
>  - add own set of workers for readahead
> 

You can add

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
