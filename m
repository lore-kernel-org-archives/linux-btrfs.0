Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36656 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727086AbeHURkc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 13:40:32 -0400
Date: Tue, 21 Aug 2018 16:20:00 +0200
From: David Sterba <dsterba@suse.cz>
To: David Howells <dhowells@redhat.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: Do btrfs compression option changes need to be atomic?
Message-ID: <20180821142000.GC24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <31114.1534417285@warthog.procyon.org.uk>
 <476.1534859190@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <476.1534859190@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 21, 2018 at 02:46:30PM +0100, David Howells wrote:
> Should changes to the compression options on a btrfs mount be atomic, the
> problem being that they're split across three variables?

Do you mean the compression type (btrfs_fs_info::compress_type) and the
related bits in btrfs_fs_info::mount_opt ? There are more compression
types but not used in the mount context.  I assume you're interested
only in the mount-time settings, otherwise the defrag and per-inode
compression has higher priority over the global settings.

When an extent is going to be compressed, the current value of
compression type is read and then passed around.

> Further to that, how much of an issue is it if the configuration is split out
> into its own struct that is accessed from struct btrfs_fs_info using RCU?

Depends on how intrusive it's going to be, the mount opions are tested
at many places. The RCU overhead and "locking" is lightweight enough so
it should not be a problem in principle, but without seeing the code I
can't tell.
