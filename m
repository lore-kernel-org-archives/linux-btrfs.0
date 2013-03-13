Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:33532 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab3CMB5K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 21:57:10 -0400
Received: by mail-la0-f49.google.com with SMTP id fs13so555018lab.36
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 18:57:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201303131238.33692.russell@coker.com.au>
References: <201303131238.33692.russell@coker.com.au>
From: Harald Glatt <mail@hachre.de>
Date: Wed, 13 Mar 2013 02:56:47 +0100
Message-ID: <CAFWF=a=imOqoWMfVpyJmoQes1T8-Vir0bvG4=9SbBTjMfUYJSA@mail.gmail.com>
Subject: Re: Debian 3.7.1 BTRFS crash
To: russell@coker.com.au
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If you care about the data, create a backup if you haven't already
done so. Then you can try btrfsck, maybe you are in luck!

On Wed, Mar 13, 2013 at 2:38 AM, Russell Coker <russell@coker.com.au> wrote:
> I have a workstation running the Debian packaged 3.7.1 kernel from 24th
> December last year.  After some period of uptime (maybe months) it crashed and
> mounted the root filesystem read-only.  Now when I boot it the root filesystem
> gets mounted read-only.
>
> I have attached the dmesg output from the last boot.
>
> The system has an Intel 120G SSD and apart from 4G of swap and 400M of /boot
> it's all a single encrypted BTRFS filesystem.
>
> Any suggestions on what I should do next?
>
> --
> My Main Blog         http://etbe.coker.com.au/
> My Documents Blog    http://doc.coker.com.au/
