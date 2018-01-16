Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:36002 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750812AbeAPLCV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Jan 2018 06:02:21 -0500
Received: by mail-qt0-f178.google.com with SMTP id a16so17712484qtj.3
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Jan 2018 03:02:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSKhpLPu_YtbLNEjd82fwgqN+5w=GZociXhJacOQbCjZw@mail.gmail.com>
References: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com>
 <c4908bdb-cd9c-929d-e681-16311b6adbc5@gmail.com> <CAJCQCtS4ZKYbZGbpuOcCCuNdcZjNNUf=gkBu6Ky_DdJ-zVB+HQ@mail.gmail.com>
 <3BF0F2D0-AC05-4EF9-A159-7DBF5A42A79C@thefsb.org> <CAJCQCtSKhpLPu_YtbLNEjd82fwgqN+5w=GZociXhJacOQbCjZw@mail.gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Date: Tue, 16 Jan 2018 14:02:20 +0300
Message-ID: <CAA91j0X40cYJkubNmeT_00U_ZODQ+0OUzemnj2bEwgSQZ-P9-w@mail.gmail.com>
Subject: Re: Recommendations for balancing as part of regular maintenance?
To: Chris Murphy <lists@colorremedies.com>
Cc: Tom Worster <fsb@thefsb.org>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 16, 2018 at 9:45 AM, Chris Murphy <lists@colorremedies.com> wrote:
...
>>
>> Unless some better fix is in the works, this _should_ be a systemd unit or
>> something. Until then, please put it in FAQ.
>
> At least openSUSE has a systemd unit for a long time now, but last
> time I checked (a bit over a year ago) it's disabled by default. Why?
>

It is now enabled by default on Tumbleweed and hence likely on SLE/Leap 15.

> And insofar as I'm aware, openSUSE users aren't having big problems
> related to lack of balancing, they have problems due to the lack of
> balancing combined with schizo snapper defaults, which are these days
> masked somewhat by turning on quotas so snapper can be more accurate
> about cleaning up.
>

Not only that but also making snapshot policy less aggressive - now
(in Tumbleweed/Leap 42.3) periodical snapshots are turned off by
default, only configuration changes via YaST/package updates via
zypper trigger snapshot creation.
