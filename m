Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:51416 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab3IULUO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Sep 2013 07:20:14 -0400
Received: by mail-ob0-f169.google.com with SMTP id wp4so1817329obc.14
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Sep 2013 04:20:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130921023415.GE5672@localhost.localdomain>
References: <5021349.IU75SGaY0J@merkaba>
	<20130921023415.GE5672@localhost.localdomain>
Date: Sat, 21 Sep 2013 13:20:14 +0200
Message-ID: <CAFDW0jL4f4H2hjdRxZeGvrLJeLmRbDVHYedNwdgp04p8tHgikQ@mail.gmail.com>
Subject: Re: [REGRESSION] 3.12-rc1: Trying to create snapshot corrupted filesystem
From: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> You will want the patch I just sent,
>
> Btrfs: create the uuid tree on remount rw
>
> and that should fix the snapshot problems.  Thanks,

thanks Josef - you can close this bug:

https://bugzilla.kernel.org/show_bug.cgi?id=61301

then. will try your patch later, too.

Ahmet
