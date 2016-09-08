Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35316 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758744AbcIHJoF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Sep 2016 05:44:05 -0400
Date: Thu, 8 Sep 2016 11:42:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] btrfs-progs: receive: Introduce option to exam
 and dump send stream
Message-ID: <20160908094228.GK16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160907002935.8539-1-quwenruo@cn.fujitsu.com>
 <20160907002935.8539-3-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160907002935.8539-3-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 07, 2016 at 08:29:34AM +0800, Qu Wenruo wrote:
> @@ -1265,19 +1274,37 @@ int cmd_receive(int argc, char **argv)
>  		}
>  	}
>  
> -	ret = do_receive(&r, tomnt, realmnt, receive_fd, max_errors);
> +	if (dump) {
> +		struct btrfs_dump_send_args dump_args;
> +
> +		dump_args.root_path = malloc(PATH_MAX);
> +		dump_args.root_path[0] = '.';
> +		dump_args.root_path[1] = '\0';
> +		dump_args.full_subvol_path = malloc(PATH_MAX);

Please always check malloc return values. I'm fixing this for now.

> +		dump_args.full_subvol_path[0] = '.';
> +		dump_args.full_subvol_path[1] = '\0';
> +		ret = btrfs_read_and_process_send_stream(receive_fd,
> +				&btrfs_print_send_ops, &dump_args, 0, 0);
> +		if (ret < 0)
> +			error("failed to dump the send stream: %s",
> +			      strerror(-ret));
> +	} else {
> +		ret = do_receive(&r, tomnt, realmnt, receive_fd, max_errors);
> +	}
> +
>  	if (receive_fd != fileno(stdin))
>  		close(receive_fd);
