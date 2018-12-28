Return-Path: <SRS0=VlvV=PF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0EABC43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 04:11:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74A042148E
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 04:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729294AbeL1ELc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Dec 2018 23:11:32 -0500
Received: from [195.159.176.226] ([195.159.176.226]:48323 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbeL1ELc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Dec 2018 23:11:32 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1gcjSY-0004C2-Ta
        for linux-btrfs@vger.kernel.org; Fri, 28 Dec 2018 05:09:18 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-btrfs@vger.kernel.org
From:   Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs fi usage -T shows unallocated column as total in drive, not
 total available to btrfs
Date:   Fri, 28 Dec 2018 04:09:12 +0000 (UTC)
Message-ID: <pan$369c4$4c203e8d$24a2c9f9$f1866656@cox.net>
References: <96d61222666591a99b9b9f0c42bf4d5f@mailmag.net>
        <CAJCQCtS7XJaD4Mhrg152K4zfj-w2P0JkpUvZ0R-M6x8QmCc1tg@mail.gmail.com>
        <pan$ac19$67da17d$80a83557$ce46be42@cox.net>
        <ffec4fbe6b91b88e1f7bd57ccb568310@mailmag.net>
        <CAJCQCtRFwLvPFkjhXfs+UFmOu+rHAQ-Zq3Mk6T_q22Qn0zgc7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@blaine.gmane.org
User-Agent: Pan/0.146 (Hic habitat felicitas; e65ba1502)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Chris Murphy posted on Thu, 27 Dec 2018 16:37:55 -0700 as excerpted:

[Context is btrfs reports when btrfs is smaller on a device than the 
device it is on.  In this specific case it's due to btrfs replace to a 
larger device, before using btrfs filesystem resize to increase the size 
to that of the newer/larger device.]

> OK let me see if I get this right. You're saying it's confusing that
> 'btrfs fi sh' "devid size" does not change when doing a device replace;
> whereas 'btrfs fi us' device specific "unallocated" does change, even
> though you haven't yet done a resize.
> 
> I kinda sorta agree. While "unallocated" becomes 6.53TiB for this
> device, the idea it's unallocated suggests it could be allocated, which
> before a resize it cannot be allocated.

"It depends what the definition of "unallocated" is."[1]

Arguably, just as "unallocated" includes space not yet allocated to data/
metadata/system chunks, it could be argued it should include space on the 
device not yet allocated to the filesystem as well.  Clearly, that's what 
the coder of the btrfs filesystem usage functionality thought.

By that view, "unallocated" includes "not yet allocated to the filesystem 
itself also, but available on the block device the filesystem is on, to 
be allocated to the filesystem should the admin decide to do so."

OTOH, as the OP says it's still confusing, and as pointed out in a reply, 
it's btrfs _filesystem_ usage we're talking about here, not btrfs 
_device_ usage, and at minimum, _filesystem_ usage including space on the 
device that's not yet allocated to that filesystem is indeed confusing/
unintuitive, and arguably actually incorrect, particularly if the btrfs 
device usage report reports that space under its "device slack" line, 
which as admins we don't actually know at this point (it doesn't appear 
to be documented except presumably in the code itself).  And arguably, if 
btrfs filesystem usage is to report it at all, it should be under a 
separate (additional) line, presumably device slack, if that's what the 
device usage version does with that line.

---
[1] Quote paraphrases a famous US political/legal quote from some years 
ago...  OT as to the merits, but if you wish the background, 
s/unallocated/is/ and google it using the search engine of your choice.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

