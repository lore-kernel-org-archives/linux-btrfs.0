Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38056 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab2GDNit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2012 09:38:49 -0400
Received: by bkwj10 with SMTP id j10so2632560bkw.19
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jul 2012 06:38:47 -0700 (PDT)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Block <ablock84@googlemail.com>
Subject: [RFC PATCH 0/7] Experimental btrfs send/receive (kernel side)
Date: Wed,  4 Jul 2012 15:38:21 +0200
Message-Id: <1341409108-13567-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,

This patchset introduces the btrfs send ioctl, which creates a stream
of instructions that can later be replayed to reconstruct the sent
subvolumes/snapshots. Patches for btrfs-progs will follow in a separate
patchset.

Some of you may remember the previous discussions on send/receive. The
original plan was to use ustar/pax as container for the stream, which
was a good format at the beginning as we planned to store extents and
other data as if they were normal files so that btrfs receive could
unpack them correctly to the right places. The advantage was that you
could unpack it with tar and use the contents by hand to some degree.

The type of the stream however has changed to some kind of instructions
stream, as this was the easiest way to handle moves, deletes and 
overwrites corretly. If this stream was stored in ustar/pax format,
we would have no advantages compared to a custom stream format. So I
dropped the ustar/pax format in the middle of development. I may add
a new mode for the ioctl (or a new ioctl?) later that emits the plain 
diff of the parent root and the root to send, instead of instructions.
This could then be used to do something like what was planned at the
beginning. It could also have other uses too. But that's for later.

The stream now consists of millions of create/rename/link/write/clone/
chmod/... instructions which only need to be replayed. No kernel
support is required to replay the stream. The only exception is the
BTRFS_IOC_SET_RECEIVED_SUBVOL call that is performed when btrfs 
receive is done.

btrfs send/receive currently only works on read-only snapshots. There
are ideas in my head floating around to make sending of r/w subvolumes
possible too, but this is for later.

We support full and incremental sending of subvolumes/snapshots.
The ioctl expects an optional list of "clone sources" and an optional
"parent root". The clone sources tell the kernel which subvolumes
can be used to accept clones from when processing file extents. The
parent root tells the kernel which root should be used for the
incremental send. Internally, it does a tree compare between the
send root and the parent root to find the differences. If no parent
is specified, the full tree is sent. The parent root is implicitely
added to the clone sources by btrfs-progs.  The parent root is also 
used for the initial snapshot operation on the receiving side. If no 
parent was specified to brtfs-progs, it will try to find a good one in 
the list of clone sources. This will however only work for snapshots
that were created with this patchset applied (due to the uuid+times
patch). Older snapshots miss parent information and you'll need to
specify a parent by hand.

If you used reflinks or the experimental dedup (found on the list)
before, you will need working cross subvolume reflinks on the
receiving side. The send ioctl tries hard to avoid emitting cross
subvolume reflinks if that is possible, but there is no guarantee
for this. If you specify clone sources by hand, there is also a
high chance that cross subvolume clones are emitted. In general,
I tend to see cross subvolume reflinks as a requirement for btrfs
send/receive.

*WARNING* *WARNING* *WARNING* *WARNING*
btrfs send/receive is experimental. The main usage for send/receive
in the future will probably be backups. If you use it for backups,
you're taking big risks and may end up with unusable backups. Please
do not only count on btrfs send/receive backups!

If you still want to use it, make sure the backups are working and
100% correct. I for example used rsync in dry run mode to ensure
that a stream was received correctly. Simply receive the just sent
Here is the command line that
I used for it:

rsync -aAXvnc --delete /origin/subvol/ /backup-target/subvol/

The -c flag is the most important here, don't remove it just to make
rsync faster. btrfs receive restores the file times 1:1, so rsync
may consider differing files as equal when it doesn't compare by
checksum. If rsync ever prints a file or directory in its output,
you have found a bug in btrfs send/receive. Please report this.

Also, the output format of btrfs send may not be final. I'll try 
hard to not change it too much and keep compability, but as this is a 
very early version, I can't guarantee anything. So please, don't store
the send streams with the assumption that you can still receive them
in a year.

You've been warned...

*END OF WARNING*

Big thanks go to Arne Jansen, David Sterba and Jan Schmidt (sorted by
first name) who helped me a lot with their assistance in IRC and the 
reviews done by them. The code however still needs a lot of review
and testing, so feel welcome to do so :)

You can pick and apply the patches by hand if you want. Don't
forget to also apply the required patches mentioned below. As an
alternative, here is my git repo containing all required patches:

git://github.com/ablock84/linux-btrfs.git (branch send)

The branch is based on 3.5-rc5. I had to split the last patch/commit as
it got over 100k which could be a problem on the mailing list.
My plan for the branch is to do fixes in seperate commits. I won't
send new patches to the list until I have the feeling it's worth for a
full new vX patch. In case we get a new version of the patchset, I will
either rebase the send branch or create a new branch for the new version
with all fixes squashed into the original commits. When btrfs send comes
into mainline, development will continue as with all other btrfs stuff.
If you have the feeling that this is wrong approach, please tell me as
this is the first project where I actively use git and work in such a
big community.

Requirements for this patchset to work properly:
1. At least kernel 3.5-rc5
2. The "Btrfs: don't update atime on RO subvolumes" patch.
   Found in btrfs-next and my repo.
3. Working cross subvolume reflinks. A patch from David Sterba 
   is found in his and my repo.
4. The patch "Btrfs: add helper for tree enumeration" from
   Arne. Found in my repo.
5. The patch "Btrfs: use _IOR for BTRFS_IOC_SUBVOL_GETFLAGS".
   Found in my repo and btrfs-next.
6. All the patches found in this patchset.

Alex.

Alexander Block (6):
  Btrfs: use _IOR for BTRFS_IOC_SUBVOL_GETFLAGS
  Btrfs: make iref_to_path non static
  Btrfs: introduce subvol uuids and times
  Btrfs: add btrfs_compare_trees function
  Btrfs: introduce BTRFS_IOC_SEND for btrfs send/receive (part 1)
  Btrfs: introduce BTRFS_IOC_SEND for btrfs send/receive (part 2)

Arne Jansen (1):
  Btrfs: add helper for tree enumeration

 fs/btrfs/Makefile      |    2 +-
 fs/btrfs/backref.c     |   10 +-
 fs/btrfs/backref.h     |    4 +
 fs/btrfs/ctree.c       |  499 ++++++
 fs/btrfs/ctree.h       |   61 +
 fs/btrfs/disk-io.c     |    2 +
 fs/btrfs/inode.c       |    4 +
 fs/btrfs/ioctl.c       |   99 +-
 fs/btrfs/ioctl.h       |   25 +-
 fs/btrfs/root-tree.c   |   92 +-
 fs/btrfs/send.c        | 4255 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/send.h        |  130 ++
 fs/btrfs/transaction.c |   17 +
 13 files changed, 5184 insertions(+), 16 deletions(-)
 create mode 100644 fs/btrfs/send.c
 create mode 100644 fs/btrfs/send.h

-- 
1.7.10

