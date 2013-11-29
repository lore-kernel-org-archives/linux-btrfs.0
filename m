Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19372 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab3K2IFT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Nov 2013 03:05:19 -0500
Message-ID: <52984AB4.2020806@oracle.com>
Date: Fri, 29 Nov 2013 16:05:08 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>
CC: linux-btrfs@vger.kernel.org, clm@fb.com,
        Alex Lyakas <alex.btrfs@zadarastorage.com>
Subject: Re: [PATCH] btrfs-progs: add options to sync filesystem after subvol
 delete
References: <1385657947-26145-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1385657947-26145-1-git-send-email-dsterba@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




> If the command with sync option finishes succesfully, the subvolume(s)
> deletion status is safely stored on the media.


> +	if (sync_mode == 1) {
> +		res = ioctl(fd, BTRFS_IOC_SYNC);
> +		if (res < 0) {
> +			fprintf(stderr,
> +				"ERROR: unable to sync after '%s': %s\n",
> +				path, strerror(e));
> +			ret = 1;
> +		}
> +	}
> +

generalized sync isn't too viable option in all production environment
as it would disturb the steady state performance in some environment.
