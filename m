Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40616 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbaL2Qu6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 11:50:58 -0500
Date: Mon, 29 Dec 2014 17:50:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Capitalize elements in enum for improve readability.
Message-ID: <20141229165055.GM6490@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5497F2EE.1010906@jp.fujitsu.com>
 <5497F487.20109@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5497F487.20109@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 22, 2014 at 07:37:59PM +0900, Satoru Takeuchi wrote:
> --- a/send-utils.h
> +++ b/send-utils.h
> @@ -37,10 +37,10 @@ extern "C" {
>  #define BTRFS_COMPAT_SEND_NO_UUID_TREE 1
>  
>  enum subvol_search_type {
> -	subvol_search_by_root_id,
> -	subvol_search_by_uuid,
> -	subvol_search_by_received_uuid,
> -	subvol_search_by_path,
> +	SUBVOL_SEARCH_BY_ROOT_ID,
> +	SUBVOL_SEARCH_BY_UUID,
> +	SUBVOL_SEARCH_BY_RECEIVED_UUID,
> +	SUBVOL_SEARCH_BY_PATH,

send-utils.h is part of public API, so this would have to be changed in
a backward compatible way, but the current library API is underdesigned
so I don't think this patch will help.

Getting the library right is on the todo list but it will take some time
and some reorganization of sources will have to take place before that.
