Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38006 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933912AbcBZVg6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Feb 2016 16:36:58 -0500
From: Stanislav Brabec <sbrabec@suse.cz>
Subject: Re: loop subsystem corrupted after mounting multiple btrfs
 sub-volumes
To: Al Viro <viro@ZenIV.linux.org.uk>
References: <56CF5490.7040102@suse.cz> <56D04630.1020809@gmail.com>
 <56D0743F.9040102@suse.cz> <56D07FAF.3080605@gmail.com>
 <20160226175311.GC17997@ZenIV.linux.org.uk> <56D0A38B.3050701@suse.cz>
 <56D0B007.2050106@gmail.com> <56D0B782.20606@suse.cz>
 <20160226210302.GE17997@ZenIV.linux.org.uk>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Message-ID: <56D0C572.3050503@suse.cz>
Date: Fri, 26 Feb 2016 22:36:50 +0100
MIME-Version: 1.0
In-Reply-To: <20160226210302.GE17997@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Feb 26, 2016 at 22:03 Al Viro wrote:
And I'm not sure how
> to deal with -o loop in a sane way, TBH - automagical losetup is bloody
> hard to get right.

See another reply in this thread for the idea:
Fri, 26 Feb 2016 22:00:44 +0100

> Keep in mind that loop-over-loop is also possible...

Indeed! Let's remember that mount(8) should never do it.

# losetup /dev/loop0 /dev/sda2
# losetup /dev/loop1 /dev/loop0
# losetup -l
NAME       SIZELIMIT OFFSET AUTOCLEAR RO BACK-FILE
/dev/loop0         0      0         0  0 /dev/sda2
/dev/loop1         0      0         0  0 /dev/loop0


But it actually does, if the command line is "overlooped":

oct:~ # mount -oloop /dev/loop1 /mnt

as it does exactly that:
oct:~ # losetup -l
NAME       SIZELIMIT OFFSET AUTOCLEAR RO BACK-FILE
/dev/loop0         0      0         0  0 /dev/sda2
/dev/loop1         0      0         0  0 /dev/loop0
/dev/loop2         0      0         1  0 /dev/loop1

It should definitely report error whenever trying -oloop on top of
anything else than a file. Or at least a warning.

Well, even losetup should report a warning.

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
