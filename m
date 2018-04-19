Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54020 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752776AbeDSMo1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 08:44:27 -0400
Date: Thu, 19 Apr 2018 14:41:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Howard McLauchlan <hmclauchlan@fb.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        kernel-team@fb.com
Subject: Re: [PATCH v2 1/3] btrfs: clean up le_bitmap_{set, clear}()
Message-ID: <20180419124154.GA21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180419010237.30960-1-hmclauchlan@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180419010237.30960-1-hmclauchlan@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 18, 2018 at 06:02:35PM -0700, Howard McLauchlan wrote:
> le_bitmap_set() is only used by free-space-tree, so move it there and
> make it static. le_bitmap_clear() is not used, so remove it.
> 
> Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>

Added to the queue, thanks.
