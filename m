Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A771C43612
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 08:36:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4824C2063F
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 08:36:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbfAOIgE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 03:36:04 -0500
Received: from [195.159.176.226] ([195.159.176.226]:44494 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1728345AbfAOIgE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 03:36:04 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1gjKAM-0007fn-BZ
        for linux-btrfs@vger.kernel.org; Tue, 15 Jan 2019 09:33:46 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-btrfs@vger.kernel.org
From:   Duncan <1i5t5.duncan@cox.net>
Subject: Re: applications hang on a btrfs spanning two partitions
Date:   Tue, 15 Jan 2019 08:33:40 +0000 (UTC)
Message-ID: <pan$cd3b7$50e825ef$b5f86324$c489b494@cox.net>
References: <418d4647-8c67-2481-68f1-1e722460c3de@florianstecker.de>
        <aeaf4b99-a9d5-6335-67f3-e7f851e50b32@florianstecker.de>
        <pan$4ced2$4d8a896d$78f71764$55651a6d@cox.net> <2486006.dzvMEKkTBt@thetick>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@blaine.gmane.org
User-Agent: Pan/0.146 (Hic habitat felicitas; edad96df2)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Marc Joliet posted on Mon, 14 Jan 2019 12:35:05 +0100 as excerpted:

> Am Montag, 14. Januar 2019, 06:49:58 CET schrieb Duncan:
> [...]
>> Unless you have a known reason not to[1], running noatime with btrfs
>> instead of the kernel-default relatime is strongly recommended,
>> especially if you use btrfs snapshotting on the filesystem.
> [...]
> 
> The one reason I decided to remove noatime from my systems' mount
> options is because I use systemd-tmpfiles to clean up cache directories,
> for which it is necessary to leave atime intact (since caches are often
> Write Once Read Many).

Thanks for the reply.  I hadn't really thought of that use, but it makes 
sense...

FWIW systemd here too, but I suppose it depends on what's being cached 
and particularly on the expense of recreation of cached data.  I actually 
have many of my caches (user/browser caches, etc) on tmpfs and reboot 
several times a week, so much of the cached data is only trivially cached 
as it's trivial to recreate/redownload.

OTOH, running gentoo, my ccache and binpkg cache are seriously CPU-cycle 
expensive to recreate, so you can bet those are _not_ tmpfs, but OTTH, 
they're not managed by systemd-tmpfiles either.  (Ccache manages its own 
cache and together with the source-tarballs cache and git-managed repo 
trees along with binpkgs, I have a dedicated packages btrfs containing 
all of them, so I eclean binpkgs and distfiles whenever the 24-gigs space 
(48-gig total, 24-gig each on pair-device btrfs raid1) gets too close to 
full, then btrfs balance with -dusage= to reclaim partial chunks to 
unallocated.)

Anyway, if you're not regularly snapshotting, relatime is reasonably 
fine, tho I'd still keep the atime effects in mind and switch to noatime 
if you end up in a recovery situation that requires writable mounting.  
(Losing a device in btrfs raid1 and mounting writable in ordered to 
replace it and rebalance comes to mind as one example of a writable-mount 
recovery scenario where noatime until full replace/rebalance/scrub 
completion would prevent unnecessary writes until the raid1 is safely 
complete and scrub-verified again.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

