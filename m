Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:39521 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S642751AbdD1UOt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Apr 2017 16:14:49 -0400
Date: Fri, 28 Apr 2017 22:14:46 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Chris Murphy <lists@colorremedies.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs, journald logs, fragmentation, and fallocate
Message-ID: <20170428201446.4o4ftxqsqrqpaits@angband.pl>
References: <CAJCQCtQk1p6rzUYaO19ei51YC+w1uj1qJ77OdLmL5JN3w1zNfw@mail.gmail.com>
 <5fd31e68-0199-8935-0873-78b4e7c6eb69@inwind.it>
 <CAJCQCtQCV2DmpsEFtRVdJDMkT54bzbU66+5W873mpJAyXf5k9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtQCV2DmpsEFtRVdJDMkT54bzbU66+5W873mpJAyXf5k9A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 28, 2017 at 11:41:00AM -0600, Chris Murphy wrote:
> The same behavior happens with NTFS in qcow2 files. They quickly end
> up with 100,000+ extents unless set nocow. It's like the worst case
> scenario.

You should never use qcow2 on btrfs, especially if snapshots are involved.
They both do roughly the same thing, and layering fragmentation upon
fragmentation ɪꜱ ɴᴏᴛ ᴘʀᴇᴛᴛʏ.  Layering syncs is bad, too.

Instead, you can use raw files (preferably sparse unless there's both nocow
and no snapshots).  Btrfs does natively everything you'd gain from qcow2,
and does it better: you can delete the master of a cloned image, deduplicate
them, deduplicate two unrelated images; you can turn on compression, etc.

Once you pay the btrfs performance penalty, you may as well actually use its
features, which make qcow2 redundant and harmful.


Meow!
-- 
Don't be racist.  White, amber or black, all beers should be judged based
solely on their merits.  Heck, even if occasionally a cider applies for a
beer's job, why not?
On the other hand, corpo lager is not a race.
