Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36184 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750771AbdCNMbU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 08:31:20 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 01EC0AAB9
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Mar 2017 12:31:19 +0000 (UTC)
Date: Tue, 14 Mar 2017 13:30:42 +0100
From: David Sterba <dsterba@suse.cz>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH v2] btrfs: Change qgroup_meta_rsv to 64bit
Message-ID: <20170314123042.GX14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170314102509.10648-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170314102509.10648-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 14, 2017 at 05:25:09AM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Using an int value is causing qg->reserved to become negative and
> exclusive -EDQUOT to be reached prematurely.

V1 had a reproducer, I think it's fine to keep it here so I'll copy it.

Reviewed-by: David Sterba <dsterba@suse.com>
