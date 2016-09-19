Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46467 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750750AbcISRnp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 13:43:45 -0400
Date: Mon, 19 Sep 2016 19:41:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Vincent Batts <vbatts@hashbangbash.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: subvolume verbose delete flag
Message-ID: <20160919174149.GP16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160915191550.12371-1-vbatts@hashbangbash.com>
 <20160915191550.12371-2-vbatts@hashbangbash.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160915191550.12371-2-vbatts@hashbangbash.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 15, 2016 at 03:15:50PM -0400, Vincent Batts wrote:
> There was already the logic for verbose output, but the flag parsing did
> not include it.
> 
> Signed-off-by: Vincent Batts <vbatts@hashbangbash.com>

Applied, thanks. I wonder where the original argument got lost. In the
commit 2ed161bd281beca29feebebbc8c4227cc6e918c3 it to added to getopt
but inside cmd_subvol_create. I'll fix it as well.
