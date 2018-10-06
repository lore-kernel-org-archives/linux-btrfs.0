Return-Path: <SRS0=jasM=MS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D1EC00449
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Oct 2018 00:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 134B621473
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Oct 2018 00:36:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 134B621473
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cox.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbeJFHhp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Oct 2018 03:37:45 -0400
Received: from [195.159.176.226] ([195.159.176.226]:38502 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbeJFHhp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Oct 2018 03:37:45 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1g8aXz-0001MG-6v
        for linux-btrfs@vger.kernel.org; Sat, 06 Oct 2018 02:34:19 +0200
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-btrfs@vger.kernel.org
From:   Duncan <1i5t5.duncan@cox.net>
Subject: Re: Understanding BTRFS RAID0 Performance
Date:   Sat, 6 Oct 2018 00:34:12 +0000 (UTC)
Message-ID: <pan$ed78e$c67857b4$3003fa74$eefe6b3@cox.net>
References: <54026c92-9cd1-2ac8-5747-c5405dd82087@panasas.com>
        <pan$77fbd$8ebaf02d$210deb71$a2b73f29@cox.net>
        <591cce01-0bdb-19ca-5454-1398283cd86e@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@blaine.gmane.org
User-Agent: Pan/0.146 (Hic habitat felicitas; 22c743dad)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Wilson, Ellis posted on Fri, 05 Oct 2018 15:29:52 +0000 as excerpted:

> Is there any tuning in BTRFS that limits the number of outstanding reads
> at a time to a small single-digit number, or something else that could
> be behind small queue depths?  I can't otherwise imagine what the
> difference would be on the read path between ext4 vs btrfs when both are
> on mdraid.

It seems I forgot to directly answer that question in my first reply.  
Thanks for restating it.

Btrfs doesn't really expose much performance tuning (yet?), at least 
outside the code itself.  There are a few very limited knobs, but they're 
just that, few and limited or broad-stroke.

There are mount options like ssd/nossd, ssd_spread/nossd_spread, the 
space_cache set of options (see below), flushoncommit/noflushoncommit, 
commit=<seconds>, etc (see the btrfs (5) manpage), but nothing really to 
influence stride length, etc, or to optimize chunk placement between ssd 
and non-ssd devices, for instance.

And there's a few filesystem features, normally set at mkfs.btrfs time 
(and thus covered in the mkfs.btrfs manpage) but some of which can be 
tuned later, but generally, the defaults have changed over time to 
reflect the best case, and the older variants are there primarily to 
retain backward compatibility with old kernels and tools that didn't 
handle the newer variants.

That said, as I think about it there are some tunables that may be worth 
experimenting with.  Most or all of these are covered in the btrfs (5) 
manpage.

* Given the large device numbers you mention and raid0, you're likely 
dealing with multi-TB-scale filesystems.  At this level, the 
space_cache=v2 mount option may be useful.  It's not the default yet as 
btrfs check, etc, don't yet handle it, but given your raid0 choice you 
may not be concerned about that.  Need only be given once after which v2 
is "on" for the filesystem until turned off.

* Consider experimenting with the thread_pool=n mount option.  I've seen 
very little discussion of this one, but given your interest in 
parallelization, it could make a difference.

* Possibly the commit=<seconds> (default 30) mount option.  In theory, 
upping this may allow better write merging, tho your interest seems to be 
more on the read side, and the commit time has consequences at crash time.

* The autodefrag mount option may be considered if you do a lot of 
existing file updates, as is common with database or VM image files.  Due 
to COW this triggers high fragmentation on btrfs, and autodefrag should 
help control that.  Note that autodefrag effectively increases the 
minimum extent size from 4 KiB to, IIRC, 16 MB, tho it may be less, and 
doesn't operate at whole-file size, so larger repeatedly-modified files 
will still have some fragmentation, just not as much.  Obviously, you 
wouldn't see the read-time effects of this until the filesystem has aged 
somewhat, so it may not show up on your benchmarks.

(Another option for such files is setting them nocow or using the 
nodatacow mount option, but this turns off checksumming and if it's on, 
compression for those files, and has a few other non-obvious caveats as 
well, so isn't something I recommend.  Instead of using nocow, I'd 
suggest putting such files on a dedicated traditional non-cow filesystem 
such as ext4, and I consider nocow at best a workaround option for those 
who prefer to use btrfs as a single big storage pool and thus don't want 
to do the dedicated non-cow filesystem for some subset of their files.)

* Not really for reads but for btrfs and any cow-based filesystem, you 
almost certainly want the (not btrfs specific) noatime mount option.

* While it has serious filesystem integrity implications and thus can't 
be responsibly recommended, there is the nobarrier mount option.  But if 
you're already running raid0 on a large number of devices you're already 
gambling with device stability, and this /might/ be an additional risk 
you're willing to take, as it should increase performance.  But for 
normal users it's simply not worth the risk, and if you do choose to use 
it, it's at your own risk.

* If you're enabling the discard mount option, consider trying with it 
off, as it can affect performance if your devices don't support queued-
trim.  The alternative is fstrim, presumably scheduled to run once a week 
or so.  (The util-linux package includes an fstrim systemd timer and 
service set to run once a week.  You can activate that, or equivalent 
cron job if you're not on systemd.)

* For filesystem features you may look at no_holes and skinny_metadata.  
These are both quite stable and at least skinny-metadata is now the 
default.  These are normally set at mkfs.btrfs time, but can be modified 
later.  Setting at mkfs time should be more efficient.

* At mkfs.btrfs time, you can set metadata --nodesize.  The newer default 
is 16 KiB, while the old default was the (minimum for amd64/x86) 4 KiB, 
and the maximum is 64 KiB.  See the mkfs.btrfs manpage for the details as 
there's a tradeoff, smaller sizes increase (metadata) fragmentation but 
decrease lock contention, while larger sizes pack more efficiently and 
are less fragmented but updating is more expensive.  The change in 
default was because 16 KiB was a win over the old 4 KiB for most use-
cases, but the 32 or 64 KiB options may or may not be, depending on use-
case, and of course if you're bottlenecking on locks, 4 KiB may still be 
a win.


Among all those, I'd be especially interested in what thread_pool=n does 
or doesn't do for you, both because it specifically mentions 
parallelization and because I've seen little discussion of it.

space_cache=v2 may also be a big boost for you, if you're filesystems are 
the size the 6-device raid0 implies and are at all reasonably populated.

(Metadata) nodesize may or may not make a difference, tho I suspect if so 
it'll be mostly on writes (but I'm not familiar with the specifics there 
so could be wrong).  I'd be interested to see if it does.

In general I can recommend the no_holes and skinny_metadata features but 
you may well already have them, and the noatime mount option, which you 
may well already be using as well.  Similarly, I ensure that all my btrfs 
are mounted from first mount with autodefrag, so it's always on as the 
filesystem is populated, but I doubt you'll see a difference from that in 
your benchmarks unless you're specifically testing an aged filesystem 
that would be heavily fragmented on its own.


There's one guy here who has done heavy testing on the ssd stuff and 
knows btrfs on-device chunk allocation strategies very well, having come 
up with a utilization visualization utility and been the force behind the 
relatively recent (4.16-ish) changes to the ssd mount option's allocation 
strategy.  He'd be the one to talk to if you're considering diving into 
btrfs' on-disk allocation code, etc.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

