Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44296 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968253AbdADPKM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Jan 2017 10:10:12 -0500
Date: Wed, 4 Jan 2017 16:09:55 +0100
From: David Sterba <dsterba@suse.cz>
To: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Corruption-framework: Include inode nlink
 field
Message-ID: <20170104150955.GY12081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170103153431.GA25465@fedori>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170103153431.GA25465@fedori>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 03, 2017 at 04:34:31PM +0100, Lakshmipathi.G wrote:
> Will include other fields, if this gets accepted.
> 
> Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
> ---
>  btrfs-corrupt-block.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
> index 16680df..64376ca 100644
> --- a/btrfs-corrupt-block.c
> +++ b/btrfs-corrupt-block.c
> @@ -309,6 +309,7 @@ enum btrfs_inode_field {
>  	BTRFS_INODE_FIELD_ISIZE,
>  	BTRFS_INODE_FIELD_NBYTES,
>  	BTRFS_INODE_FIELD_BAD,
> +	BTRFS_INODE_FIELD_NLINK,

This has to be before BTRFS_INODE_FIELD_BAD, as it's a not-so obvious
end of field sequence maker.
