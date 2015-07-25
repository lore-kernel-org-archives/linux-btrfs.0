Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f195.google.com ([209.85.160.195]:36384 "EHLO
	mail-yk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbbGYNy0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jul 2015 09:54:26 -0400
Received: by ykdu72 with SMTP id u72so2600046ykd.3
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Jul 2015 06:54:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHTNZTcZiXYg5AqsgsdOpigUva_5EcGmCKCu8tqcbSsjYDxpTQ@mail.gmail.com>
References: <CAHTNZTcZiXYg5AqsgsdOpigUva_5EcGmCKCu8tqcbSsjYDxpTQ@mail.gmail.com>
Date: Sat, 25 Jul 2015 08:42:27 -0500
Message-ID: <CAKJi5fhsRo-r-GzBer96sNvc_AWYPSiOH1VU+Uz07Vb+0UoOBg@mail.gmail.com>
Subject: Re: Inappropriate ioctl for device
From: Jim Murphy <srlinuxadmin@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 25, 2015 at 3:56 AM, Mojtaba <kernel@rp2.org> wrote:
> Hello
> I have had some problems with btrfs for some time and it seems no one

[snip]

> System is debian wheezy or Jessie.
> This is Debian Jessie:
>
> root@s2:/# uname -a
> Linux s2 3.2.0-4-amd64 #1 SMP Debian 3.2.60-1+deb7u3 x86_64 GNU/Linux
> root@s2:/#   btrfs --version
> Btrfs v3.17

This appears to be Debian Wheezy.  You can use "cat /etc/debian_version" to
verify(7.n = Wheezy).  There is a backports kernel which is version 3.16
that you can upgrade to.  You will need to add the wheezy backports
repository to apt.

Note:  Watch the dependencies during the upgrade.  You may want to choose
  initramfs-tools from backports rather than dracut which was offered as a
  replacement for initramfs-tools.

[snip]

>
> I've successfully run balance on this system once a few days ago
> however after that I'm getting Inappropriate ioctl
>
> Thanks

[snip]

Hope this helps,

Jim
