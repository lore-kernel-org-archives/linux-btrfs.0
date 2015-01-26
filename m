Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f53.google.com ([209.85.213.53]:44518 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807AbbAZVOb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Jan 2015 16:14:31 -0500
Received: by mail-yh0-f53.google.com with SMTP id v1so4580969yhn.12
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Jan 2015 13:14:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANXojczR_jeVU0XNQGzatmDaaCv7CdWanis8NiSe2F75cuz_9g@mail.gmail.com>
References: <CANXojczR_jeVU0XNQGzatmDaaCv7CdWanis8NiSe2F75cuz_9g@mail.gmail.com>
Date: Mon, 26 Jan 2015 14:14:30 -0700
Message-ID: <CAJCQCtRyv+m0kxBL6LW=xZv=sUzf2to4R6xPsxy6CkihHmrV0A@mail.gmail.com>
Subject: Re: Get the diff from a file in two snapshots.
From: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 26, 2015 at 1:52 PM, Stef Bon <stefbon@gmail.com> wrote:
> Hi,
>
> I'm working on a service/program for Linux which takes care of
> managing backupping of folders and the snapshots of those.
>
> The user can assign forlders he/she want to be backupped (corect
> English?), and create a profile for this folder. This profile is about
> the files which will be taken into process, and which not.
>
> As tool to backup and manage the snapshots I use btrfs.
> Now in my construction I get a lot of situations like:
>
> /path/to/snapshots/201501261603/path/to/some/file
>
> is another version of the same file at:
>
> /path/to/snapshots/201501252252/path/to/some/file
>
> is there a way to get the difference between these two files by making
> use of btrfs?

Snapper has this functionality built into it. I'm not sure if it uses
diff or something else. But the Snapper GUI in yast2 on opensuse will
let you see what files have changed between snapshots, click on the
file and it shows a color coded diff.

https://github.com/openSUSE/snapper



-- 
Chris Murphy
