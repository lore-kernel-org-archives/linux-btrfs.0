Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37007 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752163AbeDJQVs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Apr 2018 12:21:48 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3B801ADC1
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Apr 2018 16:21:47 +0000 (UTC)
Date: Tue, 10 Apr 2018 18:19:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [RFC PATCH 1/8] btrfs: use iocb for __btrfs_buffered_write
Message-ID: <20180410161918.GG2817@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171117174456.13393-1-rgoldwyn@suse.de>
 <20171117174456.13393-2-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171117174456.13393-2-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 17, 2017 at 11:44:47AM -0600, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Preparatory patch. It reduces the arguments to __btrfs_buffered_write
> to follow buffered_write() style.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

I got pointed to this patch that it could be applied independently, so
I'm adding it to btrfs queue.
