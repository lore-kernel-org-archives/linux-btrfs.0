Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32325 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab3DVJ3S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 05:29:18 -0400
Message-ID: <51750363.5020604@oracle.com>
Date: Mon, 22 Apr 2013 17:31:15 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Alexander Block <ablock84@googlemail.com>
Subject: Re: [PATCH 2/2 V2] btrfs-progs: update generation_v2 in btrfs_update_root
In-Reply-To: <5174C7B9.8000802@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <5174C426.3030204@redhat.com>
 <5174C704.7040603@redhat.com>
 <5174C7B9.8000802@redhat.com>


>   	/*
> -	* If the btrfs-progs is newer and kernel is at
> -	* generation_v1 then we don't touch v2 items
> -	* otherwise when kernel is at same or greater
> -	* version compared with btrfs-progs then update
> -	* the needed
> -	*/
> -	old_size = btrfs_item_size_nr(l, slot);
> -	if (old_size >= sizeof(*item)) {
> -		btrfs_set_root_generation_v2(item,
> -			btrfs_root_generation(item));
> +	 * If this is the first time we update the root item which originated
> +	 * from an older kernel, we need to enlarge the item size to make room
> +	 * for the added fields.
> +	 */
> +	if (old_len < sizeof(*item)) {

  With this fix. when kernel is using v1 and btrfs-progs is
  using v2, the disk structure will be changed to v2 after
  running btrfs check. I would rather take a conservative
  approach, by maintaining kernel intended version.

  Thanks, Anand
