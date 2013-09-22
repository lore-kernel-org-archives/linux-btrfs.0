Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:46155 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab3IVJji (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Sep 2013 05:39:38 -0400
Received: by mail-ob0-f180.google.com with SMTP id wm4so2463919obc.25
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Sep 2013 02:39:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFDW0jL4f4H2hjdRxZeGvrLJeLmRbDVHYedNwdgp04p8tHgikQ@mail.gmail.com>
References: <5021349.IU75SGaY0J@merkaba>
	<20130921023415.GE5672@localhost.localdomain>
	<CAFDW0jL4f4H2hjdRxZeGvrLJeLmRbDVHYedNwdgp04p8tHgikQ@mail.gmail.com>
Date: Sun, 22 Sep 2013 11:39:37 +0200
Message-ID: <CAFDW0j+3iiAq_GgswXKvb7P8Lz2DeEw2rc4U-RO4uyUboxFkTg@mail.gmail.com>
Subject: Re: [REGRESSION] 3.12-rc1: Trying to create snapshot corrupted filesystem
From: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 21, 2013 at 1:20 PM, Ahmet Inan
<ainan@mathematik.uni-freiburg.de> wrote:
>> You will want the patch I just sent,
>>
>> Btrfs: create the uuid tree on remount rw
>>
>> and that should fix the snapshot problems.  Thanks,
>
> thanks Josef - you can close this bug:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=61301
>
> then. will try your patch later, too.
>
ok, works for me, too.

changed state of bug to "resolved"

Ahmet
