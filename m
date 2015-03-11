Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbbCKNXr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Mar 2015 09:23:47 -0400
Date: Wed, 11 Mar 2015 14:23:44 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 3.19
Message-ID: <20150311132344.GB20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs 3.19 have been released. The major change is in the build system, I
hope all the issues with the switch to autotools have been fixed. More detailed
instructions how to do adjust the build are in the -rc announcements [1].

The next version is going to follow the kernel scheme and will be 4.x based.

Besides core fixes and cleanups there are some user-visible changes:

- btrfs-image
  - restore can now run in parallel threads
  - fixed restore of multiple image from multiple devices onto a single dev
  - introduced metadump v2
- check
  - make --init-csum-tree and --init-extent-tree work together
- find-new
  - option to search through all metadata even if a root was already found
- convert
  - show progress by default, can be turned off
- corrupt-block
  - option to work on a specific root

- bash completion script for all subcommands

Thanks.

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git


[1]
rc1: http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg41369.html
rc2: http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg41399.html
rc3: http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg42140.html
