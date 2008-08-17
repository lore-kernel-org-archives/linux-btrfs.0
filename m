From: Balaji Rao <balajirrao@gmail.com>
Subject: Re: [PATCH] NFS support for btrfs - v2
Date: Sun, 17 Aug 2008 18:21:43 +0530
Message-ID: <200808171821.43874.balajirrao@gmail.com>
References: <200807210201.56690.balajirrao@gmail.com> <1218974002.3184.278.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1218974002.3184.278.camel@pmac.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday 17 August 2008 05:23:22 pm David Woodhouse wrote:
> On Mon, 2008-07-21 at 02:01 +0530, Balaji Rao wrote:
> > Here's an implementation of NFS support for btrfs. It does not work in
> > one particular case as described in
> > http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg00298.html.
>
> I can't get it to work properly. The simple case of exporting and using
> a file system works -- but that doesn't exercise the get_parent() or
> dentry_to_fh() code paths. To test those, you need to clear the server's
> dcache completely -- I prefer just rebooting the server.
>

OK. I was not very sure if NFS worked across server reboots.

> Note that the first problem you'll hit is the lack of stable fsid --
> because btrfs uses an anonymous superblock, it might cause stale file
> handles after a reboot, unless your test setup mounts exactly the same
> anonymous file systems each time. That bit me when I context switched
> from something else and had debugfs mounted before btrfs, then rebooted
> and didn't mount debugfs first. I'll deal with the fsid problem
> separately; just be aware of it and avoid it for now.
>
Hmmm.. how do we deal with that ?

> The second problem is that btrfs_fh_to_dentry() fails -- it seems we
> need to set the key type BTRFS_INODE_ITEM_KEY in btrfs_get_dentry(),
> rather than BTRFS_INODE_REF_KEY. I still haven't learned enough to know
> precisely what the implications of that are -- but unless I make that
> change, btrfs_lookup_inode() fails and btrfs_read_locked_inode() marks
> the resulting inode as bad.
>
Right. Again, my bad. That's a silly mistake, which didn't surface because of 
bad testing!

> You can test that by mounting the exported file system, then rebooting
> the server, then running 'ls' in the NFS-mounted file system.
>
> My next test was to make a deep directory path: mkdir -p a/b/c/d/e/f/g
> and then change directory into it. Again reboot the server and run 'ls'.
> This time, I see 'ls: cannot open directory .'. In this csse, it seems
> to be because btrfs_get_parent() is failing. In my case, it seems to be
> because the 'if (slot >= nritems)' check is triggering -- both are set
> to 14. I'm now trying to work out precisely what that means...

I think this means that the inode ref is not found, which is weird. I remember 
that it worked with it a really deep path. I'll try to reproduce the problem 
and see what's going on..

-- 
Thanks,
Balaji
