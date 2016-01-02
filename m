Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:34110 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbcABUcH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Jan 2016 15:32:07 -0500
Received: by mail-io0-f175.google.com with SMTP id 1so81067912ion.1
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Jan 2016 12:32:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSJp-p06VCrSaoeqAOFtnt=EfCMKfRF-DVkjpAiW9iv3A@mail.gmail.com>
References: <9E462AAE-481A-4A0D-9918-FF56A73D6F6D@rasmusa.net>
	<CAJCQCtSCJ91FaJ20g-+TKMwGkXeQdEkn1yDf6w+H3=V_8_xshA@mail.gmail.com>
	<1451679613.2761176.480641362.3ADA17DB@webmail.messagingengine.com>
	<CAJCQCtTn1xZ3KLQoPqjDowu__f5AAAXHNye2vU4ceEb6VFK--w@mail.gmail.com>
	<1451764729.3016753.481194250.0BE48A69@webmail.messagingengine.com>
	<CAJCQCtSJp-p06VCrSaoeqAOFtnt=EfCMKfRF-DVkjpAiW9iv3A@mail.gmail.com>
Date: Sat, 2 Jan 2016 13:32:05 -0700
Message-ID: <CAJCQCtQLrh5AM2eRp0g0UvAOedz3=Y8qm1XAi7PV7m26uZsR-Q@mail.gmail.com>
Subject: Re: Add big device, remove small device, read-only
From: Chris Murphy <lists@colorremedies.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Rasmus Abrahamsen <btrfs@rasmusa.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 2, 2016 at 1:15 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Sat, Jan 2, 2016 at 12:58 PM, Rasmus Abrahamsen <btrfs@rasmusa.net> wrote:
>> What do you recommend I do? Everything is redundant across disks.
>> Perhaps I can disconnect the one you mentioned and delete missing.
>
> No, please stop trying new things like throwing spaghetti at a wall.
> The file system is not healthy or it wouldn't behave the way it is. If
> you have a current backup, and want to keep playing to see how bad
> it'll get, then keep proceeding.
>
> But if you have any important data on this volume that you don't have
> a current backup for, then you need to make as few changes as
> possible. Don't delete devices. Don't run btrfsck. Don't scrub. Don't
> balance. Just try to get it mounted first, and then btrfs send, rsync,
> or cp the data you need off the volume onto a new volume.

That means try a normal mount with no mount options first. If that
doesn't work then try:

-o recovery
-o ro,recovery
-o ro,recovery,degraded

If you can get it rw mounted, then you maybe can make ro snapshots
that you can send/receive to a new Btrfs file system. Or rsync -a or
cp -a to a new other file system.

If you can't get it rw mounted, and don't already have ro snapshots of
the things you want, then you'll have to use rsync or cp.


-- 
Chris Murphy
