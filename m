Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37867 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1946847AbdDYOVH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Apr 2017 10:21:07 -0400
Date: Tue, 25 Apr 2017 16:21:02 +0200
From: David Sterba <dsterba@suse.cz>
To: clm@fb.com
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PULL] Btrfs, qgroup message level adjustment, for 4.11-rc8
Message-ID: <20170425142102.GP22319@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1492598707.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1492598707.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 19, 2017 at 12:51:03PM +0200, David Sterba wrote:
> Hi,
> 
> a single-patch pull request, the qgroup use can trigger an underflow warning
> frequently. The warning is for debugging and should not be in the final release
> of 4.11 as we won't be able to fix it.

Ping?
