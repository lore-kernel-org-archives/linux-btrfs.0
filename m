Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:56367 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1162723AbdD2Kqr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Apr 2017 06:46:47 -0400
Received: from 82-132-217-35.dab.02.net ([82.132.217.35]:50834 helo=ty.sabi.co.UK)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1d4Ptk-001ZlU-U5
        for linux-btrfs@vger.kernel.org; Sat, 29 Apr 2017 11:46:45 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1d4PtW-0002Ze-Mi
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Apr 2017 11:46:30 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22788.28422.362659.671282@tree.ty.sabi.co.uk>
Date: Sat, 29 Apr 2017 11:46:30 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs, journald logs, fragmentation, and fallocate
In-Reply-To: <20170428201446.4o4ftxqsqrqpaits@angband.pl>
References: <CAJCQCtQk1p6rzUYaO19ei51YC+w1uj1qJ77OdLmL5JN3w1zNfw@mail.gmail.com>
        <5fd31e68-0199-8935-0873-78b4e7c6eb69@inwind.it>
        <CAJCQCtQCV2DmpsEFtRVdJDMkT54bzbU66+5W873mpJAyXf5k9A@mail.gmail.com>
        <20170428201446.4o4ftxqsqrqpaits@angband.pl>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> [ ... ] Instead, you can use raw files (preferably sparse unless
> there's both nocow and no snapshots). Btrfs does natively everything
> you'd gain from qcow2, and does it better: you can delete the master
> of a cloned image, deduplicate them, deduplicate two unrelated images;
> you can turn on compression, etc.

Uhmmmmm, I understand this argument in the general case (not
specifically as to QCOW2 images), and it has some merit, but it is
"controversial", as there are two counterarguments:

* Application specifici file formats can match better application
  specific requirements.
* Putting advanced functionality into the filesystem code makes it more
  complex and less robust, and Btrfs is a bit of a major example of the
  consequences. I put compression and deduplication as things that I
  reckon make a filesystem too complex.

As to snapshots, I make a difference between filetree snapshots and file
snapshots: the first clones a tree as of the snapshot moment, and it is
a system management feature, the second provides per-file update
rollback. One sort of implies the other, but using the per-file rollback
*systematically*, that is a a feature an application can rely one seems
a bit dangerous to me.

> Once you pay the btrfs performance penalty,

Uhmmmmmmmmmmm, Btrfs has a small or negative performance penalty as a
general purpose filesystem, and many (more or less well conceived) tests
show it performs up there with the best. The only two real costs I have
to it are the huge CPU cost of doing checksumming all the time, but
that's unavoidable if one wants checksumming, and that checksumming
usually requires metadata duplication, that is at least 'dup' profile
for metadata, and that is indeed a bit expensive.

> you may as well actually use its features,

The features that I think Btrfs gives that are worth using are
checksumming, metadata duplication, and filetree snapshots.

> which make qcow2 redundant and harmful.

My impression is that in almost all cases QCOW2 is harmful, because it
trades more IOPS and complexity for less disk space, and disk space is
cheap and IOPS and complexity are expensive, but of course a lot of
people know better :-). My preferred VM setup is a small essentially
read-only non-QCOW2 image for '/' and everything else mounted via NFSv4,
from the VM host itself or a NAS server, but again lots of people know
better and use multi-terabyte-sized QCOW2 images :-).
