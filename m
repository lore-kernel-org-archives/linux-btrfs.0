Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:33013 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbcGHVjY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jul 2016 17:39:24 -0400
Received: by mail-oi0-f44.google.com with SMTP id u201so76389971oie.0
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Jul 2016 14:39:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0e0dcbb3-73a4-0c5f-9978-67109d505b79@freenet.de>
References: <96f8022e-4209-2498-62e4-50ccbee46e37@freenet.de>
 <CAPmG0jZZ7FB0teBGGHojPoGctRyVC3D2cS56q1kYDMFrC=fOnA@mail.gmail.com>
 <CAJCQCtQt2A7w4JNUuhU7YOHTyj_z8M_RqsZCDw0G2YEENXaBvg@mail.gmail.com> <0e0dcbb3-73a4-0c5f-9978-67109d505b79@freenet.de>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 8 Jul 2016 15:39:23 -0600
Message-ID: <CAJCQCtSd9NTffBJUFwT2ja6PahdCqa=Sm5joP3aptD4OmVoW7w@mail.gmail.com>
Subject: Re: rollback to a snapshot and delete old top volume - missing of "@"
To: Kai Herlemann <nesadaw@freenet.de>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 8, 2016 at 2:08 PM, Kai Herlemann <nesadaw@freenet.de> wrote:

> If here any developers read along: I'd like to suggest that there's
> automatically made a subvolume "@" by default, which is set as default
> subvolume, or a tip to the distribution, that it would made sense to do that
> with the installation. It would protect other users against confusion and
> work like I had it.

I think that upstream won't do that or recommend it. There is already
a subvolume created at mkfs time, that's subvolid=5 (a.k.a. 0) and it
is set as the default subvolume. I don't see the point in having two
of them. If you want it, make it. If your distro wants it, it should
be done in the installer, not mkfs.

Further I think it's inappropriate to take 'btrfs sub set-default'
away from the user. That is a user owned setting. It is not OK for
some utility to assert domain over that setting, and depend on it for
proper booting. It makes the entire boot process undiscoverable,
breaks self-describing boot process which are simpler to understand
and troubleshoot, in favor of secret decoder ring booting that now
requires even more esoteric knowledge on the part of users. So I think
it's a bad design.

Instead those utilities should employ rootflags=subvol or subvolid to
explicitly use a particular fs tree for rootfs, rather that hide this
fact by using subvolume set-default.



-- 
Chris Murphy
