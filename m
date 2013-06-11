Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53142 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803Ab3FKPAz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Jun 2013 11:00:55 -0400
Date: Tue, 11 Jun 2013 17:00:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/5] Btrfs-progs: fix closing of devices
Message-ID: <20130611150052.GA7290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1370893895-24884-2-git-send-email-fdmanana@gmail.com>
 <1370894875-26129-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1370894875-26129-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 10, 2013 at 09:07:55PM +0100, Filipe David Borba Manana wrote:
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -1267,12 +1267,12 @@ static int close_all_devices(struct btrfs_fs_info *fs_info)
>  	while (!list_empty(list)) {
>  		device = list_entry(list->next, struct btrfs_device, dev_list);
>  		list_del_init(&device->dev_list);
> -		if (device->fd) {
> +		if (device->fd > 0) {

> -		device = kmalloc(sizeof(*device), GFP_NOFS);
> +		device = kzalloc(sizeof(*device), GFP_NOFS);
>  		if (!device)
>  			return -ENOMEM;
> -		device->total_ios = 0;

Can you please describe the incremental change between the two patches?
Why do you exclude fd == 0 ?

david
