Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33361 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbcB2O4l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Feb 2016 09:56:41 -0500
Subject: Re: loop subsystem corrupted after mounting multiple btrfs
 sub-volumes
To: Valdis.Kletnieks@vt.edu
References: <56CF5490.7040102@suse.cz> <56D04630.1020809@gmail.com>
 <56D0743F.9040102@suse.cz> <56D07FAF.3080605@gmail.com>
 <20160226175311.GC17997@ZenIV.linux.org.uk> <56D0A38B.3050701@suse.cz>
 <56D0B007.2050106@gmail.com> <20160226203010.GD17997@ZenIV.linux.org.uk>
 <56D0BCFC.5020302@suse.cz> <52677.1456524057@turing-police.cc.vt.edu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
From: Stanislav Brabec <sbrabec@suse.cz>
Message-ID: <56D45C27.2080102@suse.cz>
Date: Mon, 29 Feb 2016 15:56:39 +0100
MIME-Version: 1.0
In-Reply-To: <52677.1456524057@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Feb 26, 2016 at 23:00 Valdis.Kletnieks@vt.edu wrote:
> On Fri, 26 Feb 2016 22:00:44 +0100, Stanislav Brabec said:
>
>> Well, it seems to be safe, even if the loop device was not allocated by
>> mount(8) itself, as
>> ioctl(fd, LOOP_CLR_FD)
>> never returns EBUSY:
>
> The fact you don't get an EBUSY doesn't mean it's actually safe....
>
Then, what should mount do, when -oloop is used and loop for the file
is already set?

1) Verify that the loop device is a plain loop without encryption, and
recycle it.

2) Allocate new loop device? (Known to cause issues, and corrupts
structures on a current kernel.)

3) Trace loop devices allocated by mount itself and report error, if it
was not allocated by mount. (But there can still be legitimate uses,
e. g. two filesystems in one file, each at different offset, one of
them is encrypted.)

3) Report error and recommend direct use of /dev/loop*. (See 3 plus
setup of a system with /dev/loop* in fstab needs a non-standard
actions.)

4) Other ideas?

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
