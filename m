Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:33996 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750994AbdI3Oxd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Sep 2017 10:53:33 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:39500)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1dyJ91-0002dr-BY
        for linux-btrfs@vger.kernel.org; Sat, 30 Sep 2017 15:53:31 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1dyJ8w-0002Q7-IV
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Sep 2017 15:53:26 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <22991.45029.564275.154171@tree.ty.sabi.co.uk>
Date: Sat, 30 Sep 2017 15:53:25 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: What means "top level" in "btrfs subvolume list" ?
In-Reply-To: <762acea0-3f55-4fc0-c5eb-604304152f3e@inwind.it>
References: <762acea0-3f55-4fc0-c5eb-604304152f3e@inwind.it>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I am trying to figure out which means "top level" in the
> output of "btrfs sub list"

The terminology (and sometimes the detailed behaviour) of Btrfs
is not extremely consistent, I guess because of permissive
editorship of the design, in a "let 1000 flowers bloom" sort
of fashion so that does not matter a lot.

> [ ... ] outputs a "top level ID" equal to the "parent ID" (on
> the basis of the code).

You could have used option '-p' and it would have printed out
both "top level ID" and "parent ID" for extra enlightenment.

> But I am still asking which would be the RIGHT "top level id".

But perhaps one of them is now irrelevant, because 'man btrfs
subvolume says:

  "If -p is given, then parent <ID> is added to the output
  between ID and top level. The parent’s ID may be used at mount
  time via the subvolrootid= option."

and 'man 5 btrfs' says:

  "subvolrootid=objectid
    (irrelevant since: 3.2, formally deprecated since: 3.10)
    A workaround option from times (pre 3.2) when it was not
    possible to mount a subvolume that did not reside directly
    under the toplevel subvolume."

> My Hypothesis, it should be the ID of the root subvolume ( or
> 5 if it is not mounted). [ ... ]

Well, a POSIX filesystem typically has a root directory, and it
can be mounted as the system root or any other point. A Btrfs
filesystem has multiple root directories, that are mounted by
default "somewhere" (a design decision that I think was unwise,
but "whatever").

The subvolume containing the mountpoint directory of another
subvolume's root directory is is no way or sense its "parent",
as there is no derivation relationship; root directories are
independent of each other and their mountpoint is (or should be)
a runtime entity.

If there is a "parent" relationship that maybe be between
snapshot and origin subvolume (ignoring 'send'/'receive'...),
and I have created a few plain and snapshot subvolumes and I get
this rather "confusing" output from version 4.4 of the 'btrfs'
command:

  base# btrfs subvol list -uq -a -p /fs/sda7 | sort -k 6,6n -k 8,8
  ID 257 gen 718 parent 5 top level 5 parent_uuid - uuid 2d7b0606-76d9-f24b-8f75-d20a5c0f3521 path =
  ID 356 gen 719 parent 5 top level 5 parent_uuid - uuid 9d201029-d2bf-2f43-8381-8c19d090483e path sl1
  ID 358 gen 719 parent 5 top level 5 parent_uuid 2d7b0606-76d9-f24b-8f75-d20a5c0f3521 uuid bc0e6a33-b5dc-4d48-b2db-1452b705d227 path sn1
  ID 357 gen 715 parent 356 top level 356 parent_uuid - uuid 2abc6399-956d-894f-836b-32eb5b603654 path <FS_TREE>/sl1/sl2
  ID 360 gen 718 parent 356 top level 356 parent_uuid 2d7b0606-76d9-f24b-8f75-d20a5c0f3521 uuid ad896822-e9a5-c645-8cfd-0aca7f5a2298 path <FS_TREE>/sl1/sn3
  ID 361 gen 719 parent 356 top level 356 parent_uuid bc0e6a33-b5dc-4d48-b2db-1452b705d227 uuid 9c1390d2-e485-cb4a-a41b-670248587bfb path <FS_TREE>/sl1/sn4
  ID 359 gen 717 parent 358 top level 358 parent_uuid 2d7b0606-76d9-f24b-8f75-d20a5c0f3521 uuid 72d4f943-2881-6442-b398-2277be8f2fec path <FS_TREE>/sn1/sn2

The "confusion" is that for some subvolumes the "parent" is the
same but the "parent_uuid" is different, and viceversa.
IIRC this has already been mentioned in part elsewhere.
