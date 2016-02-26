Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60307 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423111AbcBZTbp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Feb 2016 14:31:45 -0500
Subject: Re: loop subsystem corrupted after mounting multiple btrfs
 sub-volumes
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
References: <56CF5490.7040102@suse.cz> <56D04630.1020809@gmail.com>
 <56D0743F.9040102@suse.cz> <56D07FAF.3080605@gmail.com>
 <56D08647.2010508@suse.cz> <56D097D7.9020907@gmail.com>
From: Stanislav Brabec <sbrabec@suse.cz>
Message-ID: <56D0A81F.2050405@suse.cz>
Date: Fri, 26 Feb 2016 20:31:43 +0100
MIME-Version: 1.0
In-Reply-To: <56D097D7.9020907@gmail.com>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Feb 26, 2016 at 19:22 Austin S. Hemmelgarn wrote:
> The first commit is just test cases, and the others are specific issues
> that only affected BTRFS which have nothing to do with this thread at
> all other than involving mount(8) and BTRFS.

Yes, it is a bit off topic. It just demonstrates, how complex mount(8) 
for btrfs is.

The test case is all-fail in util-linux 2.27.1.

> mount(8) behavior has the potential to cause either data
> corruption or similar behavior in the future (I would expect that XFS
> with metadata checksumming enabled would cause a similar interaction,
> although they probably would handle it better).

Especially "mount -a" has a hard time to recognize what was already 
mounted and what still needs to be mounted.

The only information mount(8) has is the one from mountinfo. 
Interpreting of the mountinfo contents to reconstruct possible mount 
options used is a task far from being trivial.

Some of them are even impossible to discriminate:

Suppose you have:
mount -osubvol=/ /dev/sda2 /mnt/1
mount -osubvol=/sbv /dev/sda2 /mnt/2

Case 1:
mount -obind /mnt/1/sbv/bnd /mnt/3

Case 2:
mount -obind /mnt/2/bnd /mnt/3

Case 1 and case 2 have exactly the same mountinfo, but different 
reference counts for /mnt/1 and /mnt/2.

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
