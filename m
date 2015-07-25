Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:32983 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbbGYJPY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jul 2015 05:15:24 -0400
Received: by wicmv11 with SMTP id mv11so86368668wic.0
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Jul 2015 02:15:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHTNZTcZiXYg5AqsgsdOpigUva_5EcGmCKCu8tqcbSsjYDxpTQ@mail.gmail.com>
References: <CAHTNZTcZiXYg5AqsgsdOpigUva_5EcGmCKCu8tqcbSsjYDxpTQ@mail.gmail.com>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Sat, 25 Jul 2015 11:15:04 +0200
Message-ID: <CAA7pwKNBZQiAc7UjOw3DOXyr-b4U63s1Qa8ciAsGnfOUJMX_7Q@mail.gmail.com>
Subject: Re: Inappropriate ioctl for device
To: Mojtaba <kernel@rp2.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25 July 2015 at 10:56, Mojtaba <kernel@rp2.org> wrote:
>
> System is debian wheezy or Jessie.
> This is Debian Jessie:
>
> root@s2:/# uname -a
> Linux s2 3.2.0-4-amd64 #1 SMP Debian 3.2.60-1+deb7u3 x86_64 GNU/Linux

That's a way too old kernel to be running Btrfs on. You should be
running on at least the Jessie 3.16 kernel.
