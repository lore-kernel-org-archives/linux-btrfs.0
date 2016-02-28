Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:35132 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbcB1VTF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Feb 2016 16:19:05 -0500
Received: by mail-ig0-f176.google.com with SMTP id hb3so63568272igb.0
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Feb 2016 13:19:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56D18C3F.9000105@it.auth.gr>
References: <56D18C3F.9000105@it.auth.gr>
Date: Sun, 28 Feb 2016 14:19:03 -0700
Message-ID: <CAJCQCtT4T+RaH-vHvdz6dwDrEqr1Oye-ACMiDeEw4jC_5uObeg@mail.gmail.com>
Subject: Re: btrfs equivalent for zfs send -R
From: Chris Murphy <lists@colorremedies.com>
To: =?UTF-8?B?zpPOuc+Oz4HOs86/z4IgzqDOrM67zrvOsc+C?= <gpall@it.auth.gr>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 27, 2016 at 4:45 AM, Γιώργος Πάλλας <gpall@it.auth.gr> wrote:
> Hi all.
>
> If I have a btrfs subvolume 'subv' and then subvolumes subv/sub1, subv/sub2,
> subv/sub3, is there a way to snapshot all the subv tree and then recursively
> send it remotely?
>
> I think this would be the analogous of zfs snapshot -r, and then zfs send
> -R.

There's no recursive snapshotting in Btrfs. There is btrfs send -e
which I think is close to zfs send -I but at the moment it's broken.
https://bugzilla.kernel.org/show_bug.cgi?id=111221

The man page for send suggests -e is using a different format, so I'm
gonna guess the send format isn't stable yet.


-- 
Chris Murphy
