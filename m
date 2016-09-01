Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49117 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934016AbcIAPdm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Sep 2016 11:33:42 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 86F37ABEC
        for <linux-btrfs@vger.kernel.org>; Thu,  1 Sep 2016 15:33:41 +0000 (UTC)
Date: Thu, 1 Sep 2016 17:32:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfsprogs: only install udev rules for udev >= 190
Message-ID: <20160901153219.GS16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <57C62FC0.6020206@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <57C62FC0.6020206@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 30, 2016 at 09:15:44PM -0400, Jeff Mahoney wrote:
> Prior to udev v190, there was no btrfs builtin helper.  Installing it on
> systems with an older udev will cause problems.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Applied, thanks.
