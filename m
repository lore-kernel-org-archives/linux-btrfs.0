Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33817 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbaJAL0I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Oct 2014 07:26:08 -0400
Date: Wed, 1 Oct 2014 13:26:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: force overwrite should wipe stale SB
Message-ID: <20141001112606.GO11436@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1409932284-30895-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1409932284-30895-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 05, 2014 at 11:51:24PM +0800, Anand Jain wrote:
> +static void wipe_existing_fs(int fd)
> +{
...
> +	blkid_probe_enable_partitions(pr, 1);
> +
> +	while (blkid_do_probe(pr) == 0)
> +		blkid_do_wipe(pr, 0);

Reported by a user on IRC, I verified it on one of my old test boxes.
The function is missing in older versions of blkid and causes comilation
errors:

    [CC]     utils.o
utils.c: In function ‘wipe_existing_fs’:
utils.c:705:3: warning: implicit declaration of function ‘blkid_do_wipe

utils.o: In function `wipe_existing_fs':
/labs/dsterba/btrfs-progs/utils.c:705: undefined reference to `blkid_do_wipe'
collect2: ld returned 1 exit status

blkid_do_wipe is from Novembe 2011, so nothing really new, but I'd still
like to keep the backward compatibility of btrfs-progs.  The
implementation of blkid_do_wipe uses some internal data so it's not
possible to simply copy the implementation. Maybe wiping the first
megabyte is enough.
