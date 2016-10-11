Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:36676 "EHLO
        mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752588AbcJKRXo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 13:23:44 -0400
Received: by mail-lf0-f44.google.com with SMTP id b75so51083367lfg.3
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Oct 2016 10:23:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch>
References: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch>
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
Date: Tue, 11 Oct 2016 18:16:25 +0100
Message-ID: <CAKinxcXPZzjoEXFSOfW6hGQVEjuWLgk3MpKuLKdEMxnekaf68w@mail.gmail.com>
Subject: Re: RAID system with adaption to changed number of disks
To: Philip Louis Moetteli <Philip.Moetteli@unige.ch>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I think you just described all the benefits of btrfs in that type of
configuration .... unfortunately after btrfs RAID 5 & 6 was marked as
OK it got marked as "it will eat your data" (and there is a tone of
people in random places poping up with raid 5 & 6 that just killed
their data)

On 11 October 2016 at 16:14, Philip Louis Moetteli
<Philip.Moetteli@unige.ch> wrote:
> Hello,
>
>
> I have to build a RAID 6 with the following 3 requirements:
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
>
