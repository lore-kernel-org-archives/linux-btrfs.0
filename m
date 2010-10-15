From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 0/4] Btrfs: fix ENOSPC regressions
Date: Fri, 15 Oct 2010 17:28:31 -0400
Message-ID: <1287178115-18229-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patchset fixes some problems with the ENOSPC code for block groups, but
more importantly it fixes a huge ENOSPC regression that's occured.  With my
fs_mark test

fs_mark -d /mnt/btrfs-test -D 512 -t 16 -n 4096 -F -S0

on a 2gb fs without these patches fs_mark would exit out with ENOSPC after
writing around 50mb.  With these patches I can now fill up the disk.  Also the
new ENOSPC code is super aggressive about allocating metadata chunks, to the
point that even with the multi-writer regression fixed I was still only able to
fill about 900mb with data on a 2gb fs.  With all of these patches I can fill up
the 2gb fs with about 1.9gb of data.  This is much more reasonable.  There
doesn't appear to be any performance regression, but I would appreciate testing
to make sure this is actually the case.  Thanks,

Josef
