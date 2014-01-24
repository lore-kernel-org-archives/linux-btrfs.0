Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:62541 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaAXBBt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jan 2014 20:01:49 -0500
Received: by mail-la0-f51.google.com with SMTP id c6so2060162lan.38
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jan 2014 17:01:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAW2-ZeF89ZKi3yhhmRpuEBJT9hhbE=c5aehO-wSPsjfsf0YDQ@mail.gmail.com>
References: <CAAW2-ZeF89ZKi3yhhmRpuEBJT9hhbE=c5aehO-wSPsjfsf0YDQ@mail.gmail.com>
From: Jonathan H <pythonnut@gmail.com>
Date: Thu, 23 Jan 2014 17:01:18 -0800
Message-ID: <CAAW2-ZdrDv62vELZsPuY5QrqfNe9yYdqm7U7eNQi3reepO-obQ@mail.gmail.com>
Subject: Re: Zombie BTRFS subvolume
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bleck. It turns out that the output of "btrfs su list" is always
relative to the root (which makes it an absolute path disguised as a
relative path). Removing it was easy after I realized that.

On Thu, Jan 23, 2014 at 3:37 PM, Jonathan H <pythonnut@gmail.com> wrote:
> I deleted a subvolume using "rm -rf .snapshots" (the subvolume was
> created by snapper). Now, it's gone from the filesystem, but it's
> still show in "btrfs su list /" where it was originally. This makes me
> worried. I ran a btrfsck and it didn't spot any errors that seemed
> relevant.
>
> The system is alive and well, but I'm worried that something's not
> right. Is this okay, and, if not, how can I fix it?
>
> Thanks,
> PythonNut
