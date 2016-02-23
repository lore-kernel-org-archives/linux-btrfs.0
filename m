Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46745 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbcBWLlF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Feb 2016 06:41:05 -0500
Date: Tue, 23 Feb 2016 12:40:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-arm-kernel@lists.infradead.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: avoid uninitialized variable warning
Message-ID: <20160223114055.GK4374@suse.cz>
Reply-To: dsterba@suse.cz
References: <1456178006-1619105-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1456178006-1619105-1-git-send-email-arnd@arndb.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 22, 2016 at 10:53:20PM +0100, Arnd Bergmann wrote:
> With CONFIG_SMP and CONFIG_PREEMPT both disabled, gcc decides
> to partially inline the get_state_failrec() function but cannot
> figure out that means the failrec pointer is always valid
> if the function returns success, which causes a harmless
> warning:
> 
> fs/btrfs/extent_io.c: In function 'clean_io_failure':
> fs/btrfs/extent_io.c:2131:4: error: 'failrec' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> 
> This marks get_state_failrec() and set_state_failrec() both
> as 'noinline', which avoids the warning in all cases for me,
> and seems less ugly than adding a fake initialization.

Thanks for the analysis and the fix, works for me.
