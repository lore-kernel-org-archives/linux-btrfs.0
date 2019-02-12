Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 371C9C282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 22:57:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9D5A222C7
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 22:57:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="m+vEjWtM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729192AbfBLW55 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 17:57:57 -0500
Received: from mail-lj1-f182.google.com ([209.85.208.182]:44451 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfBLW55 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 17:57:57 -0500
Received: by mail-lj1-f182.google.com with SMTP id q128so287004ljb.11
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 14:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nkKWEsj49rZ9mGkz5CFrQrBQx9X7pq8gUAGEQZu1rqg=;
        b=m+vEjWtMMaYsCZ3p+9loMWiEKA7ZneHJDM8D8cWAfIQZN+671Earaabo8CKu9NWTVh
         nearHmlsv0ulpoMbKMstmliNtxd5H00Ix62NDSZiKUEFVKSYOu7u0yx9DE1VUDLqkzw9
         Wk8wexH3Oj8arANItDG0M8H/PH5u0PINgC1CKfF5GlS3Ki18FTk82IlRs0sZbrpkg5ZX
         WUr+g4ZLckv75K3HFMrpRdiepKdv0T0hEsvcUGC/l7wJkLDR9LQDazFkQRWR2NabrFxP
         ejteQe2pNPuhB4LwrbEuqfLatgNvhZRJVadsBYlKhiyQ4pMgM5ba/I619ex3CW6Zh0RG
         Mngg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nkKWEsj49rZ9mGkz5CFrQrBQx9X7pq8gUAGEQZu1rqg=;
        b=C9dUdNkdODLwx/MEuTHwSSKjiTtO0AyBW8BFjq6FIDSsKrX/zIP1TvwzrZH4ypSmLc
         ApDdGybCrITG28+lFbZEs6uOFxP3ocViCN7CjUO+EpcL0PydSldZYXugbpGCAHw/Pm4h
         lQqN/BTCHqyEVz6p+lfN10b0vqQmg6hluzR8garyfFJkkd9nk54RxXLOk2tZdto3dcgD
         qYaEQ5WIYSQ28h93w9lNm3hZ3ABB2/nMg47H8DMgNg501oGet2WpGCCsmn6W/bSu02/s
         qCEAo+A8eXPoMkdGzWUED34l8k2H0jV99NARm4KJiYq5KzaSjVJxO47MpXnN3+gkksmP
         ZBEQ==
X-Gm-Message-State: AHQUAuYtQ4kpIoQPYApeRJqlVSggxaQwVWRIGKcnFdJoYjCwKm3bU1rf
        qnxHIjEGO0yyfNbZvQXv+v6vn9qQcURB2inNw/1m5w==
X-Google-Smtp-Source: AHgI3Ib4sOmZvHbvLWBNEr1GM8AmhgR5W0jJxeG9oRIHbM2zpHpzXGvF3r6k9e7ghuXGelM2NnoTB6NeoUD5Fmft5M8=
X-Received: by 2002:a2e:8719:: with SMTP id m25-v6mr3932040lji.121.1550012274555;
 Tue, 12 Feb 2019 14:57:54 -0800 (PST)
MIME-Version: 1.0
References: <7ef0e91501a04cd4c5e0d942db638a0b50ef3ec3.camel@seblu.net>
In-Reply-To: <7ef0e91501a04cd4c5e0d942db638a0b50ef3ec3.camel@seblu.net>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 12 Feb 2019 15:57:41 -0700
Message-ID: <CAJCQCtSJyDOhw=oCN5kjrZexu0H9pOOiPGyJBGRNUtn2wruKAw@mail.gmail.com>
Subject: Re: Corrupted filesystem, looking for guidance
To:     =?UTF-8?Q?S=C3=A9bastien_Luttringer?= <seblu@seblu.net>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 11, 2019 at 8:16 PM S=C3=A9bastien Luttringer <seblu@seblu.net>
wrote:

>
> I'm not able to find the root cause of the btrfs corruption. All disks
> looks
> healthy (selftest ok, no error logged), no kernel trace of link failure o=
r
> something.
> I run a check on the md layer, and 2 mismatch was discovered:
> Feb 11 04:02:35 kernel: md127: mismatch sector in range 490387096-4903871=
=3D
04
> Feb 11 04:31:14 kernel: md127: mismatch sector in range
> 1024770720-1024770728
> I run a repair (resync) but mismatch are still around after.
>

Both mismatches are 8 512 sectors which is consisted with bad data on a
single 4096 byte physical sector on an advanced format drive.

This command
echo repair > /sys/block/mdX/md/sync_action

FYI: This only does full stripe reads, recomputes parity and overwrites the
parity strip. It assumes the data strips are correct, so long as the
underlying member devices do not return a read error. And the only way they
can return a read error is if their SCT ERC time is less than the kernel's
SCSI command timer. Otherwise errors can accumulate.

smartctl -l scterc /dev/sdX
cat /sys/block/sdX/device/timeout

The first must be a lesser value than the second. If the first is disabled
and can't be enabled, then the generally accepted assumed maximum time for
recoveries is an almost unbelievable 180 seconds; so the second needs to be
set to 180 and is not persistent. You'll need a udev rule or startup script
to set it at every boot.

It is sufficient to merely run a check, rather than repair, to trigger the
proper md RAID fixup from a device read error.

Getting a mismatch on a check means there's a hardware problem somewhere.
The mismatch count only tells you there is a mismatch between data strips
and their parity strip. It doesn't tell you which device is wrong. And if
there are no read errors, and no link resets, and yet you get mismatches,
that suggests silent data corruption. Further, if the mismatches are
consistently in the same sector range, it suggests the repair scrub
returned one set of data, and the subsequent check scrub returned different
data - that's the only way you get mismatches following a repair scrub.

All Btrfs can do in this case is hopefully it was using DUP metadata, and
then it can recover so long as the origin of the problem isn't memory
defect related. If it's bad RAM, then chances are both copies of metadata
will be identically wrong and thus no help in recovery.

>How could I save my filesystem? Should I try --repair or --init-csum-tree?


If it mounts read-only, update your backups. That is the first priority. Be
prepared to need them. If it will not mount read only anymore then I
suggest 'btrfs restore' to scrape data out of the volume to a backup while
it's still possible. Any repair attempt means writing changes, and any
writes are inherently risky in this situation. So yeah - if the data is
important, focus on backups first.

Next, I expect until the RAID is healthy that it's difficult to make a
successful repair of the file system. And for the RAID to be healthy, first
memory and storage hardware needs to be certainly healthy - the fact there
are mismatches following an md repair scrub directly suggests hardware
issues. The linux-raid list is usually quite helpful tracking down such
problems, including which devices are suspect, but they're going to ask the
same questions about SCT ERC and SCSI command timer values I mentioned
earlier, and will want to figure out why you're continuing to see
mismatches even after a repair scrub - not normal.

---
Chris Murphy
