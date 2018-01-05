Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38724 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752043AbeAEQvm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Jan 2018 11:51:42 -0500
Date: Fri, 5 Jan 2018 17:49:34 +0100
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4] Btrfs: add support for fallocate's zero range
 operation
Message-ID: <20180105164934.GR3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171103172037.7107-1-fdmanana@kernel.org>
 <20171104040747.8737-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171104040747.8737-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 04, 2017 at 04:07:47AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> This implements support the zero range operation of fallocate. For now
> at least it's as simple as possible while reusing most of the existing
> fallocate and hole punching infrastructure.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

FYI, I've added this patch to the rest of the 4.16 queue.
