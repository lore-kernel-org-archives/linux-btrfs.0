Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58664 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752605AbdATSxI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jan 2017 13:53:08 -0500
Date: Fri, 20 Jan 2017 19:52:49 +0100
From: David Sterba <dsterba@suse.cz>
To: robbieko <robbieko@synology.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/6] Btrfs: incremental send, fix serval case failure
Message-ID: <20170120185249.GI11951@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1483604700-21017-1-git-send-email-robbieko@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1483604700-21017-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 05, 2017 at 04:24:54PM +0800, robbieko wrote:
> From: Robbie Ko <robbieko@synology.com>
> 
> Patch for fix btrfs incremental send.
> These patches base on v4.8.0-rc8

Is this a typo or did you really base the patches on 4.8-rc8? At the
moment we're nearing the v4.11 development cycle, so patches should be
eg. based on a recent 4.10-rc from the master branch. Let me know
privately if you need more information on the development cycle and
workflow.

> V3: Improve the change log

Please take Filipe's advice and comments seriously. Changelogs are
important part of the patches, namely for fixes that are not obvious and
fix corner cases. Writing good changelogs takes time to learn, you can
find examples in the log of send.c .
