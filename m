Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from d.mail.sonic.net ([64.142.111.50]:44563 "EHLO d.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbcDTUeH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Apr 2016 16:34:07 -0400
To: linux-btrfs@vger.kernel.org
From: Konstantin Svist <fry.kun@gmail.com>
Subject: btrfs-progs confusing message
Message-ID: <5717E55A.5070400@gmail.com>
Date: Wed, 20 Apr 2016 13:23:54 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Pretty much all commands print out the usage message when no device is
specified:

[root@host ~]# btrfs scrub start
btrfs scrub start: too few arguments
usage: btrfs scrub start [-BdqrRf] [-c ioprio_class -n ioprio_classdata]
<path>|<device>
...

However, balance doesn't

[root@host ~]# btrfs balance start
ERROR: can't access 'start': No such file or directory




