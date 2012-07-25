Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48863 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab2GYKh0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jul 2012 06:37:26 -0400
Received: by lbbgm6 with SMTP id gm6so529683lbb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2012 03:37:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAE5mzvgNs32guegtgYUnGVahAK=pz4mCmu8S8RD4RcThz1XLXQ@mail.gmail.com>
References: <CAAdM644Xs1Vq-Sw4ZacGz_gBrURHzEhhs4drXJC+dMtP0DhSiw@mail.gmail.com>
	<CAE5mzvgNs32guegtgYUnGVahAK=pz4mCmu8S8RD4RcThz1XLXQ@mail.gmail.com>
Date: Wed, 25 Jul 2012 06:37:25 -0400
Message-ID: <CAAdM647oTwm98M6a6+z+W_DPm9wLmxS68it97L=azhwgneqCxw@mail.gmail.com>
Subject: Re: No/bad auto-detection of fs type for small volumes (related to
 mixed metadata/data?)
From: Marios Titas <redneb8888@gmail.com>
To: cwillu <cwillu@cwillu.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 25, 2012 at 5:09 AM, cwillu <cwillu@cwillu.com> wrote:
> On Tue, Jul 24, 2012 at 6:39 PM, Marios Titas <redneb8888@gmail.com> wrote:
>> When I create a btrfs volume of size strictly less than 256 MiB then if I do
>>     mount /dev/sdb1 /mnt/test
>> the kernel tries unsuccessfully to do the mount with many other file systems
>> before successfully trying with btrfs. For volumes of size larger than
>> or equal to
>> 256 MiB it just mounts the volume without doing that. Why is this discrepancy?
>
> If I understand correctly, the kernel does not implement any fs
> detection; this is performed by the mount utility, which indeed may
> try a bunch of different filesystems until it finds one that works.
>
> From man mount:
>               If no -t option is given, or if  the  auto  type  is  specified,
>               mount  will try to guess the desired type.  Mount uses the blkid
>               or volume_id library for guessing the filesystem type;  if  that
>               does not turn up anything that looks familiar, mount will try to
>               read the file /etc/filesystems, or,  if  that  does  not  exist,
>               /proc/filesystems.   All  of  the  filesystem types listed there
>               will be tried, except for those that are labeled "nodev"  (e.g.,
>               devpts,  proc and nfs).  If /etc/filesystems ends in a line with
>               a single * only, mount will read /proc/filesystems afterwards.

Thanks, that was helpful. It was a blkid bug. It was fixed  [1] in
util-linux 2.21.

[1] https://git.kernel.org/?p=utils/util-linux/util-linux.git;a=commit;h=04f7020
