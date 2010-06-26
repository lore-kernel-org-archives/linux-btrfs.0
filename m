From: Daniel Baumann <daniel@debian.org>
Subject: Atomic replacement of subvolumes is not possible
Date: Sat, 26 Jun 2010 19:25:58 +0200
Message-ID: <4C263826.1060702@debian.org>
Reply-To: daniel@debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Roger Leigh <rleigh@debian.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this is basically a forward from
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D587253

"rename(2) allows for the atomic replacement of files.  Being able to
atomically replace subvolume snapshots would be equally invaluable,
since it would permit lock-free replacement of subvolumes.

  % btrfs subvolume snapshot <src> <dest>

creates dest as a snapshot of src. However, if I want to do the
converse,

  % btrfs subvolume snapshot <dest> <src>

then <dest> is snapshotted as <src>/<dest>, i.e. not replacing the
original subvolume, but going inside the original subvolume.

Use case 1:
  I have a subvolume of data under active use, which I want to
  periodically update.  I'd like to do this by atomically
  replacing its contents.  I can replace the content right now
  by deleting the old subvolume and then snapshotting the new
  on in its place, but it's racy.  It really needs to be
  replaced in a single operation, or else there's a small window
  where there is no data, and I'd need to resort to some external
  locking to protect myself.

Use case 2:
  In schroot, we create btrfs subvolume snapshots to get copy-on-
  write chroots.  This works just fine.  We also provide direct
  access to the "source" subvolume, but since it could be
  snapshotted in an inconsistent state while being updated, we
  want to do the following:

  =B7 snapshot source subvolume
  =B7 update snapshot
  =B7 replace source volume with updated snapshot"

Please keep roger in the cc for any replies, thanks.

Regards,
Daniel

--=20
Address:        Daniel Baumann, Burgunderstrasse 3, CH-4562 Biberist
Email:          daniel.baumann@panthera-systems.net
Internet:       http://people.panthera-systems.net/~daniel-baumann/
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
