Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57004 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942032AbcJFPeD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Oct 2016 11:34:03 -0400
Date: Thu, 6 Oct 2016 17:34:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: Fix warning_trace compile error if
 backtrace is disabled
Message-ID: <20161006153400.GI6576@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161006084719.9540-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20161006084719.9540-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 06, 2016 at 04:47:19PM +0800, Qu Wenruo wrote:
> If we disable backtrace, btrfs-progs can't be compiled since we don't
> have warning_trace defined.
> 
> Fix by move it out of #ifndef BTRFS_DISABLE_BACKTRACE block.

But now this breaks with backtrace, eg:

kerncompat.h: In function ‘warning_trace’:
kerncompat.h:91:3: warning: implicit declaration of function ‘print_trace’ [-Wimplicit-function-declaration]
   print_trace();
   ^~~~~~~~~~~
kerncompat.h: At top level:
kerncompat.h:97:20: warning: conflicting types for ‘print_trace’
 static inline void print_trace(void)
                    ^~~~~~~~~~~
kerncompat.h:97:20: error: static declaration of ‘print_trace’ follows non-static declaration
kerncompat.h:91:3: note: previous implicit declaration of ‘print_trace’ was here
   print_trace();

I've fixed it and will add a script to cycle through common build
configuration so we can automate that a bit.
