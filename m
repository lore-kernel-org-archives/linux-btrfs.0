Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53981 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S968871AbdDSSPQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Apr 2017 14:15:16 -0400
Date: Wed, 19 Apr 2017 20:15:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 0/9] Introduce btrfs-modify prog to make corruption easier
Message-ID: <20170419181512.GI22319@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170417032642.30770-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170417032642.30770-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 17, 2017 at 11:26:33AM +0800, Qu Wenruo wrote:
> Introduce a new command, btrfs-modify, which is not part of 'btrfs', but
> an independent command, bring minimal impact to existing btrfs commands.
> 
> Btrfs-modify is designed to provides better documentation than current
> btrfs-corrupt-block with better subcommand division to reduce confusing
> or conflicting options.
> 
> Btrfs-modify paired with offline-scrub patchset (not merged yet) could
> provide a full suite for test case writers to do corruption and recovery
> verification.

Starting a new tool makes sense, the btrfs-corrupt-block lacks the
subcommand hierarchy and it would be tedious to sew it in.

The commands that you add now still seem ad-hoc, adressing current
needs. This is how the corrupt-block utility started as well. I'd like
see some proposal of more potential uses and some command gouping. For
example main group: set, get, map, delete, insert, show. Then, define
for which objects the commands are applicable. We can start with the
raid56 testing usecase. You want to locate and modify a block baced on
the logical offset, so this should comprise of 'map' + 'set'. For
specific tasks we can add shortcuts or compound commands, not from the
start.
