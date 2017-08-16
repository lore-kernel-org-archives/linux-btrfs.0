Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53055 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752362AbdHPOID (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 10:08:03 -0400
Date: Wed, 16 Aug 2017 16:06:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2] btrfs: use appropriate define for the fsid
Message-ID: <20170816140639.GG2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170727152103.GM2866@twin.jikos.cz>
 <20170729095009.1361-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170729095009.1361-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 29, 2017 at 05:50:09PM +0800, Anand Jain wrote:
> Though BTRFS_FSID_SIZE and BTRFS_UUID_SIZE or of same size,
> for the purpose of doing it correctly use BTRFS_FSID_SIZE instead.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
