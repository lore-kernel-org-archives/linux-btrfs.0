Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36936 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751829AbdIGTLU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Sep 2017 15:11:20 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 00BFEAE9A
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Sep 2017 19:11:19 +0000 (UTC)
Date: Thu, 7 Sep 2017 21:09:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 06/10] btrfs: Remove unused parameter from check_direct_IO
Message-ID: <20170907190950.GH31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1503308630-6652-1-git-send-email-nborisov@suse.com>
 <1503308630-6652-7-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1503308630-6652-7-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 21, 2017 at 12:43:46PM +0300, Nikolay Borisov wrote:
> Introduced by 5a5f79b57069 ("Btrfs: allow unaligned DIO") and never used, 

The unaligned DIO -> buffered works as expected, so this parameter is
indeend redundant.

Reviewed-by: David Sterba <dsterba@suse.com>
