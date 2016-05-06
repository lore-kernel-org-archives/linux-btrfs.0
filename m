Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tty0.vserver.softronics.ch ([91.214.169.36]:58405 "EHLO
	fe1.digint.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbcEFQl3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 May 2016 12:41:29 -0400
Received: from [10.0.1.10] (77-59-134-149.dclient.hispeed.ch [77.59.134.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by fe1.digint.ch (Postfix) with ESMTPSA id 344213015B
	for <linux-btrfs@vger.kernel.org>; Fri,  6 May 2016 18:33:31 +0200 (CEST)
To: linux-btrfs@vger.kernel.org
From: Axel Burri <axel@tty0.ch>
Subject: btrfs-progs: separated binaries with elevated privileges
 (proof-of-concept)
Message-ID: <61dd446f-2201-e22c-452e-0e4702da8fbf@tty0.ch>
Date: Fri, 6 May 2016 18:31:52 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(see links to patchset at end of mail)

While btrfs-progs offer the all-inclusive "btrfs" command, it gets
pretty cumbersome to restrict privileges to the subcommands. Common
approaches are to either setuid root for "/sbin/btrfs" (which is not
recommended at all), or to write special sudo rules for each subcommand
needed.

As a sysadmin, I like to see separate binaries for each task, so that I
can easily set elevated privileges (capabilities or setuid) on each of
them. A typical use case where this is needed is when it comes to
automated scripts, in my case creating snapshots and send/receive them
via ssh (automated by btrbk).

I hacked a little proof-of-concept on top of btrfs-progs, which adds
some extra binaries for specific tasks, with the result looking like this:

# ls -l /usr/bin/btrfs-*
-rwxr-x--- 1 root btrfs [...] /usr/bin/btrfs-receive
-rwxr-x--- 1 root btrfs [...] /usr/bin/btrfs-send
-rwxr-x--- 1 root btrfs [...] /usr/bin/btrfs-subvolume-list
-rwxr-x--- 1 root btrfs [...] /usr/bin/btrfs-subvolume-show
-rwxr-x--- 1 root btrfs [...] /usr/bin/btrfs-subvolume-snapshot

# getcap /usr/bin/btrfs-*
/usr/bin/btrfs-receive =
cap_chown,cap_dac_override,cap_dac_read_search,cap_fowner,cap_sys_admin,cap_mknod+ep
/usr/bin/btrfs-send = cap_dac_read_search,cap_sys_admin+ep
/usr/bin/btrfs-subvolume-list = cap_dac_read_search,cap_sys_admin+ep
/usr/bin/btrfs-subvolume-show = cap_dac_read_search,cap_sys_admin+ep
/usr/bin/btrfs-subvolume-snapshot =
cap_dac_override,cap_dac_read_search,cap_fowner,cap_sys_admin+ep


On the remote hosts I now simply need to install these binaries (e.g.
"btrfs-subvolume-snapshot" and "btrfs-send" for backup sources), and
make sure the user calling them is in the 'btrfs' group. This gives me a
good feeling of a simple and secure system.

The patch needed to achieve this is pretty straight-forward, and if you
are interested I will gladly work on a clean implementation for btrfs-progs.



The patchset (proof-of-concept) is here:

https://github.com/digint/btrfs-progs/tree/separated_executables


Complete diff to v4.5.2 here:

https://github.com/digint/btrfs-progs/compare/master...digint:separated_executables


A (also very experimental) gentoo ebuild for this is available in
digint-overlay, "sys-fs/btrfs-progs-suid":

git://dev.tty0.ch/portage/digint-overlay.git
