From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Fix possible pointer dereference
Date: Wed, 07 Oct 2009 02:03:42 +0200
Message-ID: <873a5w134x.fsf@basil.nowhere.org>
References: <200910062215.22562.diegocg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Diego Calleja <diegocg@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200910062215.22562.diegocg@gmail.com> (Diego Calleja's message of "Tue, 6 Oct 2009 22:15:22 +0200")
List-ID: <linux-btrfs.vger.kernel.org>

Diego Calleja <diegocg@gmail.com> writes:

> We should always check btrfs_alloc_path(). Some places BUG(),
> others return -ENOMEM, btrfs_insert_dir_item() seems like it can return
> safely.

The problem is that all the callers don't handle errors.
It doesn't make sense to fix it low-level currently when it cannot be handled
properly higher up anyways.

Proper out of memory handling needs much more work, one liners
don't really help.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
