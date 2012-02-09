From: David Sterba <dave@jikos.cz>
Subject: Re: subvolume info in /proc/mounts
Date: Thu, 9 Feb 2012 14:44:03 +0100
Message-ID: <20120209134403.GC15350@twin.jikos.cz>
References: <13975aa6fbfab9c845a2582c043aa938.squirrel@webmail01.edunet.gr> <20120204214430.GA15350@twin.jikos.cz> <2ed5fe028fdcfd3d53cf217e13b827d9.squirrel@webmail01.edunet.gr> <20120206115321.GB15350@twin.jikos.cz> <20120206121823.GA24922@infradead.org> <20120206135215.GE23916@ZenIV.linux.org.uk>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Nikos Voutsinas <nvoutsin@noc.edunet.gr>, dave@jikos.cz,
	linux-btrfs@vger.kernel.org, kreijack@gmail.com,
	chris.mason@oracle.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120206135215.GE23916@ZenIV.linux.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 06, 2012 at 01:52:15PM +0000, Al Viro wrote:
> On Mon, Feb 06, 2012 at 07:18:24AM -0500, Christoph Hellwig wrote:
> > On Mon, Feb 06, 2012 at 12:53:21PM +0100, David Sterba wrote:
> > > On Sun, Feb 05, 2012 at 12:30:42PM +0200, Nikos Voutsinas wrote:
> > > > It's quite old, but what was this about;
> > > > 
> > > > http://thread.gmane.org/gmane.comp.file-systems.btrfs/4487
> > > 
> > > Thanks, the patch looks ok and works as expected.
> > > 
> > > Goffredo, do you want to resend it? (The lock around the mnt_root is not
> > > necessary.) I think it's a -rc material, more people came to ask about
> > > this on irc channel lately, we don't need to wait a full release cycle
> > > to merge this fix.
> > 
> > No, it doesn't look good.  Please do not introduce anything touching
> > non-superblock fields in ->show_options, thanks.

Sorry, I'll be more carefull with vfs patches.

> Umm...  seq_dentry() on root dentry (which is what's getting passed to
> ->show_options() now) would be OK; this kind of playing with ->d_name
> is not.

Thanks for the suggestion. This should do it, 


--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -766,6 +766,9 @@ static int btrfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
                seq_puts(seq, ",inode_cache");
        if (btrfs_test_opt(root, SKIP_BALANCE))
                seq_puts(seq, ",skip_balance");
+       seq_puts(seq, ",subvol=");
+       seq_dentry(seq, vfs->mnt_root, " \t\n\\");
+
        return 0;
 }

( plus EXPORT_SYMBOL(seq_dentry) )

The 3rd argument (chars to be escaped in the path), is same as passed to other
seq_* funcs, though I'm not sure if we don't want to escape ',' as well, since
it may confuse option parsers out there. If the subvol= is kept as the last
one, then actual path is from '=' up to the first unescaped ' '.

If touching dentry name is forbidden, then we could entirely skip checking
whether it's '/', and always show subvol path. I don't see a problem from
user's/administrator's POV (and I'm not going to invent another way to check
for '/' by looking to other internal vfs items).

Full patch:

From: David Sterba <dsterba@suse.cz>

Although it's not necessarily needed to show the mount option for the
toplevel subvolume, we cannot touch dentry name or other internal items
to check for it.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/super.c |    6 ++++++
 fs/seq_file.c    |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 61717a4..dda5d6e 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -766,6 +766,12 @@ static int btrfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_puts(seq, ",inode_cache");
 	if (btrfs_test_opt(root, SKIP_BALANCE))
 		seq_puts(seq, ",skip_balance");
+	/*
+	 * Keep this one at the end
+	 */
+	seq_puts(seq, ",subvol=");
+	seq_dentry(seq, vfs->mnt_root, " \t\n\\");
+
 	return 0;
 }
 
diff --git a/fs/seq_file.c b/fs/seq_file.c
index dba43c3..ccbcc56 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -498,6 +498,7 @@ int seq_dentry(struct seq_file *m, struct dentry *dentry, char *esc)
 
 	return res;
 }
+EXPORT_SYMBOL(seq_dentry);
 
 int seq_bitmap(struct seq_file *m, const unsigned long *bits,
 				   unsigned int nr_bits)
-- 
1.7.8
