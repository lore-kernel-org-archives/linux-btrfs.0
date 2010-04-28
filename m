From: "Vladimir G. Ivanovic" <vladimir@acm.org>
Subject: crash in btrfsck, btrfs-debug-tree, etc
Date: Wed, 28 Apr 2010 13:03:13 -0700
Message-ID: <4BD89481.1060201@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I overwrote some part of the first 195641856 bytes of a 1TB (nominal)
btrfs volume (I CTRL-C'd out
before dd finished.) OK, OK, you may stop laughing now. Surely something
similar has happened to
you. No? Then it will, someday.

First things first: A huge congratulations to the btrfs team because the
btrfs volume is still
usable. I do get many errors similar to:

    kernel: btrfs bad tree block start 3050544144921548175 12056985

but for many of my files, I don't get errors.

Now, onto my problems. My first thought was to btrfsck the unmount
volume, but btrfsck crashes:

    # btrfsck /dev/sdc1
    btrfsck: disk-io.c:723: open_ctree_fd: Assertion
`!(!chunk_root->node)' failed.
    Aborted (core dumped)

So does btrfs-debug-tree, and I suspect other utilities will as well. I
tried the latest utilities
from btrfs-progs-unstable, but they too crash with the same error. (I'm
on a Athlon64-powered
netbook running Fedora 12. btrfs's version is 0.19.) In particular, so
does btrfs-image, so I can't
share the volume's metadata.

So, until the utilities are fixed, what are my options?

* Can I create a snapshot of the root volume? Would I end up with
everything that could be read in
  the snapshot, or would it also have errors? If this is a good idea,
would these commands work?

      btrfsctl -s snapshot_of_root /mnt/chopin1
      mount.btrfs -o subvol=snapshot_of_root /dev/sdc1 /mnt/snap

  do the trick, assuming that btrfsctl doesn't also crash? Then what?
Copy the snapshot to another
  disk? Somehow make the new snapshot the new root, allowing me to
delete the old root?

* Should I just try and copy the data to another disk and reformat my
current volume?

* Is there a way of testing whether a particular file is good other than
(slowly) going through
  each and every file while watching syslog? cat, for example, doesn't
return an error when the
  file is bad, so I don't think I can write a shell script to copy good
files to another volume.

Are there other options that I haven't considered?

Thanks for all help.

--- Vladimir

-- 
Vladimir G. Ivanovic                            http://www.leonora.org
+1 650 450 4101                                       vladimir@acm.org

