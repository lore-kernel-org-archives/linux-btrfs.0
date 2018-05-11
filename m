Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35108 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751649AbeEKJje (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 05:39:34 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B530DADA1
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 09:39:32 +0000 (UTC)
Date: Fri, 11 May 2018 11:36:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 1/3] btrfs: Move btrfs_check_super_valid() to avoid
 forward declaration
Message-ID: <20180511093654.GO6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180511053527.28378-1-wqu@suse.com>
 <20180511053527.28378-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180511053527.28378-2-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2018 at 01:35:25PM +0800, Qu Wenruo wrote:
> Just move btrfs_check_super_valid() before its single caller to avoid
> forward declaration.

Please don't move functions just to get rid of the forward declarations.

Moving functions to make them static or if they're in a wrong .c is OK,
but the extra forward declaration is not that bad and moving code
without any change just pollutest the git history. I'll drop the patch,
sorry.
