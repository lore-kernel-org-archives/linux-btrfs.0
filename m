Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750725AbdEASwy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 May 2017 14:52:54 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id A39D3202E9
        for <linux-btrfs@vger.kernel.org>; Mon,  1 May 2017 18:52:52 +0000 (UTC)
Received: from mail-it0-f53.google.com (mail-it0-f53.google.com [209.85.214.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66FE8201BC
        for <linux-btrfs@vger.kernel.org>; Mon,  1 May 2017 18:52:51 +0000 (UTC)
Received: by mail-it0-f53.google.com with SMTP id e65so78669ita.1
        for <linux-btrfs@vger.kernel.org>; Mon, 01 May 2017 11:52:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5907519C.2020204@gmail.com>
References: <5907519C.2020204@gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 1 May 2017 19:52:50 +0100
Message-ID: <CAL3q7H772sxj0KVWQ6tWTrb=2fzvgCQxryyCDPzj4GaUWH2TGw@mail.gmail.com>
Subject: Re: ERROR: rename o3528-7220-0 -> usr failed: Directory not empty
To: jfhart085@gmail.com
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 1, 2017 at 4:17 PM, J. Hart <jfhart085@gmail.com> wrote:
> I've got more information on the following error :
>
> At subvol /mnt/ArchPri/backup/primary/thinkcentre/root/backup.0.2
> At snapshot backup.0.2017.04.21.03.11.40
> ERROR: rename o3528-7220-0 -> usr failed: Directory not empty
>
> I've filed a bug report with additional details at:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=195619
>
> This error occurs during a series of "btrfs send" invocations.  It does not
> occur on all of them, but always at the same point in the operation, and so
> appears to be specific to (dependent on) the data being sent.
>
> I have a test case down to the following:
>
> su -
> btrfs send --no-data temp/backup.0.2017.04.17.07.57.17 | btrfs rec temp/test
> sync
> btrfs send --no-data -p temp/backup.0.2017.04.17.07.57.17
> temp/backup.0.2017.04.21.03.11.40 | btrfs rec temp/test
>
> The error should be something like:
> At subvol temp/backup.0.2017.04.21.03.11.40
> At snapshot backup.0.2017.04.21.03.11.40
> ERROR: rename o3528-7220-0 -> usr failed: Directory not empty
>
> I will probably need to provide the data somehow, or at least the output
> from "btrfs send".  The original data is several GB in size.

Just use "btrfs-image -c 9 /dev/whatever image_file", it will create a
compressed image where the data is replaced with zeroes (not needed to
debug this problem anyway). Then uploaded it anywhere convenient for
you.

Thanks.

>
>
> J. Hart
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
