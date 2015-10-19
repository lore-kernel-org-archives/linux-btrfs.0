Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33501 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbbJSJsC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 05:48:02 -0400
Date: Mon, 19 Oct 2015 11:46:47 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.2.3
Message-ID: <20151019094647.GT27761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

here's another bugfix release of btrfs-progs. Updating is recommended.

* subvol sync: make it actually work again:
  it's been broken since 4.1.2, due to a reversed condition it returned
  immediatelly instead of waiting for

* scanning: do not scan already discovered filesystems (minor optimization)
* convert: better error message in case the filesystem is not finalized
* restore: off-by-one symlink path check fix

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git


Shortlog:
Anand Jain (1):
      btrfs-progs: optimize not to scan repeated fsid mount points

David Sterba (2):
      btrfs-progs: subvol sync: fix reversed condition
      Btrfs progs v4.2.3

Qu Wenruo (1):
      btrfs-progs: convert: Print different error message if convert partly failed.

Vincent Stehlé (1):
      btrfs-progs: restore: fix off-by-one len check
