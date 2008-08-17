From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] NFS support for btrfs - v2
Date: Sun, 17 Aug 2008 12:53:22 +0100
Message-ID: <1218974002.3184.278.camel@pmac.infradead.org>
References: <200807210201.56690.balajirrao@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Balaji Rao <balajirrao@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200807210201.56690.balajirrao@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-07-21 at 02:01 +0530, Balaji Rao wrote:
> Here's an implementation of NFS support for btrfs. It does not work in
> one particular case as described in 
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg00298.html.

I can't get it to work properly. The simple case of exporting and using
a file system works -- but that doesn't exercise the get_parent() or
dentry_to_fh() code paths. To test those, you need to clear the server's
dcache completely -- I prefer just rebooting the server.

Note that the first problem you'll hit is the lack of stable fsid --
because btrfs uses an anonymous superblock, it might cause stale file
handles after a reboot, unless your test setup mounts exactly the same
anonymous file systems each time. That bit me when I context switched
from something else and had debugfs mounted before btrfs, then rebooted
and didn't mount debugfs first. I'll deal with the fsid problem
separately; just be aware of it and avoid it for now.

The second problem is that btrfs_fh_to_dentry() fails -- it seems we
need to set the key type BTRFS_INODE_ITEM_KEY in btrfs_get_dentry(),
rather than BTRFS_INODE_REF_KEY. I still haven't learned enough to know
precisely what the implications of that are -- but unless I make that
change, btrfs_lookup_inode() fails and btrfs_read_locked_inode() marks
the resulting inode as bad.

You can test that by mounting the exported file system, then rebooting
the server, then running 'ls' in the NFS-mounted file system.

My next test was to make a deep directory path: mkdir -p a/b/c/d/e/f/g
and then change directory into it. Again reboot the server and run 'ls'.
This time, I see 'ls: cannot open directory .'. In this csse, it seems
to be because btrfs_get_parent() is failing. In my case, it seems to be
because the 'if (slot >= nritems)' check is triggering -- both are set
to 14. I'm now trying to work out precisely what that means...

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



