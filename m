Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kaa.mcnabbs.org ([173.255.195.144]:36217 "EHLO mail.mcnabbs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098Ab3AZU1M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Jan 2013 15:27:12 -0500
Date: Sat, 26 Jan 2013 14:27:11 -0600
From: Andrew McNabb <amcnabb@mcnabbs.org>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs stability
Message-ID: <20130126202711.GB30537@mcnabbs.org>
References: <20130125200514.GD4217@mcnabbs.org>
 <20130125205322.GB3257@localhost.localdomain>
 <20130125213950.GF4217@mcnabbs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130125213950.GF4217@mcnabbs.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here's an update.  I tried the new kernel, and I seem to be having some
new (possibly worse problems.  In my ssh session, I'm seeing many errors
of this sort:

Message from syslogd@guru at Jan 26 13:13:14 ...
 kernel:[  308.223834] BUG: soft lockup - CPU#0 stuck for 23s!
 [btrfs-endio-wri:2073]

Message from syslogd@guru at Jan 26 13:13:14 ...
 kernel:[  308.248754] BUG: soft lockup - CPU#2 stuck for 23s!
 [btrfs-delalloc-:594]

In the logs, I'm seeing several warnings and bugs, including:

WARNING: at fs/btrfs/extent_map.c:78 free_extent_map+0x79/0x90 [btrfs]()
WARNING: at lib/list_debug.c:62 __list_del_entry+0x82/0xd0()
BUG: unable to handle kernel NULL pointer dereference at     (null)
BUG: soft lockup - CPU#0 stuck for 22s! [btrfs-endio-wri:1489]
BUG: soft lockup - CPU#1 stuck for 22s! [btrfs-delalloc-:607]

Kernel logs (across a few reboots) are at:

http://students.cs.byu.edu/~amcnabb/messages2

--
Andrew McNabb
http://www.mcnabbs.org/andrew/
PGP Fingerprint: 8A17 B57C 6879 1863 DE55  8012 AB4D 6098 8826 6868
