From: tsuraan <tsuraan@gmail.com>
Subject: subvolume/snapshot usage question
Date: Fri, 21 Aug 2009 23:35:00 -0500
Message-ID: <84fb38e30908212135r296382a9t294926ac4d977089@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Suppose I have a directory under my home on a btrfs filesystem where I
store virtual machine images.  I have one base virtual machine, and
from it I make copies that I actually run.  To make a copy of a VM
today, I do cp -r, which seems pretty wasteful since the VMs are
almost entirely identical.  Is there some way that I can do a snapshot
of just the directory that holds my base VM, and then mount different
"forks" of that snapshot to be the bases of my different running
machines?

It looks like I could create a snapshot of the root of my btrfs
filesystem for each vm, mount that snapshot somewhere, and run the vm
from that full fs snapshot, but that's not ideal.  I could also create
a large file for my base VM directory, format it btrfs, mount it using
the loopback device, and then mount snapshots of that loopback
filesystem, but having to preallocate filesystem space for my VMs is
not as nice as being able to share space with the rest of my
filesystem.  Is there a partial-snapshot capability in btrfs?  I don't
understand what subvolumes are, and I think they're unrelated to what
I want, but the name sounds promising...
