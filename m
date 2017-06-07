Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39342 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750868AbdFGHeL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 03:34:11 -0400
Subject: Re: [PATCH 6/8] btrfs: remove redundant parameters from
 btrfs_bio_alloc
To: David Sterba <dsterba@suse.com>
References: <cover.1496422340.git.dsterba@suse.com>
 <174c51230cae682e9f6c2c237833da89a1d2b6ab.1496422340.git.dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <14e19611-b629-a909-20c9-9309e0425368@oracle.com>
Date: Wed, 7 Jun 2017 15:40:16 +0800
MIME-Version: 1.0
In-Reply-To: <174c51230cae682e9f6c2c237833da89a1d2b6ab.1496422340.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/03/17 00:58, David Sterba wrote:
> All callers pass gfp_flags=GFP_NOFS and nr_vecs=BIO_MAX_PAGES.

  The line (in the other thread) mentioning the reason to remove
   __GFP_HIGH can go into the commit log here.


> -	bio = btrfs_bio_alloc(bdev, sector, BIO_MAX_PAGES,
> -			GFP_NOFS | __GFP_HIGH);
> +	bio = btrfs_bio_alloc(bdev, sector);

Thanks, Anand
