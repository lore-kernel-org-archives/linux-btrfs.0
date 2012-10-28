Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from loup.kjorling.se ([87.237.208.114]:40449 "EHLO loup.kjorling.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855Ab2J1LTW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Oct 2012 07:19:22 -0400
Date: Sun, 28 Oct 2012 11:18:58 +0000
From: Michael =?utf-8?B?S2rDtnJsaW5n?= <michael@kjorling.se>
To: kreijack@inwind.it
Cc: Martin Steigerwald <Martin@lichtvoll.de>, Hugo Mills <hugo@carfax.org.uk>,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
Message-ID: <20121028111858.GC2381@yeono.kjorling.se>
References: <50899151.1070503@inwind.it>
 <20121027223812.GB5042@carfax.org.uk>
 <508CF08D.8060203@gmail.com>
 <201210281138.02590.Martin@lichtvoll.de>
 <508D1015.6050100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <508D1015.6050100@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 28 Oct 2012 11:59 +0100, from kreijack@gmail.com (Goffredo Baroncelli):
> On 2012-10-28 11:38, Martin Steigerwald wrote:
>> But still if if can be arbitrarily long due to that per object replication 
>> config, a vertical output might and leaving graphical representation to a 
>> Qt Quick application or so might be better.
> 
> Yes, this is my same feel: For console I prefer a text representation in
> rows, leaving to a graphical GUI to show the information in columns..

So a sysadmin who logs on to a server (which uses btrfs) over plain
SSH should need to install a good chunk of X11 plus a load of support
libraries on the server, plus have a X11 server on the machine they
are connecting from, simply to get a tabular view of the disk space?

That _might_ fly in a strictly *nix environment. In a mixed
*nix/Windows (and maybe even throw in some Mac OS X) environment, not
necessarily as much so. And what about the sysadmin on the road who
logs on using a smartphone SSH client to get a quick overview of the
disk usage situation because they received an alert that disk space is
starting to run low?

It appears to me that what is being discussed here is, to some extent,
an edge case of use of a file system feature that hasn't even been
implemented yet, but rather is only planned. Like Martin pointed out,
scripts should not parse meant-for-human-consumption output anyway,
and beyond trivial greps and that kind of parsing, tabular data by
design lends itself rather poorly to script parsing anyway.

I would personally really prefer a tabular view that perhaps does not
show _all_ details when no explicit parameters are given, and a
"--dump" or similar that will give a fuller data dump that might lend
itself better to parsing by other tools for a more thorough
presentation. The data is all right there; it's basically a matter of
deciding how much of it to show by default.

-- 
Michael Kjörling • http://michael.kjorling.se • michael@kjorling.se
                “People who think they know everything really annoy
                those of us who know we don’t.” (Bjarne Stroustrup)
