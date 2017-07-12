Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41508 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752151AbdGLW0F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 18:26:05 -0400
Date: Thu, 13 Jul 2017 00:24:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Adam Buchbinder <abuchbinder@google.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Fix missing internal deps in tests.
Message-ID: <20170712222450.GQ2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170710212909.31559-1-abuchbinder@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170710212909.31559-1-abuchbinder@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 10, 2017 at 02:29:08PM -0700, Adam Buchbinder wrote:
> Doing a straight 'make test' would fail because some misc and fsck
> tests require particular tools to already be built. Add dependencies
> at the Makefile and shell-script level.
> 
> Signed-off-by: Adam Buchbinder <abuchbinder@google.com>

Applied, thanks.
