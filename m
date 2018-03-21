Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:60035 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752958AbeCUUCk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 16:02:40 -0400
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.27])
        by mailgw-01.dd24.net (Postfix) with ESMTP id 2E9455FD8A
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Mar 2018 20:02:39 +0000 (UTC)
Received: from mailgw-01.dd24.net ([192.168.1.35])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10235)
        with ESMTP id TzFxVauxuY79 for <linux-btrfs@vger.kernel.org>;
        Wed, 21 Mar 2018 20:02:37 +0000 (UTC)
Received: from heisenberg-old.fritz.box (ppp-82-135-94-250.dynamic.mnet-online.de [82.135.94.250])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailgw-01.dd24.net (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Mar 2018 20:02:37 +0000 (UTC)
Message-ID: <1521662556.4312.39.camel@scientia.net>
Subject: Re: Status of RAID5/6
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: linux-btrfs@vger.kernel.org
Date: Wed, 21 Mar 2018 21:02:36 +0100
In-Reply-To: <CANQeFDDxZSZ4jYDPvW-Q=AoyPrGzpp0fVywjFOJtkeD+Ysgmew@mail.gmail.com>
References: <CAJVZm6dkZmSpnV3wz4sfOMzMCP36Mrt+-2J7o0mU4z=dEYQqQQ@mail.gmail.com>
         <CANQeFDDxZSZ4jYDPvW-Q=AoyPrGzpp0fVywjFOJtkeD+Ysgmew@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey.

Some things would IMO be nice to get done/clarified (i.e. documented in
the Wiki and manpages) from users'/admin's  POV:

Some basic questions:
- Starting with which kernels (including stable kernel versions) does
it contain the fixes for the bigger issues from some time ago?

- Exactly what does not work yet (only the write hole?)?
  What's the roadmap for such non-working things?

- Ideally some explicit confirmations of what's considered to work,
  like:
  - compression+raid?
  - rebuild / replace of devices?
  - changing raid lvls?
  - repairing data (i.e. picking the right block according to csums in
    case of silent data corruption)?
  - scrub (and scrub+repair)?
  - anything to consider with raid when doing snapshots, send/receive
    or defrag?
  => and for each of these: for which raid levels?

  Perhaps also confirmation for previous issues:
  - I vaguely remember there were issues with either device delete or
    replace.... and that one of them was possibly super-slow?
  - I also remember there were cases in which a fs could end up in
    permanent read-only state?


- Clarifying questions on what is expected to work and how things are
  expected to behave, e.g.:
  - Can one plug a device (without deleting/removing it first) just
    under operation and will btrfs survive it?
  - If an error is found (e.g. silent data corruption based on csums),
    when will it repair&fix (fix = write the repaired data) the data?
    On the read that finds the bad data?
    Only on scrub (i.e. do users need to regularly run scrubs)? 
  - What happens if error cannot be repaired, e.g. no csum information
    or all blocks bad?
    EIO? Or are there cases where it gives no EIO (I guess at least in
    nodatacow case)
  - What happens if data cannot be fixed (i.e. trying to write the
    repaired block again fails)?
    And if the repaired block is written, will it be immediately
    checked again (to find cases of blocks that give different results
    again)?
  - Will a scrub check only the data on "one" device... or will it
    check all the copies (or parity blocks) on all devices in the raid?
  - Does a fsck check all devices or just one?
  - Does a balance implicitly contain a scrub?
  - If a rebuild/repair/reshape is performed... can these be
    interrupted? What if they are forcibly interrupted (power loss)?


- Explaining common workflows:
  - Replacing a faulty or simply an old disk.
    How to stop btrfs from using a device (without bricking the fs)?
    How to do the rebuild.
  - Best practices, like: should one do regular balances (and if so, as
    asked above, do these include the scrubs, so basically: is it
    enough to do one of them)
  - How to grow/shrink raid btrfs... and if this is done... how to
    replicate the data already on the fs to the newly added disks (or
    is this done automatically - and if so, how to see that it's
    finished)?
  - What will actually trigger repairs? (i.e. one wants to get silent
    block errors fixed ASAP and not only when the data is read - and
    when it's possibly to late)
  - In the rebuild/repair phase (e.g. one replaces a device): Can one
    somehow give priority to the rebuild/repair? (e.g. in case of a
    degraded raid, one may want to get that solved ASAP and rather slow
    down other reads or stop them completely.
  - Is there anything to notice when btrfs raid is placed above dm-
    crypt from a security PoV?
    With MD raid that wasn't much of a problem as it's typically placed
    below dm-crypt... but btrfs raid would need to be placed above it.
    So maybe there are some known attacks against crypto modes, if
    equal (RAID 1 / 10) or similar/equal (RAID 5/6) data is written
    above multiple crypto devices? (Probably something one would need
    to ask their experts).


- Maintenance tools
  - How to get the status of the RAID? (Querying kernel logs is IMO
    rather a bad way for this)
    This includes:
    - Is the raid degraded or not?
    - Are scrubs/repairs/rebuilds/reshapes in progress and how far are
      they? (Reshape would be: if the raid level is changed or the raid
      grown/shrinked: has all data been replicated enough to be
      "complete" for the desired raid lvl/number of devices/size?
   - What should one regularly do? scrubs? balance? How often?
     Do we get any automatic (but configurable) tools for this?
   - There should be support in commonly used tools, e.g. Icinga/Nagios
     check_raid
   - Ideally there should also be some desktop notification tool, which
     tells about raid (and btrfs errors in general) as small
     installations with raids typically run no Icinga/Nagios but rely
     on e.g. email or gui notifications.

I think especially for such tools it's important that these are
maintained by upstream (and yes I know you guys are rather fs
developers not)... but since these tools are so vital, having them done
3rd party can easily lead to the situation where something changes in
btrfs, the tools don't notice and errors remain undetected.


- Future?
  What about things like hotspare support? E.g. a good userland tool
  could be configured that one disk is a hotspare... and if there's
  failure it could automatically power it up and replace the faulty
  drives with it.
  It could go further, that not only completely failed devices are
  replaced, but if a configurable number of csum / read / write / etc.
  errors are found... a replace would be triggered.
  Maybe such tool could even look at SMART and proactively replace
  disks.

  What about features that were "announced/suggested/etc." earlier?
  E.g. n-parity-raid ... or n-way-mirrored-raid?


- Real world test?
  Is there already any bigger user of current btrfs raid5/6? I.e. where
  hundreds of raids, devices, etc. are massively used? Where many
  devices failed (because of age) or where pulled, etc. (all the
  typical things that happen in computing centres)?
  So that one could get a feeling whether it's actually stable.


Cheers,
Chris.
