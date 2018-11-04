Return-Path: <SRS0=b0aI=NP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D251AC32789
	for <linux-btrfs@archiver.kernel.org>; Sun,  4 Nov 2018 18:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B53F2081D
	for <linux-btrfs@archiver.kernel.org>; Sun,  4 Nov 2018 18:31:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B53F2081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cox.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729144AbeKEDrV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 4 Nov 2018 22:47:21 -0500
Received: from [195.159.176.226] ([195.159.176.226]:56637 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1727834AbeKEDrV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Nov 2018 22:47:21 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1gJN96-0001fO-MH
        for linux-btrfs@vger.kernel.org; Sun, 04 Nov 2018 19:29:12 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-btrfs@vger.kernel.org
From:   Duncan <1i5t5.duncan@cox.net>
Subject: Re: Filesystem mounts fine but hangs on access
Date:   Sun, 4 Nov 2018 18:29:06 +0000 (UTC)
Message-ID: <pan$e6d53$e629c484$21f89be5$9bcbe392@cox.net>
References: <f0e1900a-b242-06e0-b68f-0ddc146eca56@cs.uni-bonn.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@blaine.gmane.org
User-Agent: Pan/0.146 (Hic habitat felicitas; 22c743dad)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Sebastian Ochmann posted on Sun, 04 Nov 2018 14:15:55 +0100 as excerpted:

> Hello,
> 
> I have a btrfs filesystem on a single encrypted (LUKS) 10 TB drive which
> stopped working correctly.

> Kernel 4.18.16 (Arch Linux)

I see upgrading to 4.19 seems to have solved your problem, but this is 
more about something I saw in the trace that has me wondering...

> [  368.267315]  touch_atime+0xc0/0xe0

Do you have any atime-related mount options set?

FWIW, noatime is strongly recommended on btrfs.

Now I'm not a dev, just a btrfs user and list regular, and I don't know 
if that function is called and just does nothing when noatime is set, so 
you may well already have it set and this is "much ado about nothing", 
but the chance that it's relevant, if not for you, perhaps for others 
that may read it, begs for this post...

The problem with atime, access time, is that it turns most otherwise read-
only operations into read-and-write operations in ordered to update the 
access time.  And on copy-on-write (COW) based filesystems such as btrfs, 
that can be a big problem, because updating that tiny bit of metadata 
will trigger a rewrite of the entire metadata block containing it, which 
will trigger an update of the metadata for /that/ block in the parent 
metadata tier... all the way up the metadata tree, ultimately to its 
root, the filesystem root and the superblocks, at the next commit 
(normally every 30 seconds or less).

Not only is that a bunch of otherwise unnecessary work for a bit of 
metadata barely anything actually uses, but forcing most read operations 
to read-write obviously compounds the risk for all of those would-be read-
only operations when a filesystem already has problems.

Additionally, if your use-case includes regular snapshotting, with atime 
on, on mostly read workloads with few writes (other than atime updates), 
it may actually be the case that most of the changes in a snapshot are 
actually atime updates, making reoccurring snapshot updates far larger 
than they'd be otherwise.

Now a few years ago the kernel did change the default to relatime, 
basically updating the atime for any particular file only once a day, 
which does help quite a bit, and on traditional filesystems it's arguably 
a reasonably sane default, but COW makes atime tracking enough more 
expensive that setting noatime is still strongly recommended on btrfs, 
particularly if you're doing regular snapshotting.

So do consider adding noatime to your mount options if you haven't done 
so already.  AFAIK, the only /semi-common/ app that actually uses atimes 
these days is mutt (for read-message tracking), and then not for mbox, so 
you should be safe to at least test turning it off.

And YMMV, but if you do use mutt or something else that uses atimes, I'd 
go so far as to recommend finding an alternative, replacing either btrfs 
(because as I said, relatime is arguably enough on a traditional non-COW 
filesystem) or whatever it is that uses atimes, your call, because IMO it 
really is that big a deal.

Meanwhile, particularly after seeing that in the trace, if the 4.19 
update hadn't already fixed it, I'd have suggested trying a read-only 
mount, both as a test, and assuming it worked, at least allowing you to 
access the data without the lockup, which would have then been related to 
the write due to the atime update, not the actual read.

Actually, a read-only mount test is always a good troubleshooting step 
when the trouble is a filesystem that either won't mount normally, or 
will, but then locks up when you try to access something.  It's far lest 
risky than a normal writable mount, and at minimum it provides you the 
additional test data of whether it worked or not, plus if it does, a 
chance to access the data and make sure your backups are current, before 
actually trying to do any repairs.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

