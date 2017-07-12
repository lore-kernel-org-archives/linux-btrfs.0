Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39426 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753452AbdGLVyN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 17:54:13 -0400
Date: Wed, 12 Jul 2017 23:52:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Adam Buchbinder <abuchbinder@google.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Use '-t btrfs' mount option in tests.
Message-ID: <20170712215259.GL2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170712200522.18830-1-abuchbinder@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170712200522.18830-1-abuchbinder@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 12, 2017 at 01:05:22PM -0700, Adam Buchbinder wrote:
> Without it, mount (at least from util-linux 2.20.1) tries (and
> fails) to mount some filesystems as NTFS.
> 
> Signed-off-by: Adam Buchbinder <abuchbinder@google.com>

Applied, thanks.
