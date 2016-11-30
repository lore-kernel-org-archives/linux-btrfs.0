Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37153 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932242AbcK3OvF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 09:51:05 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3835DAAC8
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Nov 2016 14:51:04 +0000 (UTC)
Date: Wed, 30 Nov 2016 15:51:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 2/2] btrfs-progs: Remove duplicate printfs in
 warning_trace()/assert_trace()
Message-ID: <20161130145100.GN12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161129162514.28453-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161129162514.28453-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 29, 2016 at 10:25:14AM -0600, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Code reduction. Call warning_trace from assert_trace in order to
> reduce the printf's used. Also, trace variable in warning_trace()
> is not required because it is already handled by BTRFS_DISABLE_BACKTRACE.

This drops the distinction between BUG_ON and WARN_ON but I'm not sure
we need it. Patch applied, thanks.
