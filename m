Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:37239 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbdCMLwK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 07:52:10 -0400
Received: by mail-it0-f45.google.com with SMTP id g138so29567252itb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Mar 2017 04:52:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD6NJSwaqHD+6KFRhxwHCyc_N72KuHzzOJRf2g-fuDqZo7PHDA@mail.gmail.com>
References: <CAD6NJSwaqHD+6KFRhxwHCyc_N72KuHzzOJRf2g-fuDqZo7PHDA@mail.gmail.com>
From: Juan Orti Alcaine <j.orti.alcaine@gmail.com>
Date: Mon, 13 Mar 2017 12:52:08 +0100
Message-ID: <CAC+fKQU7XAJ4QqzG3Ug4fwZb3N7hvYANnfjQa+nXDku2M1x8VQ@mail.gmail.com>
Subject: Re: Home storage with btrfs
To: =?UTF-8?Q?H=C3=A9rikz_Nawarro?= <herikz.nawarro@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-03-13 12:29 GMT+01:00 Hérikz Nawarro <herikz.nawarro@gmail.com>:
> Hello everyone,
>
> Today is safe to use btrfs for home storage? No raid, just secure
> storage for some files and create snapshots from it.
>

In my humble opinion, yes. I'm running a RAID1 btrfs at home for 5
years and I feel the most serious bugs have been fixed, because in the
last two years I have not experienced any issue.

Anyway, keeping your kernel and btrfs-progs updated is a must, and of
course, having good backups. I'm using Fedora and it's fine.

Kind regards.
