Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:56167 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757091AbbAZXnx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Jan 2015 18:43:53 -0500
Received: by mail-oi0-f46.google.com with SMTP id a141so9887232oig.5
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Jan 2015 15:43:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRyv+m0kxBL6LW=xZv=sUzf2to4R6xPsxy6CkihHmrV0A@mail.gmail.com>
References: <CANXojczR_jeVU0XNQGzatmDaaCv7CdWanis8NiSe2F75cuz_9g@mail.gmail.com>
	<CAJCQCtRyv+m0kxBL6LW=xZv=sUzf2to4R6xPsxy6CkihHmrV0A@mail.gmail.com>
Date: Tue, 27 Jan 2015 00:43:52 +0100
Message-ID: <CANXojcxps7KPRC2dbfU7hFvUDzkK2CmT4EroDrO6HO56h7j3cg@mail.gmail.com>
Subject: Re: Get the diff from a file in two snapshots.
From: Stef Bon <stefbon@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2015-01-26 22:14 GMT+01:00 Chris Murphy <lists@colorremedies.com>:
>> is there a way to get the difference between these two files by making
>> use of btrfs?
>
> Snapper has this functionality built into it. I'm not sure if it uses
> diff or something else. But the Snapper GUI in yast2 on opensuse will
> let you see what files have changed between snapshots, click on the
> file and it shows a color coded diff.

Hi Chris,

I think (I'm not sure) it's using a high level tool like diff/rdiff.

I will contact the developers of snapper anyway, since my project is
simular to theirs.

But what I'm asking is is there a lowlevel tool to give you a list of
blocks where two versions
of one file differ. I'm asking since btrfs keeps track of the blocks
where files differ, and where they
are the same.

So a lowlevel call to the btrfs filesystem.

Stef
