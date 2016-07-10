Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:36325 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757180AbcGJUIE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Jul 2016 16:08:04 -0400
Received: by mail-oi0-f46.google.com with SMTP id n8so21030637oif.3
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Jul 2016 13:08:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <31d22f36-b97a-c150-3125-576a830e08c1@gmail.com>
References: <cc4fd464-271c-6b32-263c-ae91c19b8712@gmail.com>
 <CAJCQCtQoCtbt5NrggHPp+WrwUKbJ0nah4s6nJ0mPnKsGQ5i63Q@mail.gmail.com>
 <95f58623-95a4-b5d2-fa3a-bfb957840a31@gmail.com> <CAJCQCtSczHoBYyKB1DTyqGngdvC+BHtnXeZiG=1QHWkAWFO6EA@mail.gmail.com>
 <dc944146-50ce-b2fd-189c-a2c9f5a957c3@gmail.com> <CAJCQCtTPXY7=9vi9Ai2VrCEHzsEj_J0gurAVH5JGLJYmKmUpPw@mail.gmail.com>
 <577B2E1D.5070808@gmail.com> <CAJCQCtSW+3eA-amrGgQAds1F8sYPDPgTB9x49RjWnaq=vSePgw@mail.gmail.com>
 <b9647ec5-fe9b-4bfe-97d1-329f47dbf7b0@gmail.com> <CAJCQCtRPhn0i0MkPn1QFr0wqovwQkuEdZ=eWtRZ0QR3O5z5T+w@mail.gmail.com>
 <04874cd6-b043-2743-8e6e-f0ebd61400ed@gmail.com> <CAJCQCtTAMHYBQ+PCrrsMcRW_yhyp8dqmOrLsujEHxy+jq1rOrw@mail.gmail.com>
 <3a554136-ba08-0b9d-7ef7-7a9d6c42f217@gmail.com> <CAJCQCtSuVzykDn+Xk31dSjdgRVOhGxy77dAwuo2aTeAB7XY8hw@mail.gmail.com>
 <0b23ddfd-c1df-4837-ef13-7df027c88508@gmail.com> <CAJCQCtSA9TXO5dEZ-77hoFnc3VAa+81KRoEx9CoJhfStvW3O0A@mail.gmail.com>
 <31d22f36-b97a-c150-3125-576a830e08c1@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 10 Jul 2016 14:08:02 -0600
Message-ID: <CAJCQCtSiEz_rQxkSqiDb=dXTKgRPgBHWrJNVbv27-5_bZvTUEg@mail.gmail.com>
Subject: Re: Unable to mount degraded RAID5
To: =?UTF-8?B?VG9tw6HFoSBIcmRpbmE=?= <thomas.rkh@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 10, 2016 at 1:01 AM, Tomáš Hrdina <thomas.rkh@gmail.com> wrote:

> sudo btrfs check --repair /dev/sdc
> enabling repair mode
> parent transid verify failed on 7008807157760 wanted 70175 found 70133
> parent transid verify failed on 7008807157760 wanted 70175 found 70133
> checksum verify failed on 7008807157760 found F192848C wanted 1571393A
> checksum verify failed on 7008807157760 found F192848C wanted 1571393A
> bytenr mismatch, want=7008807157760, have=65536
> Checking filesystem on /dev/sdc
> UUID: 2dab74bb-fc73-4c47-a413-a55840f6f71e
> checking extents
> parent transid verify failed on 7009468874752 wanted 70180 found 70133
> parent transid verify failed on 7009468874752 wanted 70180 found 70133
> checksum verify failed on 7009468874752 found 2B10421A wanted CFF3FFAC
> checksum verify failed on 7009468874752 found 2B10421A wanted CFF3FFAC
> bytenr mismatch, want=7009468874752, have=65536
> parent transid verify failed on 7008859045888 wanted 70175 found 70133
> parent transid verify failed on 7008859045888 wanted 70175 found 70133
> checksum verify failed on 7008859045888 found 7313A127 wanted 97F01C91
> checksum verify failed on 7008859045888 found 7313A127 wanted 97F01C91
> bytenr mismatch, want=7008859045888, have=65536
> parent transid verify failed on 7008899547136 wanted 70175 found 70133
> parent transid verify failed on 7008899547136 wanted 70175 found 70133
> checksum verify failed on 7008899547136 found 2B6F9045 wanted CF8C2DF3
> parent transid verify failed on 7008899547136 wanted 70175 found 70133
> Ignoring transid failure
> leaf parent key incorrect 7008899547136
> bad block 7008899547136
> Errors found in extent allocation tree or chunk allocation
> parent transid verify failed on 7009074167808 wanted 70175 found 70133
> parent transid verify failed on 7009074167808 wanted 70175 found 70133
> checksum verify failed on 7009074167808 found FDA6D1F0 wanted 19456C46
> checksum verify failed on 7009074167808 found FDA6D1F0 wanted 19456C46
> bytenr mismatch, want=7009074167808, have=65536


OK well it was all a goose chase then. These are all the same messages
from 4 days ago also. The central problem appears to be checksum
verifications on multiple blocks, which really doesn't make sense to
me because it should be able to reconstruct from parity.

How is it possible to have four root trees, all of which point to
different leaf/nodes, all of which have some kind of checksum failure?
None of them are good? And none of them can be reconstructed? Sounds
fishy.

You try to plug each of those bytenr's into

btrfs-debug-tree -b <bytenr>  and see if it'll show you what leaf
information is there that it doesn't like. But if there's a csum
mismatch, it may refuse to show anything, rather than show it and say
it's unreliable due to csum mismatch.  If it refuses to show it you
could plug each of those failed bytenrs into

btrfs-map-logical -l <bytenr> and get a device and physical sector,
then you can get the entire leaf, compute a new csum and overwrite the
current one. That way it now passes csum and see if that's the only
problem, or if there's another brick wall later. Of course, if the
csum was correct, and it's the metadata that's bad, honoring bad
metadata as valid might cause a bad fix and then the whole thing
implodes. But you're pretty much there already I'd say.

If I were to pick an address to start with, it'd be this one.

> leaf parent key incorrect 7008899547136
> bad block 7008899547136

But other than that, I'm out of ideas. It's completely reasonable to
just give up at this point.


-- 
Chris Murphy
