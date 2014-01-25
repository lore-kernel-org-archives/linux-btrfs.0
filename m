Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 60-242-5-228.static.tpgi.com.au ([60.242.5.228]:37458 "EHLO
	tankgenquad.kendrummond.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751914AbaAYQ6q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jan 2014 11:58:46 -0500
Message-ID: <52E3EB12.8090601@kendrummond.com>
Date: Sun, 26 Jan 2014 02:49:22 +1000
From: Ken Drummond <btrfs@kendrummond.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, Maxdamantus <maxdamantus@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Fwd: Is there a lightweight copy from one subvolume to another?
References: <20140125070415.GB14998@merlins.org>	<CA+TwyweCeUQ7w5MuRLrfHfmJwDbChX5VodsyW8huQ9YuLOAWQA@mail.gmail.com>	<CA+TwywcetN9Cy_SoKvq9rc7XQJVWERbFehCE1Bhn=Jz81SEGJg@mail.gmail.com> <20140125091705.GB7555@merlins.org>
In-Reply-To: <20140125091705.GB7555@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25/01/2014 7:17 PM, Marc MERLIN wrote:
> On Sat, Jan 25, 2014 at 09:50:48PM +1300, Maxdamantus wrote:
>> Due to what I understand is some VFS limitation, you can only
>> reflink-copy between subvolumes under one Linux mountpoint. If
>> /mnt/btrfs1 provides access to all subvolumes, you should be able to
>> copy between them through that path, but you won't be able to copy
>> them across mounts, even `--bind` ones.
>
> That was exactly my understanding too.
>
>>> gargamel [mc]# cp -av --reflink=always misc/olympic Video/misc/
>>> `misc/olympic' -> `Video/misc/olympic'
>>> `misc/olympic/file.avi' -> `Video/misc/olympic/file.avi'
>>> cp: failed to clone `Video/misc/olympic/file.avi' from `misc/olympic/file.avi': Invalid cross-device link
>
> The test above was done in /mnt/btrfs_pool1 and failed as shown here.
>
> Yet
> gargamel:/mnt/btrfs_pool1# btrfs subvolume list .
> ID 257 top level 5 path misc
> ID 258 top level 5 path Video
> ID 259 top level 5 path media
> ID 260 top level 5 path Sound
> ID 261 top level 5 path zoneminder
> ID 262 top level 5 path other
>
> Aah, but it looks like this was my problem:
> 'Preparing to replace coreutils 8.13-3.2 (using .../coreutils_8.21-1_i386.deb) ...
>
> now cp --reflink works as expected.
>
> Thanks,
> Marc
>


If I recall correctly you also need a kernel >= 3.7.  Which I assume you 
have if this is now working.

Ken.
