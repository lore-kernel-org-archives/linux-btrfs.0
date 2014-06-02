Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:64289 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbaFBQP4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jun 2014 12:15:56 -0400
Received: by mail-qg0-f46.google.com with SMTP id q108so10794448qgd.19
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Jun 2014 09:15:55 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CADiq+R44LEu+x-UXWtKOm9Gp0-05bPhXKY=j19pFZ_YPr+_p+g@mail.gmail.com>
References: <CADiq+R44LEu+x-UXWtKOm9Gp0-05bPhXKY=j19pFZ_YPr+_p+g@mail.gmail.com>
Date: Mon, 2 Jun 2014 17:15:55 +0100
Message-ID: <CAL3q7H458iwJrz011hRqd_hDoKdzSyrnS-L+Z8kXeW9aefPybw@mail.gmail.com>
Subject: Re: btrfs-receive rename error
From: Filipe David Manana <fdmanana@gmail.com>
To: Rasmus Eskola <fruitiex@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 29, 2014 at 4:32 PM, Rasmus Eskola <fruitiex@gmail.com> wrote:
> Hi,
>
> I'm trying to send an incremental backup of a btrfs subvolume to
> another host using the command:
>
> sudo btrfs send -v /home/backup/2014-05-29_02:26:38 | ssh "root@s"
> "btrfs receive -v /btrfs/backup_bulky/home"
>
> Eventually it stops with the following error:
> ERROR: rename o941570-199282-0 ->  failed. Not a directory
>
> Seems like a bug to me, I tried searching for inodes '941570' or
> '199282' but came up with no results on either. btrfsck reports no
> problems.
>
> Any ideas on how to solve this or debug it further? The subvolume is
> around 400 gb large, and it's a few days since I made the previous
> incremental backup, so I unfortunately haven't been able to find any
> root cause or a way to reproduce the bug outside of this subvolume.
>
> At the time of writing I'm running the 3.15.0-rc1 kernel with
> btrfs-progs v3.14 on both machines.

Can you try the following patch and see it solves the issue?

https://patchwork.kernel.org/patch/4217791/

It affects only 3.15 (any of the 3.15 rc's).

>
> Best regards,
> Rasmus Eskola
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
