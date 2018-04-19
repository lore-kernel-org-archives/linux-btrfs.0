Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46914 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752617AbeDSO5G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 10:57:06 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BC636ACC2
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 14:57:05 +0000 (UTC)
Date: Thu, 19 Apr 2018 16:54:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/6] btrfs: Use list_empty instead of list_empty_careful
Message-ID: <20180419145433.GE21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1524123999-4220-1-git-send-email-nborisov@suse.com>
 <1524123999-4220-4-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1524123999-4220-4-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 19, 2018 at 10:46:37AM +0300, Nikolay Borisov wrote:
> list_empty_careful usually is a signal of something tricky going on. Its
> usage in btrfs is actually not needed since both lists it's used on are
> local to a function and cannot be modified concurrently. So switch to
> plain list_empty. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
