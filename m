Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52439 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751123AbdIMPUl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Sep 2017 11:20:41 -0400
Date: Wed, 13 Sep 2017 17:19:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: prevent to set invalid default subvolid
Message-ID: <20170913151910.GM29043@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <87mv60vxr7.wl-satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87mv60vxr7.wl-satoru.takeuchi@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 12, 2017 at 10:42:52PM +0900, Satoru Takeuchi wrote:
> `btrfs sub set-default` succeeds to set an ID which isn't corresponding to any
> fs/file tree. If such the bad ID is set to a filesystem, we can't mount this
> filesystem without specifying `subvol` or `subvolid` mount options.
> 
> Signed-off-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>

Fixes: 6ef5ed0d386b
Reviewed-by: David Sterba <dsterba@suse.com>
