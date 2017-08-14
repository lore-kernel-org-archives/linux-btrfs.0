Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35353 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751125AbdHNHGn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 03:06:43 -0400
Subject: Re: [PATCH] btrfs: use BTRFS_FSID_SIZE for fsid
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20170813035830.18660-1-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <85a905b2-4000-4a7e-f1e1-5d65231d5dca@suse.com>
Date: Mon, 14 Aug 2017 10:06:40 +0300
MIME-Version: 1.0
In-Reply-To: <20170813035830.18660-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 13.08.2017 06:58, Anand Jain wrote:
> We have define for FSID size so use it.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

I like consistency!

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
