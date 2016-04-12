Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50310 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223AbcDLSi3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Apr 2016 14:38:29 -0400
Subject: Re: loop subsystem corrupted after mounting multiple btrfs
 sub-volumes
To: Al Viro <viro@ZenIV.linux.org.uk>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
References: <56CF5490.7040102@suse.cz> <56D04630.1020809@gmail.com>
 <56D0743F.9040102@suse.cz> <56D07FAF.3080605@gmail.com>
 <20160226175311.GC17997@ZenIV.linux.org.uk> <56D0A38B.3050701@suse.cz>
 <56D0B007.2050106@gmail.com> <20160226203010.GD17997@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>, Valdis.Kletnieks@vt.edu
From: Stanislav Brabec <sbrabec@suse.cz>
Message-ID: <570D40A2.7030209@suse.cz>
Date: Tue, 12 Apr 2016 20:38:26 +0200
MIME-Version: 1.0
In-Reply-To: <20160226203010.GD17997@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Feb 26, 2016 at 21:30 Al Viro wrote:
> Sigh...  sys_mount() (mount_bdev(), actually) has no way to tell if two
> loop devices refer to the same underlying object.  As far as it's
> concerned, you are asking to mount a completely unrelated block device.
> Which just happens to see the data (living in separate pagecache, even)
> modified behind its back (with some delay) after it gets written to another
> device.  Filesystem drivers generally don't like when something is screwing
> the underlying data, to put it mildly...
>

I wrote a loop device reuse patch for mount -oloop.

[PATCH 0/3] btrfs-safe implementation of -oloop
http://marc.info/?l=util-linux-ng&m=146048532307963&w=2

[PATCH 1/3] libmount: Re-organize is_mounted_same_loopfile()
http://marc.info/?l=util-linux-ng&m=146048535907971&w=2

[PATCH 2/3] libmount: reuse existing loop device
http://marc.info/?l=util-linux-ng&m=146048537807980&w=2

[PATCH 3/3] mount: Handle EROFS before calling mount() syscall
http://marc.info/?l=util-linux-ng&m=146048542007990&w=2

However it works for me, there are still some controversial issues
described in [PATCH 0/3].

These patches will hide corruption of kernel loop control structures
mentioned earlier in this thread and in most cases prevent data
corruption.

-- 
Best Regards / S pozdravem,

Stanislav Brabec
software developer
---------------------------------------------------------------------
SUSE LINUX, s. r. o.                         e-mail: sbrabec@suse.com
Lihovarská 1060/12                            tel: +49 911 7405384547
190 00 Praha 9                                 fax:  +420 284 084 001
Czech Republic                                    http://www.suse.cz/
PGP: 830B 40D5 9E05 35D8 5E27 6FA3 717C 209F A04F CD76
