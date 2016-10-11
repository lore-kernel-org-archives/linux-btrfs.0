Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:35855 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753832AbcJKR3y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 13:29:54 -0400
Received: by mail-oi0-f41.google.com with SMTP id m72so31874499oik.3
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Oct 2016 10:29:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch>
References: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch>
From: ronnie sahlberg <ronniesahlberg@gmail.com>
Date: Tue, 11 Oct 2016 10:29:02 -0700
Message-ID: <CAN05THQn126WfiBU7QB3+o1AfQX47BCC+iL3sEZ5VQgJSGKmsA@mail.gmail.com>
Subject: Re: RAID system with adaption to changed number of disks
To: Philip Louis Moetteli <Philip.Moetteli@unige.ch>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 11, 2016 at 8:14 AM, Philip Louis Moetteli
<Philip.Moetteli@unige.ch> wrote:
>
> Hello,
>
>
> I have to build a RAID 6 with the following 3 requirements:


You should under no circumstances use RAID5/6 for anything other than
test and throw-away data.
It has several known issues that will eat your data. Total data loss
is a real possibility.

(the capability to even create raid5/6 filesystems should imho be
removed from btrfs until this changes.)

>
>         • Use different kinds of disks with different sizes.
>         • When a disk fails and there's enough space, the RAID should be able to reconstruct itself out of the degraded state. Meaning, if I have e. g. a RAID with 8 disks and 1 fails, I should be able to chose to transform this in a non-degraded (!) RAID with 7 disks.
>         • Also the other way round: If I add a disk of what size ever, it should redistribute the data, so that it becomes a RAID with 9 disks.
>
> I don’t care, if I have to do it manually.
> I don’t care so much about speed either.
>
> Is BTrFS capable of doing that?
>
>
> Thanks a lot for your help!
