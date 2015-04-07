Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:35261 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbbDGK6a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Apr 2015 06:58:30 -0400
Received: by lbbuc2 with SMTP id uc2so36074095lbb.2
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Apr 2015 03:58:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK1hC9skBYrM7nPyU-2mCuey6VkFOGMUCi0umYduX3ePNJ2mpg@mail.gmail.com>
References: <CAK1hC9skBYrM7nPyU-2mCuey6VkFOGMUCi0umYduX3ePNJ2mpg@mail.gmail.com>
Date: Tue, 7 Apr 2015 12:58:28 +0200
Message-ID: <CAK1hC9tBAvqOhGLGcX=1Ls2QwtaB6fe6Wzf89vH4=Y+kvxHR_Q@mail.gmail.com>
Subject: Re: btrfs subvolume & default subvolume
From: arnaud gaboury <arnaud.gaboury@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 7, 2015 at 11:57 AM, arnaud gaboury
<arnaud.gaboury@gmail.com> wrote:
>
> I plan to install my OS on a btrfs partition, with some subvolumes.
> Once the partition has been btrfs formated, I mounted it somewhere, cd
> and then run <btrfs subvolume create>.
>
> I did these two subvolumes for now:
> # btrfs subvolume list .
> ID 256 gen 6 top level 5 path var
> ID 257 gen 7 top level 5 path home
>
> Now I am wondering if I need to create the root filesystem partition
> (/)? If yes, is this correct:
> # btrfs subvolume create root


After more reading, it seems to me creating a top root subvolume is
the right thing to do:
# btrfs subvolume create root
# btrfs subvolume create root/var
# btrfs subvolume create root/home

Am I right?

>
> Thank you for hints
> --
>
> google.com/+arnaudgabourygabx
