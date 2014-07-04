Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:42244 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbaGDVK5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jul 2014 17:10:57 -0400
Received: by mail-ig0-f174.google.com with SMTP id l13so9063386iga.13
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Jul 2014 14:10:56 -0700 (PDT)
Received: from [192.168.1.2] ([216.26.106.6])
        by mx.google.com with ESMTPSA id e2sm1296461igi.12.2014.07.04.14.10.55
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 04 Jul 2014 14:10:56 -0700 (PDT)
Message-ID: <53B7185F.4040307@gmail.com>
Date: Fri, 04 Jul 2014 16:10:55 -0500
From: Kevin Brandstatter <icarusthecow@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: qgroup destroy / assign
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

how are qgroups accounted for? Are they specifially tied to one
subvolume on creation?
If so, is it possible to auto delete relavant qgroups on deletion of the
subvolume?

also, how exactly does qgroup assign work? I havent been able to get it
to work at all.
in btrfsprogs cmds-cgroup.c
if ((args.src >> 48) >= (args.dst >> 48)) {
      fprintf(stderr, "ERROR: bad relation requested '%s'\n", path);
      return 1;
   }
always seems to fail. I tried creating another qgroup id 1000, and
assigning it to as sub, and vice versa, as well as assigning the sub to
the root, and vice versa, as well as one subvol to another.
The fixme comment leads me to believe that the src should be a path not
a qgroup ("FIXME src should accept subvol path")
but the progs let me create a qgroup without a subvol, which makes sense
if you want to be able to have some meta-qgroup for a bunch of subvols.
Further on noticing that a sub create also creates a qgroup with the
same id as the subvol, it would seem that the qgroup is tied to the
subvol via this shared id.

-Kevin Brandstatter
