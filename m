Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54756 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751764AbeCEUfS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Mar 2018 15:35:18 -0500
Date: Mon, 5 Mar 2018 21:32:57 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: send: fix typo in TLV_PUT
Message-ID: <20180305203257.GD5942@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180303010549.4621-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180303010549.4621-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 02, 2018 at 06:05:49PM -0700, Liu Bo wrote:
> According to tlv_put()'s prototype, data and attrlen needs to be
> exchanged in the macro, but seems all callers are already aware of
> this misorder and are therefore not affected.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
