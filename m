Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:43641 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbbBMNQS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Feb 2015 08:16:18 -0500
Received: by mail-yk0-f177.google.com with SMTP id 20so7569790yks.8
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Feb 2015 05:16:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <gacvqb-mpa.ln1@hurikhan77.spdns.de>
References: <CABdHLQ7QPjUbzqNdzCfR0QxC-0coYs0dofuFvsROYXy-M9u4ig@mail.gmail.com>
	<pan$321bc$90037b7$6ca4e371$e54e1a3b@cox.net>
	<CABdHLQ6La7BO-TJ3cYEx_NnOUhAYJ69uv3tGnVRYsWkiUrqCsQ@mail.gmail.com>
	<pan$9532$65b1220e$320184ed$94bcf659@cox.net>
	<62ntqb-o2r.ln1@hurikhan77.spdns.de>
	<54DC9AB9.7030505@gmail.com>
	<gacvqb-mpa.ln1@hurikhan77.spdns.de>
Date: Fri, 13 Feb 2015 14:16:17 +0100
Message-ID: <CABdHLQ7=Xr5BV+adP00w6_vgnmQhx_eH2BzK6ALK3FzBXhsaFQ@mail.gmail.com>
Subject: Re: btrfs performance, sudden drop to 0 IOPs
From: "P. Remek" <p.remek1@googlemail.com>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Yes, it was implemented for the purpose of allowing an application to
> implement its own caching - probably for the sole purpose of doing it
> "better" or more efficient. But it simply does not work out that well, at
> least with COW fs. The original idea "performance" is more or less eaten
> away in a COW scenario - or worse. And that in turn is why Linus said
> O_DIRECT is broken and should go away, use cache hinting instead.

Linus is saying to use things like madvise but the fact is that in
reality people are using O_DIRECT instead of it, so it is important to
get it right. The case which I am interested is KVM. Virtual machine
disk file is opened with O_DIRECT so that when Virtual machine is
doing IO, it is not cached twice - first time on guest operating
system level, and second time on hypervisor host operating system
level. With O_DIRECT it is only cached in guest.
