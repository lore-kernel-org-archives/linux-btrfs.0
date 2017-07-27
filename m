Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40194 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750981AbdG0PWV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 11:22:21 -0400
Date: Thu, 27 Jul 2017 17:21:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: use appropriate define for the fsid
Message-ID: <20170727152103.GM2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170727110236.20232-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170727110236.20232-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 27, 2017 at 07:02:36PM +0800, Anand Jain wrote:
> Though BTRFS_FSID_SIZE and BTRFS_UUID_SIZE or of same size,
> for the purpose of doing it correctly use BTRFS_FSID_SIZE instead.

There are many more uses of fs_info::fsid and BTRFS_UUID_SIZE, can you
please fix them all in one go?
