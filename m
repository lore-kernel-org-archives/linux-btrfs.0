From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Backporting Recent Btrfs Patches to 2.6.32
Date: Fri, 15 Oct 2010 14:23:00 -0500
Message-ID: <AANLkTin0HMr2N_hRBu_um+Rf9o+Agjis4E6HLdxkebqv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Since the 2.6.32 kernel is one of the long-term stable kernels, and
since a few projects (such as OpenVZ) and distros (such as Debian) are
using the 2.6.32 kernel, I've put together an experimental git branch
to backport later btrfs patches to the 2.6.32 kernel.

Let me know if there's any interest in this experiment, and I'll try
to keep it maintained.

I've placed a git repository containing this work here:

http://gitweb.sabayon.org/?p=linux/kernel/btrfs-backport.git;a=summary

The backport is currently in "works-for-me" status, and I have been
using it for about a week without crashes.

I did not attempt to backport every patch that has touched
linux/fs/btrfs compared to the 2.6.32 kernel.  Some patches were part
of larger kernel updates that would be outside the scope of a
backport.

I was able to backport the DIO patches and the improvements to ENOSPC
handling, as well as most of the other patches in the btrfs-unstable
repository.

Let me know if you have any feedback.
