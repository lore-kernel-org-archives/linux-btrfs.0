Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60992 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753474AbcHaTKV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Aug 2016 15:10:21 -0400
Date: Wed, 31 Aug 2016 21:08:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: remove pointless debugfs interface
Message-ID: <20160831190858.GJ16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <d6715b5b-0aa3-3032-43c6-eccd907a60b8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d6715b5b-0aa3-3032-43c6-eccd907a60b8@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 31, 2016 at 10:13:49AM -0500, Eric Sandeen wrote:
> A /sys/kernel/debug/btrfs/test file was added nearly
> two and a half years ago, but it serves no purpose;

It does. Introduced in 1bae30982bc86ab66d61ccb6e22792593b45d44d says
something about helping developers to easily export information from the
filesystem, to aid debugging. Writing the debugfs support code is not
obviously trivial, so it's idling in the source. Exporing a new value is
as easy as copy and update 3 lines of code. If you have no use for it,
fine.

> it stores and returns a value, but nothing in the btrfs
> code uses this value in any way.  There are no other btrfs
> files in this debugfs dir.
> 
> This was brought to my attention because it is world-writable;
> it is the only such file under /sys/kernel/debug, and without
> knowledge of its purpose, some users were alarmed by this.

So let's fix the permissions.
