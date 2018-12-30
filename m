Return-Path: <SRS0=9xGW=PH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74991C43387
	for <linux-btrfs@archiver.kernel.org>; Sun, 30 Dec 2018 04:13:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 450C021019
	for <linux-btrfs@archiver.kernel.org>; Sun, 30 Dec 2018 04:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbeL3ENl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 29 Dec 2018 23:13:41 -0500
Received: from [195.159.176.226] ([195.159.176.226]:58809 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbeL3ENk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Dec 2018 23:13:40 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1gdSRi-0007q0-Bi
        for linux-btrfs@vger.kernel.org; Sun, 30 Dec 2018 05:11:26 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-btrfs@vger.kernel.org
From:   Duncan <1i5t5.duncan@cox.net>
Subject: Re: Undelete files
Date:   Sun, 30 Dec 2018 04:11:20 +0000 (UTC)
Message-ID: <pan$b27cb$1e0679f9$7f3c174e$d11713c1@cox.net>
References: <CAMrg+aRiTuesnBYx=UxQBXLSDXXwFOAKuFtGcwB6ZebQgycCXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@blaine.gmane.org
User-Agent: Pan/0.146 (Hic habitat felicitas; e65ba1502)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Adrian Bastholm posted on Sat, 29 Dec 2018 23:22:46 +0100 as excerpted:

> Hello all,
> Is it possible to undelete files on BTRFS ? I just deleted a bunch of
> folders and would like to restore them if possible.
> 
> I found this script
> https://gist.github.com/Changaco/45f8d171027ea2655d74 but it's not
> finding stuff ..

That's an undelete-automation wrapper around btrfs restore...

> ./btrfs-undelete /dev/sde1 ./foto /home/storage/BTRFS_RESTORE/ Searching
> roots...
> Trying root 389562368... (1/70)
> ...
> Trying root 37339136... (69/70)
> Trying root 30408704... (70/70)
> Didn't find './foto'

That script is the closest thing to a direct undelete command that btrfs 
has.  However, there's still some chance...

** IMPORTANT **  If you still have the filesystem mounted read-write, 
remount it read-only **IMMEDIATELY**, because every write reduces your 
chance at recovering any of the deleted files.

(More in another reply, but I want to get this sent with the above ASAP.)



-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

