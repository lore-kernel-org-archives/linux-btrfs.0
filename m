Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50659 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751146AbcJENdt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Oct 2016 09:33:49 -0400
Date: Wed, 5 Oct 2016 15:33:46 +0200
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: Btrfs progs release 4.8 (32bit builds broken)
Message-ID: <20161005133346.GF6576@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161005112949.8086-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161005112949.8086-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I got a report that the 32bit builds are broken. This seems to be caused
by padding inserted (or not) into the structures and depends on a
compiler version. The error messages may look cryptic, but if you see
something like

ioctl.h:570:1: note: in expansion of macro 'BUILD_ASSERT'
 BUILD_ASSERT(sizeof(struct btrfs_ioctl_received_subvol_args) == 200);

that means that the given structure has an unexpected size. Fixing that
properly will probably lead to some tricks to force the exact size
regardless of arch bits and compiler.
