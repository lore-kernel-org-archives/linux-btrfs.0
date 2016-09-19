Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41924 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752020AbcISRHA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 13:07:00 -0400
Date: Mon, 19 Sep 2016 19:05:03 +0200
From: David Sterba <dsterba@suse.cz>
To: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH]btrfs-progs: Add fast,slow symlinks and fifo types to
 convert test
Message-ID: <20160919170503.GL16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160915093407.GA17835@fedori>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160915093407.GA17835@fedori>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 15, 2016 at 11:34:07AM +0200, Lakshmipathi.G wrote:
> +		slow_symlink)
> +			for num in $(seq 1 $DATASET_SIZE); do
> +				fname64=`date +%s | sha256sum | cut -f1 -d'-'`

Do you need to generate the date and sha all the time?

> +				run_check $SUDO_HELPER touch $dirpath/$fname64
> +				run_check $SUDO_HELPER ln -s $dirpath/$fname64 $dirpath/slow_slink.$num
> +			done
> +			;;
>  	esac
>  }
>  
>  populate_fs() {
>  
> -        for dataset_type in 'small' 'hardlink' 'symlink' 'brokenlink' 'perm' 'sparse' 'acls'; do
> +        for dataset_type in 'small' 'hardlink' 'fast_symlink' 'brokenlink' 'perm' 'sparse' 'acls' 'fifo' 'slow_symlink'; do
>  		generate_dataset "$dataset_type"
>  	done
>  }
> -- 
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
