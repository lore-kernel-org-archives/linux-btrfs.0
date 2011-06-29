From: Stephane Chazelas <stephane.chazelas@gmail.com>
Subject: subvolumes missing from "btrfs subvolume list" output
Date: Wed, 29 Jun 2011 15:37:47 +0100
Message-ID: <chaz20110629143747.GA28702@seebyte.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hiya,

I've got a btrfs FS with 84 subvolumes in it (some created
with "btrfs sub create", some with "btrfs sub snap" of the other
ones). There's no nesting of subvolumes at all (all direct
children of the root subvolume).

The "btrfs subvolume list" is only showing 80 subvolumes. The 4
missing ones (1 original volume, 3 snapshots) do exist on disk
and files in there have different st_devs from any other
subvolume.

How would I start investigating what's wrong? And how to fix it.

I found
http://thread.gmane.org/gmane.comp.file-systems.btrfs/8123/focus=8208

which looks like the same issue, with Li Zefan saying he had a
fix, but I couldn't find any mention that it was actually fixed.

Has anybody got any update on that?

Thanks in advance,
Stephane
