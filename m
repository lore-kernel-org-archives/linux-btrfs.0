Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:35195 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752113AbcJSVFG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Oct 2016 17:05:06 -0400
Received: by mail-it0-f48.google.com with SMTP id 4so128425992itv.0
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Oct 2016 14:05:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <678dcd2e-13ca-0b83-6561-b7c6c10468b9@gmail.com>
References: <678dcd2e-13ca-0b83-6561-b7c6c10468b9@gmail.com>
From: Noah Massey <noah.massey@gmail.com>
Date: Wed, 19 Oct 2016 17:04:25 -0400
Message-ID: <CADfjVrgKeQjqz9HkfWLRZ3NXRA0V7_kBUzy58G6kW0-9HZB6ag@mail.gmail.com>
Subject: Re: Cross subvolume "cp --reflink"?
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 19, 2016 at 12:52 PM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> I get "Failed to clone: Invalid cross-device link". Is it expected?

Yes, you cannot cross a MOUNTPOINT boundary with reflink.
Or, for that matter, btrfs subvolume snapshot.

> Basically this is (on openSUSE TW which has root on subvolume)
>
> mount -o subvol=/ /dev/vda1 /mnt
> btrfs sub create /mnt/var/cache
> cp -a --reflink=always /var/cache/* /mnt/var/cache
>

You *can* however cross subvolume boundaries within the same mountpoint.
Try (assuming your root subvolume is @root)

cp -a --reflink /mnt/@root/var/cache/* /mnt/var/cache

~ Noah
