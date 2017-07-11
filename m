Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:33716 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753932AbdGKWnJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Jul 2017 18:43:09 -0400
Received: by mail-wr0-f174.google.com with SMTP id r103so8933673wrb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Jul 2017 15:43:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170711164812.sj64s3nc2oe3ai3n@merlins.org>
References: <20170711062155.hvlx5ud4zphpzjnp@merlins.org> <CAJCQCtREGq4i5mn+PPB__dFLBvo8YrDeU_=GPHdzD1CuVYAfwg@mail.gmail.com>
 <20170711164812.sj64s3nc2oe3ai3n@merlins.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 11 Jul 2017 16:43:06 -0600
Message-ID: <CAJCQCtSYJqa=nJA0w+yiHvwzdiWF51PmrfUPGVUjm1MwbiNZaQ@mail.gmail.com>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960:
 errno=-17 Object already exists
To: Marc MERLIN <marc@merlins.org>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 11, 2017 at 10:48 AM, Marc MERLIN <marc@merlins.org> wrote:
> On Tue, Jul 11, 2017 at 10:00:40AM -0600, Chris Murphy wrote:
>> > ---[ end trace feb4b95c83ac065f ]---
>> > BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960: errno=-17 Object already exists
>> > BTRFS info (device dm-2): forced readonly
>>
>> You've already had this same traceback, not sure whether it's the same
>> file system or not, but it was 4.7.2 kernel.
>
> You have better memory than me. I'll admit that I'm kind of overwhelmed
> by all the time I'm currently spending/wasting on btrfs recovery and
> that came almost out of nowwhere and hit me in 3 different places :-/
>
>> Probably fixed in 4.9, no idea when. I would just use the most recent
>> 4.9 kernel you can get or build. Less chance of regressions in
>> longterm, greater chance of bug fixes. Same for 4.4.
>
> Fair suggestion. I jumped from 4.8 to 4.11. I'll build a 4.9 then.

Assuming it works, settle on 4.9 until 4.14 shakes out a bit. Given
your setup and the penalty for even small problems, it's probably
better to go low risk and that means longterm kernels. Maybe one of
the three systems can use a newer kernel just to make sure you're
regressions, if any, are contained, but otherwise avoid all eggs in
one basket approach.

Another option is cutting down the size of the array and going with a
gluster or ceph approach so the rebuilds aren't so hideously invasive.
You could also optionally use a different storage layout and file
system for a small subset of the bricks, either XFS on LVM RAID or
ZoL. Again, fewer eggs in one basket. But even if they're all Btrfs,
merely breaking things down makes for faster rebuilds, less downtime,
less stress. Because whether it's an unexplained regression, the never
finished fsck, a hardware bug, or a legit drive failure, you will
inevitably have brick problems. Something's always going to go wrong
eventually. Haha. Just throw more drives at the problem and have
gluster do some distributed replication so you can more easily lose
entire bricks like this.

-- 
Chris Murphy
