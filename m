Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44766 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754674AbeEaLya (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 May 2018 07:54:30 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A5869AEA1
        for <linux-btrfs@vger.kernel.org>; Thu, 31 May 2018 11:54:29 +0000 (UTC)
Date: Thu, 31 May 2018 13:51:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Use symbolic names for read ahead behavior
Message-ID: <20180531115144.GQ3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1525969331-18066-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1525969331-18066-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 10, 2018 at 07:22:11PM +0300, Nikolay Borisov wrote:
> Presently btrfs-progs haven't pulled the enum defining the symbolic
> names of read ahead constants. This commit adds the enum and
> simultaneously converts all usages to respective symbolic name.
> No functional change, just making the code human readable.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Applied, thanks.
