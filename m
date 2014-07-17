Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:55796 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbaGQD1E (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 23:27:04 -0400
Received: by mail-qa0-f43.google.com with SMTP id w8so1449020qac.16
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Jul 2014 20:27:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53C6FA3D.9010803@informatik.uni-bonn.de>
References: <53C6FA3D.9010803@informatik.uni-bonn.de>
Date: Wed, 16 Jul 2014 23:27:02 -0400
Message-ID: <CAMXuLLrLgxmG1uU+JS5vBe7m36s=4XobWhh438G4RD5b94bzRg@mail.gmail.com>
Subject: Re: Is it safe to mount subvolumes of already-mounted volumes (even
 with different options)?
From: Zhe Zhang <zhe.zhang.research@gmail.com>
To: Sebastian Ochmann <ochmann@informatik.uni-bonn.de>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Sebastian,

I posted a similar question and got many helpful answers:
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg35047.html

Basically, you cannot guarantee that the computing mounting /dev/sdx
doesn't write to arbitrary addresses of /dev/sdxN as unallocated
blocks and thus corrupting the file system on it (I assume sdxN in
your example is a sub volume of sdx).

On Wed, Jul 16, 2014 at 6:18 PM, Sebastian Ochmann
<ochmann@informatik.uni-bonn.de> wrote:
> Hello,
>
> I'm sharing a btrfs-formatted drive between multiple computers and each of
> the machines has a separate home directory on that drive. The root of the
> drive is mounted at /mnt/tray and the home directory for machine {hostname}
> is under /mnt/tray/Homes/{hostname}. Up until now, I have mounted /mnt/tray
> like a normal volume and then did an additional bind-mount of
> /mnt/tray/Homes/{hostname} to /home.
>
> Now I have a new drive and wanted to do things a bit more advanced by
> creating subvolumes for each of the machines' home directories so that I can
> also do independent snapshotting. I guess I could use the bind-mount method
> like before but my question is if it is considered safe to do an additional,
> "regular" mount of one of the subvolumes to /home instead, like
>
> mount /dev/sdxN /mnt/tray
> mount -o subvol=/Homes/{hostname} /dev/sdxN /home
>
> When I experimented with such additional mounts of subvolumes of
> already-mounted volumes, I noticed that the mount options of the additional
> subvolume mount might differ from the "original" mount. For instance, the
> root volume might be mounted with "noatime" while the subvolume mount may
> have "relatime".
>
> So my questions are: Is mounting a subvolume of an already mounted volume
> considered safe and are there any combinations of possibly conflicting mount
> options one should be aware of (compression, autodefrag, cache clearing)? Is
> it advisable to use the same mount options for all mounts pointing to the
> same physical device?
>
> Best regards,
> Sebastian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
