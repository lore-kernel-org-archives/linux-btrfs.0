Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45322 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726720AbeIKPWk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 11:22:40 -0400
Date: Tue, 11 Sep 2018 12:23:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Nick Terrell <terrelln@fb.com>
Cc: David Sterba <dsterba@suse.cz>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, grub-devel@gnu.org
Subject: Re: [PATCH 0/3] btrfs: Add zstd support to btrfs
Message-ID: <20180911102340.GD24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180828013654.1627080-1-terrelln@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180828013654.1627080-1-terrelln@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 27, 2018 at 06:36:51PM -0700, Nick Terrell wrote:
> Hi all,
> 
> This patch set imports the upstream kernel zstd library, patches it to work
> in grub, adds zstd support to the btrfs module, and adds a test case. I've
> separated the importing and patching of the upstream kernel zstd library
> for ease of review.
> 
> Thanks to David Sterba for starting this project! I started my patch from
> where he left off.

The first patch did not make it to vger.kernel.org mailinglist, which
suggests that it's big, and possibly too big for merging. I did only a
prototype to make it work, I'm afraid the patch won't be accepted.

Your follow patches clean it up and IMHO go in the right direction, but
I think this needs to be done from the beginning.
