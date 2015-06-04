Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47380 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbbFDLP7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Jun 2015 07:15:59 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Z0T7g-0001Uc-Gk
	for linux-btrfs@vger.kernel.org; Thu, 04 Jun 2015 13:15:44 +0200
Received: from p4ff5830b.dip0.t-ipconnect.de ([79.245.131.11])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jun 2015 13:15:44 +0200
Received: from holger.hoffstaette by p4ff5830b.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jun 2015 13:15:44 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: [PATCH 1/3] btrfs: iterate over unused chunk space in FITRIM
Date: Thu, 4 Jun 2015 11:15:24 +0000 (UTC)
Message-ID: <pan.2015.06.04.11.15.24@googlemail.com>
References: <1433342874-7099-1-git-send-email-jeffm@suse.com>
	<1433342874-7099-2-git-send-email-jeffm@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 03 Jun 2015 10:47:52 -0400, jeffm wrote:

> This patch iterates over the unused chunk space and discards any regions
> that are unallocated, regardless of whether they were ever used.  This is
> a change for btrfs but is consistent with other file systems.
> ..
[snip]

This just gave me:

fs/btrfs/volumes.c: In function 'btrfs_shrink_device':
fs/btrfs/volumes.c:4148:31: warning: passing argument 1 of 'contains_pending_extent' from incompatible pointer type
   if (contains_pending_extent(trans, device, &start, len)) {
                               ^
fs/btrfs/volumes.c:1092:12: note: expected 'struct btrfs_transaction *' but argument is of type 'struct btrfs_trans_handle *'
 static int contains_pending_extent(struct btrfs_transaction *transaction,
            ^

because it changes the signature of contains_pending_extent():

> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 174f5e1..7fdde31 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1051,15 +1051,18 @@ out:
>  	return ret;
>  }
>  
> -static int contains_pending_extent(struct btrfs_trans_handle *trans,
> +static int contains_pending_extent(struct btrfs_transaction *transaction,
>  				   struct btrfs_device *device,
>  				   u64 *start, u64 len)

which conflicts with Filipe's patch on Tuesday called "Btrfs: check pending chunks
when shrinking fs to avoid corruption":

+		if (contains_pending_extent(trans, device, &start, len)) {

since trans (returned from start_transaction()) is a handle, not the tx itself.

ISTM that it should now pass trans->transaction instead..or something.

-h


