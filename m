Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58766 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727150AbeGPPIW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 11:08:22 -0400
Date: Mon, 16 Jul 2018 16:40:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH RESEND 1/2] btrfs-progs: remove stale dir-test and
 quick-test
Message-ID: <20180716144029.GJ3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1531436967.git.osandov@fb.com>
 <38850f2972a4bb5b37261c34b67f235fcbf679e7.1531436967.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <38850f2972a4bb5b37261c34b67f235fcbf679e7.1531436967.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 12, 2018 at 04:11:18PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> These don't build anymore and don't appear to be used for anything.

I've fixed build of quick-test and will keep the code for now, it can be
used for some stress testing. The dir-test does not seem to be even
potentially useful in the fucute, so it's dropped now.
