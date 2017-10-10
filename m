Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42166 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756504AbdJJRlH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 13:41:07 -0400
Date: Tue, 10 Oct 2017 19:39:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] Btrfs: compress_file_range() remove dead variable
 num_bytes
Message-ID: <20171010173922.GT3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171003150604.19596-1-nefelim4ag@gmail.com>
 <20171003150604.19596-2-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171003150604.19596-2-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 03, 2017 at 06:06:01PM +0300, Timofey Titovets wrote:
> Remove dead assigment of num_bytes
> 
> Also as num_bytes only used in will_compress block as
> copy of total_in just replace that with total_in and drop num_bytes entire
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Added to the queue.
