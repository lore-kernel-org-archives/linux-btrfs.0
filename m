Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:32769 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757187AbbCRWPw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Mar 2015 18:15:52 -0400
Received: by ykek76 with SMTP id k76so21849368yke.0
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2015 15:15:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5509F08E.6070702@graphitesystems.com>
References: <5509E34F.6010504@graphitesystems.com>
	<CAJCQCtSmV63H4OnEgv2ZXSFq4s8npEGmDxUBDO5dHb7pmoC0zw@mail.gmail.com>
	<5509F08E.6070702@graphitesystems.com>
Date: Wed, 18 Mar 2015 16:15:51 -0600
Message-ID: <CAJCQCtQU=KzNqY=MTdqET5-J2JpDrS+O9EE50o9aXbRCJHU+xQ@mail.gmail.com>
Subject: Re: syntax for deleting subvolumes?
From: Chris Murphy <lists@colorremedies.com>
To: K Richard Pixley <rpixley@graphitesystems.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 18, 2015 at 3:39 PM, K Richard Pixley
<rpixley@graphitesystems.com> wrote:

> Ah!  Thank you.  That's the piece I was missing.
>
> IMO, someone needs to take a clue-by-four to the heads of the
> Fedora/RHEL/CentOS installer folks.  I see no reason for this with btrfs.

Other than the technical reasons Hugo mentions regarding nesting...

The problem with the "install normally to top level with Linux FHS"
approach like Ubuntu and openSUSE follow now, is that snapshots then
have to go in the mounted path. This arguably exposes old binaries in
that mounted path and is a possible security risk. There are some ways
to mitigate that, but better when it's simply not in the mounted path,
sorta like a chroot.

It's also a better way to organize stateless systems. Myriad trees
that can be used to form a stateless system existing "out of tree" and
mounted either by path or subvolid is more sane (or at least less
madness inducing) than alternatives. See under "what we propose" for
the subvol naming convention:
http://0pointer.net/blog/revisiting-how-we-put-together-linux-systems.html

This is also compatible with delivery of such systems with a btrfs seed device.


-- 
Chris Murphy
