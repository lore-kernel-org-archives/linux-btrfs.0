Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35993 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750930AbdEPLYa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 07:24:30 -0400
Date: Tue, 16 May 2017 13:23:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add mount umount logs
Message-ID: <20170516112332.GC4065@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170516084149.10147-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170516084149.10147-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 16, 2017 at 04:41:49PM +0800, Anand Jain wrote:
> By looking at the logs we should be able to know when the FS was
> mounted and unmounted and the options used, so to help forensic
> investigations.

Could be a useful feature, but you're adding it to the wrong layer.
