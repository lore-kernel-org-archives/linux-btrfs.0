Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50061 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933595AbdIYNav (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 09:30:51 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 16AAEAB9B
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Sep 2017 13:30:50 +0000 (UTC)
Date: Mon, 25 Sep 2017 15:29:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 08/10] btrfs: remove unused parameter in cow_file_range
Message-ID: <20170925132917.GD31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1503308630-6652-1-git-send-email-nborisov@suse.com>
 <1503308630-6652-9-git-send-email-nborisov@suse.com>
 <13b784de-e906-7334-8aae-39cb7ce8c85e@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <13b784de-e906-7334-8aae-39cb7ce8c85e@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 25, 2017 at 03:18:31PM +0300, Nikolay Borisov wrote:
> On 21.08.2017 12:43, Nikolay Borisov wrote:
> > The delalloc_end parameter was only passed to extent_clear_unlock_delalloc, but
> > since its usage was removed form that function let's also remove it from the
> > caller's parameter list.
> > 
> > Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
> ping, since most of the series has been merged but this one has been
> left out I assume it could have been missed.

https://marc.info/?l=linux-btrfs&m=150481210920815

Dependent change, so not merged.
