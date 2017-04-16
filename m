Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f176.google.com ([209.85.213.176]:35845 "EHLO
        mail-yb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752467AbdDPSDJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Apr 2017 14:03:09 -0400
Received: by mail-yb0-f176.google.com with SMTP id s22so2245235ybe.3
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Apr 2017 11:03:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b3d118de-b4ec-ef74-e8b4-bc8aaed8dd62@mendix.com>
References: <CAJCQCtTU6M1c-B1thYtTBidyEpM9AWPMSPU=NGxj3QHnqTM7+A@mail.gmail.com>
 <20170415183156.mmgm6t4rygm2mt3j@angband.pl> <CAJCQCtR3ZcyauCnJhDNp6rSFvnRWcNy2UsWJsbPJEyR+4tsiEA@mail.gmail.com>
 <20170415185049.ig65w5pi22d42ajm@angband.pl> <CAJCQCtTyGHUFVsXcK35N3fA_xjb04UGo+j7UFaf2_Aj6pFs0_Q@mail.gmail.com>
 <b3d118de-b4ec-ef74-e8b4-bc8aaed8dd62@mendix.com>
From: Chris Murphy <chris@colorremedies.com>
Date: Sun, 16 Apr 2017 12:03:08 -0600
Message-ID: <CAJCQCtQLdaz2pWfNhV=-wgtU8detESZcCsnD6LZ5-vZmycmj2A@mail.gmail.com>
Subject: Re: remount and conflicting ssd options?
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: Adam Borowski <kilobyte@angband.pl>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 15, 2017 at 6:41 PM, Hans van Kranenburg
<hans.van.kranenburg@mendix.com> wrote:
> On 04/15/2017 10:35 PM, Chris Murphy wrote:

>> I have a performance test based on doing a bunch of system updates
>> (~100 rpm packages), and even with the same mount options, back to
>> back tests are sufficiently inconsistent that I can't tell which of
>> the allocator options is better.
>
> Do you run the test with exact the same starting point (all bits on disk
> in the same place, drop caches), or do you run it over and over again
> while the filesystem is deepening its own grave every time?

Once staged, over a dozen snapshots are made in quick succession. The
filesystem is balanced, and fstrim has been issued. The update is of
course deleting files within a given fstree, but because those extents
are pinned due to snapshots, they aren't deleted and thus no holes.
Within each snapshot, there's nothing being created and then later
deleted in which free space fragments would develop. Except
maybe...(see below). Each snapshot is used to setup a chroot to do the
update in. Anyway, the results are all over the map, and it's not
small amounts. 5m7 for one run, then 6m20s for the next, then 4m7s for
the next. It's useless without doing maybe 1/2 dozen or more for each
set of tests, it's just too noisy.

The one thing I can say makes an obvious hit is notreelog. All other
results are 4-7 minutes long, but this one off test was 12 minutes.
This tells me there's some fsyncing going on with either dnf or rpm
itself. But not much more than this.



>> Plus then on spinning rust people have
>> reported better performance with ssd rather than the default of nossd.
>> While others who are using iSCSI end up with ssd by default and worse
>> results than with nossd.
>
> <rant:)>So far we learned that the options were designed for the types
> of SSD that you would be able to buy 10 years ago, that they cause
> changes in write behaviour and that they tend to forget to take
> (recursive-exploding) cow overhead for metadata writes into account.</rant>

And we have four totally separate classes of SSD: USB flash drives, SD
Cards, SATA SSD, NVMe.

The more mysterious one to me is when doing updates on HDD, there
seems to be a lot of head seeking. Granted there's data, and two
metadata chunks, as well as the log tree which I know each subvolume
has its own, but maybe this log tree is a cause of fragmentation. It
could certainly write out a fair bit of data, and is not subject to
snapshots pinning those sectors. Is the same space used over and over
again, kinda like the ext4 or XFS journal? Or does it meander? Anyway,
I'd think on both iSCSI and anything rotational, you want the fs doing
more sequential writes both for data and metadata, and that there's a
lot more room for optimization some day.


-- 
Chris Murphy
