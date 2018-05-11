Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39313 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751406AbeEKKkL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 06:40:11 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8BF1EACF0
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 10:40:10 +0000 (UTC)
Date: Fri, 11 May 2018 12:37:32 +0200
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 1/3] btrfs: Move btrfs_check_super_valid() to avoid
 forward declaration
Message-ID: <20180511103732.GU6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180511053527.28378-1-wqu@suse.com>
 <20180511053527.28378-2-wqu@suse.com>
 <20180511093654.GO6649@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180511093654.GO6649@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2018 at 11:36:54AM +0200, David Sterba wrote:
> On Fri, May 11, 2018 at 01:35:25PM +0800, Qu Wenruo wrote:
> > Just move btrfs_check_super_valid() before its single caller to avoid
> > forward declaration.
> 
> Please don't move functions just to get rid of the forward declarations.
> 
> Moving functions to make them static or if they're in a wrong .c is OK,
> but the extra forward declaration is not that bad and moving code
> without any change just pollutest the git history. I'll drop the patch,
> sorry.

Hm, OK I now see why you did it. Fixing up the order of the related
static functions would need new forward declarations, so I'll apply the
patch after all.
