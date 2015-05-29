Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:35255 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603AbbE2TN7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 May 2015 15:13:59 -0400
Received: by lbbuc2 with SMTP id uc2so54549537lbb.2
        for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2015 12:13:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANXojcyqXUNhWLa4ybGyhXceqLdb3DdvM-TvEtwf-KOM6YOsUQ@mail.gmail.com>
References: <CANXojcyqXUNhWLa4ybGyhXceqLdb3DdvM-TvEtwf-KOM6YOsUQ@mail.gmail.com>
Date: Fri, 29 May 2015 21:13:58 +0200
Message-ID: <CAC+fKQXdKjh3ckEvrcxiEMWvA0xN3v+Gx_T2DeJoCL4pEFbasg@mail.gmail.com>
Subject: Re: Plans for a library for btrfs?
From: Juan Orti Alcaine <j.orti.alcaine@gmail.com>
To: Stef Bon <stefbon@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm not a developer, but I read this a days ago. Could it be helpful?

https://blog-vpodzime.rhcloud.com/?p=61
https://github.com/rhinstaller/libblockdev


2015-05-27 14:31 GMT+02:00 Stef Bon <stefbon@gmail.com>:
> Hi,
>
> I'm working on a program (using sqlite, FUSE and btrfs) to provide
> backup and version managment
> for users. They can enable the backup service for folders they own,
> and select files they want to backup using mimetypes.
>
> This program, which I've called fuse-backup, creates backup subvolumes
> and snapshots by calling an extrenal script, which does something
> like:
>
> btrfs subvolume snapshot -r %PathToBackup%/ %PathToSnapshot%
>
> This works perfect, but are there any plans to do this with a library?
>
> Stef Bon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Juan Orti
https://miceliux.com

GPG key: https://miceliux.com/pub/pubkey.asc
GPG fingerprint: 61F0 8272 6882 BCA6 3A35  88F6 B630 4B72 DEEB D08B
