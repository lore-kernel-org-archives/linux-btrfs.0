Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52815 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932767Ab2GYJJF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jul 2012 05:09:05 -0400
Received: by pbbrp8 with SMTP id rp8so1105601pbb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2012 02:09:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAdM644Xs1Vq-Sw4ZacGz_gBrURHzEhhs4drXJC+dMtP0DhSiw@mail.gmail.com>
References: <CAAdM644Xs1Vq-Sw4ZacGz_gBrURHzEhhs4drXJC+dMtP0DhSiw@mail.gmail.com>
Date: Wed, 25 Jul 2012 03:09:05 -0600
Message-ID: <CAE5mzvgNs32guegtgYUnGVahAK=pz4mCmu8S8RD4RcThz1XLXQ@mail.gmail.com>
Subject: Re: No/bad auto-detection of fs type for small volumes (related to
 mixed metadata/data?)
From: cwillu <cwillu@cwillu.com>
To: Marios Titas <redneb8888@gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 24, 2012 at 6:39 PM, Marios Titas <redneb8888@gmail.com> wrote:
> When I create a btrfs volume of size strictly less than 256 MiB then if I do
>     mount /dev/sdb1 /mnt/test
> the kernel tries unsuccessfully to do the mount with many other file systems
> before successfully trying with btrfs. For volumes of size larger than
> or equal to
> 256 MiB it just mounts the volume without doing that. Why is this discrepancy?

If I understand correctly, the kernel does not implement any fs
detection; this is performed by the mount utility, which indeed may
try a bunch of different filesystems until it finds one that works.

>From man mount:
              If no -t option is given, or if  the  auto  type  is  specified,
              mount  will try to guess the desired type.  Mount uses the blkid
              or volume_id library for guessing the filesystem type;  if  that
              does not turn up anything that looks familiar, mount will try to
              read the file /etc/filesystems, or,  if  that  does  not  exist,
              /proc/filesystems.   All  of  the  filesystem types listed there
              will be tried, except for those that are labeled "nodev"  (e.g.,
              devpts,  proc and nfs).  If /etc/filesystems ends in a line with
              a single * only, mount will read /proc/filesystems afterwards.
