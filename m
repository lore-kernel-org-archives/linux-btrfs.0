Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41545 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752151AbdGLW10 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 18:27:26 -0400
Date: Thu, 13 Jul 2017 00:26:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Adam Buchbinder <abuchbinder@google.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Tighten integer types in print-tree.
Message-ID: <20170712222612.GR2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170710212909.31559-1-abuchbinder@google.com>
 <20170710212909.31559-2-abuchbinder@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170710212909.31559-2-abuchbinder@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 10, 2017 at 02:29:09PM -0700, Adam Buchbinder wrote:
> There are likely more places where the wrong size types are used, but
> these tripped Clang's warnings because they eventually get passed to
> printf.
> 
> Signed-off-by: Adam Buchbinder <abuchbinder@google.com>

Applied, thanks.
