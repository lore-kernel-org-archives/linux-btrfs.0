Return-Path: <SRS0=9xGW=PH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 895FAC43444
	for <linux-btrfs@archiver.kernel.org>; Sun, 30 Dec 2018 04:01:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CD2E2173B
	for <linux-btrfs@archiver.kernel.org>; Sun, 30 Dec 2018 04:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725998AbeL3EBs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 29 Dec 2018 23:01:48 -0500
Received: from [195.159.176.226] ([195.159.176.226]:43504 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbeL3EBr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Dec 2018 23:01:47 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1gdSGD-0003LS-EQ
        for linux-btrfs@vger.kernel.org; Sun, 30 Dec 2018 04:59:33 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-btrfs@vger.kernel.org
From:   Duncan <1i5t5.duncan@cox.net>
Subject: Re: Broken chunk tree - Was: Mount issue, mount /dev/sdc2: can't read
 superblock
Date:   Sun, 30 Dec 2018 03:59:25 +0000 (UTC)
Message-ID: <pan$8eedd$1bbb1a94$d4e62be5$121b4321@cox.net>
References: <1aa82e28-3331-bc64-071c-6cf87b08ad94@petezilla.co.uk>
        <CAJCQCtRY-=AoHDxu--YOWfrs774QzrYj-AwvwD3H_YpTzDKfZw@mail.gmail.com>
        <3b4d0ed3-4151-50b9-b1da-6be240bb58b3@petezilla.co.uk>
        <CAJCQCtRv2NOabzMB0A9A7hoZcu_-6Fy2+umc8+qYcWnv=wn7bQ@mail.gmail.com>
        <99716398-e99c-6ee9-e256-6d05fdc48122@petezilla.co.uk>
        <0024a4b2-7117-8d76-45c5-240e23edc29b@gmx.com>
        <5670f5ac-b9e9-8bed-67ee-d113a385a304@metaliza.cz>
        <d29c3f7f-33b8-e1fc-e6ae-672a5bf52376@gmx.com>
        <682fc519-49c4-8537-bd48-cff246a39092@metaliza.cz>
        <8f59acfd-4d97-86d4-2063-25213e2770d0@gmx.com>
        <07b88bad-e1fa-7485-d410-ee261ace321c@metaliza.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@blaine.gmane.org
User-Agent: Pan/0.146 (Hic habitat felicitas; e65ba1502)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Tomáš Metelka posted on Sun, 30 Dec 2018 01:48:23 +0100 as excerpted:

> Ok, I've got it:-(
> 
> But just a few questions: I've tried (with btrfs-progs v4.19.1) to
> recover files through btrfs restore -s -m -S -v -i ... and following
> events occurred:
> 
> 1) Just 1 "hard" error:
> ERROR: cannot map block logical 117058830336 length 1073741824: -2 Error
> copying data for /mnt/...
> (file which absence really doesn't pain me:-))
> 
> 2) For 24 files a I got "too much loops" warning (U mean this: "if
> (loops >= 0 && loops++ >= 1024) { ..."). I've always answered yes but
> I'm afraid these files are corrupted (at least 2 of them seems
> corrupted).
> 
> How much bad is this? Does the error mentioned in #1 mean that it's the
> only file which is totally lost? I can live without those 24 + 1 files
> so if #1 and #2 would be the only errors then I could say the recovery
> was successful ... but I'm afraid things aren't such easy:-)

In this context, the biggest thing to know about btrfs restore is that 
because it's meant as a recovery measure and if it comes to using 
restore, the assumption is that the priority is recovery of /anything/ 
even if the checksums don't match (a chance of recovery of possibly bad 
data is considered better than rejecting possibly bad data entirely), it 
doesn't worry too much about checksums (AFAIK it ignores data checksums 
entirely, not sure whether it checks metadata checksums or not, but it 
probably ignores failure in at least some cases if it does, because 
that's the point for a tool like this).

Which means that anything recovered using btrfs recover doesn't have the 
usual btrfs checksums validation guarantees, and could very possibly be 
corrupt.

However, that's mitigated by the fact that most filesystems don't even 
have built-in checksumming and validation in the first place, so the data 
on them could go bad even in normal operation, and unless it was 
obviously corrupted into not working, you'd likely never even know it, so 
btrfs restore ignoring checksums simply returns the data to the state 
it's /normally/ in on most filesystems, completely unverified.

But if you happen to have checksums independently stored somewhere, or 
even just ordinary unvalidated backups you can compare against, and 
you're worried about the possibility of undiscovered corruption due to 
the restore, and/or you were using btrfs in part /because/ of its built-
in checksum verification, it could be worth doing that verification run 
against your old checksum database or backups.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

