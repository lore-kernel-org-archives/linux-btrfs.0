Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from loup.kjorling.se ([87.237.208.114]:52585 "EHLO loup.kjorling.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932960Ab2J0Tzg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Oct 2012 15:55:36 -0400
Received: from yeono.kjorling.se (c-1717e655.6036809--62697410.cust.bredbandsbolaget.se [85.230.23.23])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "yeono", Issuer "yeono" (not verified))
	by loup.kjorling.se (Postfix) with ESMTPS id E0842B914008
	for <linux-btrfs@vger.kernel.org>; Sat, 27 Oct 2012 19:55:14 +0000 (UTC)
Received: from yeono.kjorling.se (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(Client did not present a certificate)
	by yeono (Postfix) with ESMTPS id 7A50B47E1BE
	for <linux-btrfs@vger.kernel.org>; Sat, 27 Oct 2012 21:55:14 +0200 (CEST)
Date: Sat, 27 Oct 2012 19:55:13 +0000
From: Michael =?utf-8?B?S2rDtnJsaW5n?= <michael@kjorling.se>
To: linux-btrfs@vger.kernel.org
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
Message-ID: <20121027195513.GS2381@yeono.kjorling.se>
References: <50899151.1070503@inwind.it>
 <201210271843.40540.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <201210271843.40540.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 27 Oct 2012 18:43 +0200, from Martin@lichtvoll.de (Martin Steigerwald):
> Possibly this could be done tabular as well, like:
> 
>                         vdb		vdc		vdd
> Data, RAID 0	307,25MB	307,25MB	307,25MB
> …
> System,RAID1	-		8MB		8MB
> …
> Unused		2,23GB	2,69GB	2,24GB
> 
> I like this. But what if the filesystem has 100 disks?

Maybe I'm just not familiar enough with btrfs yet to punch an
immediate hole in the idea, but how about pivoting that table? Columns
for data values ("data, raid 0", "system, raid 1", "unused", ...) and
rows for the underlying devices? Something like this, copying the
numbers from your example. And I'm using colon here rather than comma,
because I _believe_ that it better captures the intent.

           Data: RAID 0   System: RAID 1   Unused
/dev/vdb     307.25 MB                -        2.23 GB
/dev/vdc     307.25 MB             8 MB        2.69 GB
/dev/vdd     307.25 MB             8 MB        2.24 GB
           ============   ==============   ============
TOTAL        921.75 MB            16 MB        7.16 GB

This feels like it should work quite well as long as only 3-5 columns
plus the device specifier are needed (which would appear to be the
case), and it gives a quick run-down of the numbers at a glance. If
the filesystem consists of a large number of devices, the header could
possibly be repeated just before the "total" row (then something like
"btrfs fi df | tail -n2" will still work for getting the executive
summary). The risk would be if extremely long device names are used,
but that should be relatively trivial to solve. Maybe something like
this if the terminal width does not allow the data for each device to
fit on a single line?

           Data: RAID 0   System: RAID 1   Unused
/dev/disk/by-uuid/f72d74f4-206d-11e2-aa11-cb4348b38f9e
             307.25 MB                -      2.23 GB
/dev/disk/by-uuid/044e48de-206e-11e2-8a63-8366c6174d47
             307.25 MB             8 MB      2.69 GB
/dev/disk/by-uuid/0b1309a2-206e-11e2-aa21-234780dc3782
             307.25 MB             8 MB      2.24 GB
           ============   ==============   ==========
TOTAL        921.75 MB            16 MB      7.16 GB

Both of the above, as you will note, are very similar to how GNU df
solves the same problem. Line breaking could also be disabled if
standard output is not a TTY, which means that for example passing the
output to grep would still work like one would expect.

Any reason why such an output format wouldn't work for a summary view?

-- 
Michael Kjörling • http://michael.kjorling.se • michael@kjorling.se
                “People who think they know everything really annoy
                those of us who know we don’t.” (Bjarne Stroustrup)
