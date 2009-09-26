From: Alberto Bertogli <albertito@blitiri.com.ar>
Subject: Clone range ioctl
Date: Sat, 26 Sep 2009 16:46:20 -0300
Message-ID: <20090926194617.GW7592@blitiri.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Hi!

Out of curiosity for btrfs, I'm modifying a project of mine
(http://blitiri.com.ar/p/libjio) to use the clone range ioctl, and I've got a
couple of questions. I thought this would be the place to ask them, I hope you
don't mind:

- Once the ioctl() returns successfully, is data supposed to be on the disk,
  or should I sync it manually (fdatasync()/sync_file_range())? From a quick
  peek at the code it seems the former, but it'd be nice to get confirmation.
- I've hit a couple of bugs (2.6.31's fs/btrfs/file.c:528, for example);
  should I take a look and report them, or this code is not expected to work
  yet?
- Are there any special considerations an application should take when using
  it?
- Since I need to use block-aligned offsets, how can I find out the
  appropriate block size for a given file without being root? I've hardcoded
  it to 4k for the time being, but I couldn't find out how to ask the
  filesystem except for the BLKGETBSZ, which requires being root. I'm
  obviously ok with a btrfs-only solution.

If anyone could answer any of these (or point me to the relevant code), I'd
really appreciate it.

Thanks a lot,
		Alberto


