Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396Ab3DUWKq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Apr 2013 18:10:46 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3LMAk3K001531
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 21 Apr 2013 18:10:46 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r3LMAikH027970
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sun, 21 Apr 2013 18:10:45 -0400
Message-ID: <517463E4.7040400@redhat.com>
Date: Sun, 21 Apr 2013 17:10:44 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/2] btrfs-progs: standardize utility filenames and add default
 rules to Makefile
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2 patches here.

The first renames the single .c files which are built into btrfs-$FOO
commands - previously we built i.e. btrfs-calc-size from calc-size.c

IMHO this helps separate out which files are main command-type
files, and which are not.  (Eventually I hope to move things
into subdirs to organize a bit more).

Then, after renaming i.e. calc-size.c to  btrfs-calc-size.c we can
write a simpler default rule for these utilities (patch 2/2).

The default static rule is handy because it'll automatically build
i.e. "make btrfs-image.static" or "make btrfs-calc-size.static"
if you need them.

I think this is a net win, with a bit less Makefile code
duplication, but if people don't like it, no big deal.  I was hoping
to clean up & re-organize the userspace build a little, and this
seems like a decent first step along the way.

Comments welcome, especially from people who are better at Make than
I am.  ;)  And if this is two clever by half I'm not wedded to it.

-Eric
