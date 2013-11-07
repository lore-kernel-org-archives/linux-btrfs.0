Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:53269 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab3KGKF1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Nov 2013 05:05:27 -0500
Message-ID: <527B65A2.3020703@giantdisaster.de>
Date: Thu, 07 Nov 2013 11:04:18 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
CC: jbacik@fusionio.com, zab@redhat.com, dsterba@suse.cz
Subject: Re: [PATCH 1/3] btrfs-progs: mechanism to fetch fsinfo from btrfs-control
 v3
In-Reply-To: <1383818503-29607-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1383818503-29607-1-git-send-email-anand.jain@oracle.com>

On Thu,  7 Nov 2013 18:01:41 +0800, Anand Jain wrote:
> +	*out_fslist = malloc(sz);
> +	if (*out_fslist == NULL) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +	memcpy(*out_fslist, fslist, sz);
> +	ret = 0;
> +out:
> +	free(fsargs_saved);
> +	close(fd);
> +	return 0;
> +}

return ret;


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
