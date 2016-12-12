Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58637 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752944AbcLLOMu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Dec 2016 09:12:50 -0500
Date: Mon, 12 Dec 2016 15:12:43 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: cow_file_range() num_bytes and disk_num_bytes
 are same
Message-ID: <20161212141243.GS12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161206044309.3450-1-anand.jain@oracle.com>
 <20161206044309.3450-3-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161206044309.3450-3-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 06, 2016 at 12:43:08PM +0800, Anand Jain wrote:
> This patch deletes local variable disk_num_bytes as its value
> is same as num_bytes in the function cow_file_range().
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
