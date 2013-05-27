Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56046 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932103Ab3E0MMt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 May 2013 08:12:49 -0400
Date: Mon, 27 May 2013 14:12:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: Add missing free() against
 fs_info->super_copy
Message-ID: <20130527121247.GC28422@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1369491399-6769-1-git-send-email-fdmanana@gmail.com>
 <1369491399-6769-2-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1369491399-6769-2-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

please don't forget to mention what changed in a revised version

On Sat, May 25, 2013 at 03:16:39PM +0100, Filipe David Borba Manana wrote:
> @@ -228,6 +227,8 @@ out:
>  	free(chunk_root);
>  	free(dev_root);
>  	free(csum_root);
> +	if (fs_info)
> +		free(fs_info->super_copy);

free accepts NULL pointers and does nothing, so it's fine to do it as in
the first version.

>  	free(fs_info);
>  	return NULL;

otherwise ok. Thanks.

david
