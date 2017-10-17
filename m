Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48512 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754038AbdJQSIe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Oct 2017 14:08:34 -0400
Date: Tue, 17 Oct 2017 20:06:47 +0200
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3] btrfs-progs: change subvol set-default to also accept
 subvol path
Message-ID: <20171017180647.GC3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <ff364376-54d3-d0e2-fbae-eb45a92029ed@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ff364376-54d3-d0e2-fbae-eb45a92029ed@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 06, 2017 at 10:05:08AM +0900, Misono, Tomohiro wrote:
> This patch changes "subvol set-default" to also accept the subvolume path
> for convenience.
> 
> This is the one of the issue on github: 
> https://github.com/kdave/btrfs-progs/issues/35
> 
> If there are two args, they are assumed as subvol id and path to the fs
> (the same as current behavior), and if there is only one arg, it is assumed
> as the path to the subvolume.
> 
> subvol id is resolved by test_issubvolume() + lookup_path_rootid().
> Empty subvol (ino==2) will get error on test_issubvolume() which checks
> whether inode num is 256 or not.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Applied with some minor changes. Meanwhile I've added support for
multi-line help string for different usage schemas so

	"btrfs subvolume set-default [<subvolume>|<subvolid> <path>]",

is now

	"btrfs subvolume set-default <subvolume>",
	"btrfs subvolume set-default <subvolid> <path>",

Please note that [...] means that's an optional argument, which would be
confusing. OTOH writing the two ways without [ ] on one line would
confusing as well, so I more lines is much better IMHO.

Patch applied, please send a test, for the 'cli' category. I'm going to
unify the help text and documentation. Thanks.
