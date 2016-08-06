Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35577 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbcHFWCO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Aug 2016 18:02:14 -0400
Received: by mail-lf0-f67.google.com with SMTP id l89so18430283lfi.2
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Aug 2016 15:02:13 -0700 (PDT)
Subject: Re: possible bug - wrong path in 'btrfs subvolume show' when snapshot
 is in path below subvolume.
To: Peter Holm <peter.g.holm@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAOZhre2ZytraEyHzVb1zY6FmAJUC4xun0fpWRQS=Z8ZKWff0jg@mail.gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <ccd46545-b433-1ff5-21d1-dd1bd7dd3e9f@gmail.com>
Date: Sat, 6 Aug 2016 08:14:41 +0300
MIME-Version: 1.0
In-Reply-To: <CAOZhre2ZytraEyHzVb1zY6FmAJUC4xun0fpWRQS=Z8ZKWff0jg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

05.08.2016 02:32, Peter Holm пишет:
> 'btrfs subvolumee show' gives no path to btrfs system root (volid=5)
> when snapshot is in the folder of subvolume.
> 
> Step to reproduce.
> 1.btrfs subvolume create xyz
> 2.btrfs subvolume snapshot xyz xyz/xyz
> 3.btrfs subvolume snapshot <mountpoint-for-btrfs-root>/xyz

This last command is wrong - snapshot name is missing. If you mean

btrfs subvolume snapshot <mountpoint-for-btrfs-root> xyz

- I get "File exists" (assuming that all previous commands were with
<mountpoint-for-ntrfs-root> as current directory. This is on openSUSE
Tumbleweed with kernel 4.6.4-2 and btrfsprogs 4.6.1-1.

If my assumption is wrong, please copy and paste exact commands used to
reproduce it.

> 4.btrfs subvolumme show xyz
> output
> .....
> Snapshot(s)
>                          xyz
>                          xyz
> .....
> picture from my console reproducing this. Whatchout for my personal fs-layout
> my mountpoint for volid=5 is - as seen in the findmount command  r at
> top of the photo /mnt/btrfs/sdc16-svid-5
> https://s31.postimg.org/9f0d7xb7f/is_this_a_bug.png
> 
> If that can add anything, same thing happends when rootvolume is
> mounted by path. (for the moment it is mounted by volid).
> /Peter Holm
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

