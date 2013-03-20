Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:40417 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab3CTTG7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Mar 2013 15:06:59 -0400
Received: by mail-ie0-f172.google.com with SMTP id c10so2545921ieb.31
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Mar 2013 12:06:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201303201959.54969.Martin@lichtvoll.de>
References: <6033676.gK0GbPgrpE@athlonxp>
	<201303161916.55185.Martin@lichtvoll.de>
	<3160822.Hx5D6eTo7L@athlonxp>
	<201303201959.54969.Martin@lichtvoll.de>
Date: Wed, 20 Mar 2013 13:06:58 -0600
Message-ID: <CAE5mzvj-fYae7vWZNAHoj_aiUztTNxeN3bErmv3qRd=46SWOmg@mail.gmail.com>
Subject: Re: How to recover uncorrectable errors ?
From: cwillu <cwillu@cwillu.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: =?UTF-8?Q?Fr=C3=A9d=C3=A9ric_COIFFIER?= <frederic.coiffier@free.fr>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> # rm -rf *
>> rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
>> rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
>> rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
>> rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
>> rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
>> rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
>> rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
>> rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
>> ...
>
> You are trying to remove the files from an NFS client. Stale NFS file
> handle just means that the NFS handle is no longer valid. NFS <v4
> clients refer to file by a file handle composed of filesystem id and
> inode number. Maybe a change in there?
>
> Anyway, to find the real error message its necessary to try to delete
> the files on the server. Cause even if there is a real BTRFS issue, the
> NFS client likely won´t report helpful error messages.

Don't read too much into that "Stale NFS file handle" message; ESTALE
doesn't imply anything about NFS being involved, despite the standard
error string for that value.
