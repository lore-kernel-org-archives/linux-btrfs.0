Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:54089 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757924Ab3CZHph (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 03:45:37 -0400
Message-ID: <51515226.9010509@profihost.ag>
Date: Tue, 26 Mar 2013 08:45:42 +0100
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: No space left on device (28)
References: <20130321190249.30044.79438@localhost.localdomain> <514B62A4.1030201@profihost.ag> <5F36F35C-39BE-4244-B8FB-A80EC2B06D48@profihost.ag> <514C4A8C.90607@profihost.ag> <20130322135322.GB1955@localhost.localdomain> <514C6319.7030400@profihost.ag> <20130322155453.GD1955@localhost.localdomain> <514CAC8D.7010409@profihost.ag> <20130322204932.GE1955@localhost.localdomain> <514CC52B.1000201@profihost.ag> <20130325201426.GG1955@localhost.localdomain>
In-Reply-To: <20130325201426.GG1955@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

output here:
[  590.546162] returning enospc, space_info 3, size 0 reserved 0, flush 
2, flush_state 7  dumping space info
[  590.548280] space_info 4 has 6439292928 free, is full
[  590.548283] space_info total=25748307968, used=19308916736, pinned=0, 
reserved=32768, may_use=6438354944, readonly=65536
[  590.550147] returning enospc, space_info 3, size 0 reserved 0, flush 
2, flush_state 7  dumping space info
[  590.552264] space_info 4 has 6439284736 free, is full
[  590.552267] space_info total=25748307968, used=19308916736, pinned=0, 
reserved=40960, may_use=6438354944, readonly=65536
[  590.554141] returning enospc, space_info 3, size 0 reserved 0, flush 
2, flush_state 7  dumping space info
[  590.556258] space_info 4 has 6439284736 free, is full
[  590.556261] space_info total=25748307968, used=19308916736, pinned=0, 
reserved=40960, may_use=6438354944, readonly=65536
[  591.145255] returning enospc, space_info 3, size 0 reserved 0, flush 
2, flush_state 7  dumping space info
[  591.147373] space_info 4 has 6439235584 free, is full
[  591.147375] space_info total=25748307968, used=19308916736, pinned=0, 
reserved=90112, may_use=6438354944, readonly=65536
[  595.560257] returning enospc, space_info 3, size 0 reserved 0, flush 
2, flush_state 7  dumping space info
[  595.562390] space_info 4 has 6439120896 free, is full
[  595.562393] space_info total=25748307968, used=19309047808, pinned=0, 
reserved=73728, may_use=6438297600, readonly=65536

Am 25.03.2013 21:14, schrieb Josef Bacik:
> On Fri, Mar 22, 2013 at 02:55:07PM -0600, Stefan Priebe wrote:
>> Hi Jsoef,
>>
>> thanks!
>
> Ok I don't think the thing I just fixed will make any difference for you so
> here's another debug patch, just apply it on top of what I've already sent you
> and re-run and give me the dmesg again.  Thanks,
>
> Josef
>
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index aabaea6..bf6433f 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4162,7 +4162,11 @@ out:
>   	}
>   	if (flushing) {
>   		if (ret == -ENOSPC) {
> -			printk(KERN_ERR "returning enospc, dumping space info\n");
> +			spin_lock(&block_rsv->lock);
> +			printk(KERN_ERR "returning enospc, space_info %u, size %Lu reserved %Lu, "
> +			       "flush %d, flush_state %d  dumping space info\n", block_rsv->type,
> +			       block_rsv->size, block_rsv->reserved, flush, flush_state);
> +			spin_unlock(&block_rsv->lock);
>   			dump_space_info(space_info, 0, 0);
>   		}
>
>
