Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35737 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbaDDPxr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Apr 2014 11:53:47 -0400
Date: Fri, 4 Apr 2014 17:53:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] Btrfs: send, add calculate data size flag to allow
 for progress estimation
Message-ID: <20140404155346.GX29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1396624841-1363-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1396624841-1363-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 04, 2014 at 04:20:41PM +0100, Filipe David Borba Manana wrote:
> @@ -4307,6 +4348,22 @@ out:
>  	return num_read;
>  }
>  
> +static int send_total_data_size(struct send_ctx *sctx, u64 data_size)
> +{
> +	int ret;
> +
> +	ret = begin_cmd(sctx, BTRFS_SEND_C_TOTAL_DATA_SIZE);
> +	if (ret < 0)
> +		goto out;
> +
> +	TLV_PUT_U64(sctx, BTRFS_SEND_A_SIZE, data_size);
> +	ret = send_cmd(sctx);
> +
> +tlv_put_failure:
> +out:
> +	return ret;
> +}
> +
>  /*
>   * Send a clone command to user space.
>   */
> --- a/fs/btrfs/send.h
> +++ b/fs/btrfs/send.h
> @@ -87,6 +87,7 @@ enum btrfs_send_cmd {
>  
>  	BTRFS_SEND_C_END,
>  	BTRFS_SEND_C_UPDATE_EXTENT,
> +	BTRFS_SEND_C_TOTAL_DATA_SIZE,

Though it is a simple modification, it changes the existing send
protocol.

The unpatched receiver would fail (it has a lower value of
__BTRFS_SEND_C_MAX), so it could work even without revving the protocol.
But, it's not the cleanest way.

There's a number of defficiencies found in v1 protocol, see
https://btrfs.wiki.kernel.org/index.php/Design_notes_on_Send/Receive#Send_stream_v2_draft

I would rather see a proper v2 revision instead of relying on the fact
that current implementation will deal with the change.

>  	__BTRFS_SEND_C_MAX,
>  };
>  #define BTRFS_SEND_C_MAX (__BTRFS_SEND_C_MAX - 1)
