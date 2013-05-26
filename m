Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64670 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab3EZMDL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 May 2013 08:03:11 -0400
Received: by mail-wg0-f46.google.com with SMTP id l18so3624350wgh.1
        for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 05:03:10 -0700 (PDT)
Message-ID: <51A1F9FD.7000807@gmail.com>
Date: Sun, 26 May 2013 14:03:09 +0200
From: "xavier.gnata@gmail.com" <xavier.gnata@gmail.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: compression on external hard drive?
References: <51A1372B.6060402@gnata.eu> <pan$a1b3e$c3ed264b$c0ac127c$7262bed0@cox.net>
In-Reply-To: <pan$a1b3e$c3ed264b$c0ac127c$7262bed0@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/26/2013 04:23 AM, Duncan wrote:
> Xavier Gnata posted on Sun, 26 May 2013 00:11:55 +0200 as excerpted:
>
>> Nowdays, external hard drives are mounted automagically by kde, gnome or
>> whatever else.
>> How is it suppose to work with external hard drives using btrfs with
>> compression?
>> If a btrfs filesystem lzo-compressed is mounted without the
>> |compress=|xxx option then all the newly created files are uncompressed,
>> aren't then?
>> Would it be possible to detect if a file system is compressed  and to
>> mount it *automatically* and accordingly (except otherwise explicitly
>> stated by the user) with/without the lzo/gzip option?
> There's a proposal to do something like ext3/4's default options as set
> by tune2fs, at some point, presumably before btrfs loses the "unstable
> disk format" and under heavy development warnings.  However, there's
> nothing like that yet, AFAIK, so most options must be set per-mount.
>
> There's a lot you can do with udev events, however, and strongly suspect
> either compression-detection, or match-against-a-list-and-compress (or
> don't compress if the default is compression otherwise) if the UUID/LABEL
> is listed.
>
> Alternatively, at least kde can be set not to automount specific UUIDs/
> LABELs, and then there's always the traditional fstab option, and I think
> either fstab entered drives are ignored by the automount system or
> they're automounted with options from fstab (I have that kde subsystem
> entirely disabled here so it doesn't automount anything, so I'm not sure
> which it actually does).
>
Ok I'm going to play with udev event and have a lot at what kde4.10.3 
can do.
However, I hope this will be solved at fs level once the dust has settled.

Xavier
