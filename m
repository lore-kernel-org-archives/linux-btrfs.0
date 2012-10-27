Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from loup.kjorling.se ([87.237.208.114]:54831 "EHLO loup.kjorling.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab2J0XCY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Oct 2012 19:02:24 -0400
Received: from yeono.kjorling.se (c-1717e655.6036809--62697410.cust.bredbandsbolaget.se [85.230.23.23])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "yeono", Issuer "yeono" (not verified))
	by loup.kjorling.se (Postfix) with ESMTPS id A2D31B914008
	for <linux-btrfs@vger.kernel.org>; Sat, 27 Oct 2012 23:02:00 +0000 (UTC)
Received: from yeono.kjorling.se (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(Client did not present a certificate)
	by yeono (Postfix) with ESMTPS id 2066D47E2B6
	for <linux-btrfs@vger.kernel.org>; Sun, 28 Oct 2012 01:02:00 +0200 (CEST)
Date: Sat, 27 Oct 2012 23:01:58 +0000
From: Michael =?utf-8?B?S2rDtnJsaW5n?= <michael@kjorling.se>
To: linux-btrfs@vger.kernel.org
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
Message-ID: <20121027230158.GY2381@yeono.kjorling.se>
References: <50899151.1070503@inwind.it>
 <201210271843.40540.Martin@lichtvoll.de>
 <20121027195513.GS2381@yeono.kjorling.se>
 <201210280030.45190.Martin@lichtvoll.de>
 <20121027223812.GB5042@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20121027223812.GB5042@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 27 Oct 2012 23:38 +0100, from hugo@carfax.org.uk (Hugo Mills):
>>>            Data: RAID 0   System: RAID 1   Unused
>>> /dev/vdb     307.25 MB                -        2.23 GB
>>> /dev/vdc     307.25 MB             8 MB        2.69 GB
>>> /dev/vdd     307.25 MB             8 MB        2.24 GB
>>>            ============   ==============   ============
>>> TOTAL        921.75 MB            16 MB        7.16 GB
>> 
>> It would scale better with the number of drives and there is a good way to 
>> place the totals.
> 
>    Note that this could get arbitrarily wide in the presence of the
> (planned) per-object replication config. Otherwise, it works. The
> width is probably likely to grow more slowly than the length, though,
> so this way round is probably the better option. IMO. Eggshell blue is
> good enough. :)

Of course, but the suggestion in the mail I replied to can get equally
arbitrarily wide in the presence of a large number of _drives_.

In my experience, many times it's better to put something together
that works with the current status of the project and start using it,
than trying to shoehorn every "we'd like to do this some day" feature
into the original design. _Particularly_ when it's UI one is talking
about. I can think of a few ways it might be possible to restrict the
growth of the width of a table like this even in the face of separate
per-object replication settings, the most obvious probably being to
keep a tally on disk for each of the replication types, and have
columns for each replication configuration (so you might get one
column for RAID 0 data, one for RAID 1 data, one for SINGLE data, and
so on, but you'll _never_ get more "data" columns than the filesystem
itself supports replication methods for "data" data; the tally simply
being an optimization so you don't have to scan the whole file system
for a simple "df"), but by the time that feature gets implemented,
maybe someone can think of a better presentation.

After all, UI aspects tend to be the easiest to fiddle with.

Organizing the drives in rows also has the advantage that you don't
_have_ to read everything before you can start printing the results,
if you can live with the constraint of supporting only one data and
metadata replication strategy. Whether to implement it that way is
another matter. With large storage systems and multi-CPU/multi-core
systems, while a multithreaded approach might not provide consistent
device ordering between executions depending on the exact thread
execution order, it could provide a fair performance enhancement. And
forget KISS; don't we all _love_ a chance to do a little multithreaded
programming before coffee if it saves the poor sysadmin a few dozen
milliseconds per "df"? ;-)

-- 
Michael Kjörling • http://michael.kjorling.se • michael@kjorling.se
                “People who think they know everything really annoy
                those of us who know we don’t.” (Bjarne Stroustrup)
