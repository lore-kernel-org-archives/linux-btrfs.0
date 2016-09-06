Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40163 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933062AbcIFRmL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Sep 2016 13:42:11 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9DAABAB1A
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Sep 2016 17:42:09 +0000 (UTC)
Date: Tue, 6 Sep 2016 19:40:38 +0200
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 15/31] btrfs: call functions that overwrite their root
 parameter with fs_info
Message-ID: <20160906174038.GG16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
 <1466806524-27508-16-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1466806524-27508-16-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Fri, Jun 24, 2016 at 06:15:08PM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> There are 11 functions that accept a root parameter and immediately
> overwrite it.  We can pass those an fs_info pointer instead.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

including this patch, the rest of the series hasn't been merged in the
last cycle.

The first batch of 4.9 patches is done, please refresh the series on top
of that. Branch misc-4.9 in
http://repo.or.cz/linux-2.6/btrfs-unstable.git or
https://github.com/kdave/btrfs-devel . Thanks.
