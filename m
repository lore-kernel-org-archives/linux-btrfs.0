Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:39650 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127AbbDGN6e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Apr 2015 09:58:34 -0400
From: Russell Coker <russell@coker.com.au>
To: arnaud gaboury <arnaud.gaboury@gmail.com>
Subject: Re: btrfs subvolume & default subvolume
Date: Tue, 7 Apr 2015 13:58:29 +0000
Cc: linux-btrfs@vger.kernel.org
References: <CAK1hC9skBYrM7nPyU-2mCuey6VkFOGMUCi0umYduX3ePNJ2mpg@mail.gmail.com> <CAK1hC9tBAvqOhGLGcX=1Ls2QwtaB6fe6Wzf89vH4=Y+kvxHR_Q@mail.gmail.com>
In-Reply-To: <CAK1hC9tBAvqOhGLGcX=1Ls2QwtaB6fe6Wzf89vH4=Y+kvxHR_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201504071358.29442.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 7 Apr 2015 10:58:28 AM arnaud gaboury wrote:
> After more reading, it seems to me creating a top root subvolume is
> the right thing to do:
> # btrfs subvolume create root
> # btrfs subvolume create root/var
> # btrfs subvolume create root/home
> 
> Am I right?

A filesystem is designed to support arbitrary names for files, directories, and 
in the case of BTRFS subvolumes.

You might ask whether /var/log is a good place for log files, it's generally 
regarded that "yes" is the correct answer to that question, but it's not a 
question for filesystem developers.

I like to have / in the root subvolume so all subvolumes are available by 
default.  I have /var etc in the same subvolume so I can make an atomic 
snapshot of all such data.  It's not the one true answer, but it works for me 
and will work for other people.

The main thing is to have all data that needs to be atomically snapshotted on 
the same subvolume.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
