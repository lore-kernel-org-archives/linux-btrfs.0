Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:42383 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbaLANy0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 08:54:26 -0500
Received: by mail-vc0-f170.google.com with SMTP id hy4so4687556vcb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 05:54:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141201184749.0fd67b62@natsu>
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
	<20141130042306.GE8916@merlins.org>
	<547C6922.6030206@gmail.com>
	<CAE8gLhmn3aX88t1FO2=BnHXk0-+2xQ4dnW57dga93iA-bFaUzQ@mail.gmail.com>
	<20141201184749.0fd67b62@natsu>
Date: Mon, 1 Dec 2014 14:54:25 +0100
Message-ID: <CAE8gLhnyTWjfTk-W+BHdfovV8pJH-yqo7joR+kf6vgs1FU00hw@mail.gmail.com>
Subject: Re: Possible to undo subvol delete?
From: MegaBrutal <megabrutal@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Roman Mamedov <rm@romanrm.net>, Marc MERLIN <marc@merlins.org>,
        Shriramana Sharma <samjnaa@gmail.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-12-01 14:47 GMT+01:00 Roman Mamedov <rm@romanrm.net>:
> On Mon, 1 Dec 2014 14:38:16 +0100
> MegaBrutal <megabrutal@gmail.com> wrote:
>
>> I've also noticed, a subvolume can just be deleted with an "rm -r",
>> just like an ordinary directory. I'd consider to only allow subvolume
>> deletions with exact "btrfs subvolume delete" commands, and they
>
> This is already the case. 'rm -r' will remove all files in a subvolume, but
> the empty subvolume itself is only deletable via the 'btrfs' command.

That's great! And there is no way to protect against recursive
deletions (besides setting the subvolume read-only, as you suggested
below), as files are processes individually by "rm". But it's OK,
people should always be very careful with "rm", and it doesn't change
with btrfs. ;)


> If you want to make snapshots which can't be removed by ordinary tools, use
> the 'read-only' mode when creating them.

Yeah, good idea! Anyway, is it possible to change a read-only snapshot
to read-write and vica-versa, or you can only specify read-only while
creating them?
