Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:56585 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751589AbaLDRlc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Dec 2014 12:41:32 -0500
Message-ID: <54809CCA.9030108@pobox.com>
Date: Thu, 04 Dec 2014 09:41:30 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs fi show not accepting mount path as arg?
References: <CAH-HCWUcMofyaE8pBXRM5LTHjWcabz+DKouVbauH=Oh9fv2g4g@mail.gmail.com>
In-Reply-To: <CAH-HCWUcMofyaE8pBXRM5LTHjWcabz+DKouVbauH=Oh9fv2g4g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/04/2014 05:50 AM, Shriramana Sharma wrote:
> [samjnaa:~] mount | grep btrfs
> /dev/sdb1 on /run/media/samjnaa/BRIHATII type btrfs
> (rw,nosuid,nodev,relatime,space_cache,uhelper=udisks2)
> [samjnaa:~] sudo btrfs fi show /run/media/samjnaa/BRIHATII/
> Btrfs v3.17+20141103
> [samjnaa:~]
>
> But the manpage of btrfs filesystem says that <path> is an acceptable
> argument to show, by which I understand to mean the mounted path of
> the filesystem (or a subvolume thereof?).
>
> Some problem here?
>

Mount Point:     /run/media/samjnaa/BRIHATII
Not Mount Point: /run/media/samjnaa/BRIHATII/

The trailing slash turns the mount point into an implicit reference to 
the dot "." entry inside the mounted directory instead of the mount 
point itself.

For normal file-system (vnode etc) operations inside the kernel there is 
no difference.

For system management operations there is a difference. Lots of tools do 
extra work to hide that difference. Apparently btrfs does not.

It gets even more confusing for root. Fo instance on my laptop with a 
BTRFS root...

Gust ~ # btrfs fi show /
Label: 'ROOT'  uuid: eca97d32-637d-41cb-914c-659875968b5e
         Total devices 1 FS bytes used 338.53GiB
         devid    1 size 456.45GiB used 351.06GiB path /dev/sda3

Btrfs v3.17.1
Gust ~ # btrfs fi show //
Btrfs v3.17.1
Gust ~ #

But the filesystem operations through the kernel are fine with extra 
slashes as extra slashes.

Gust ~ # ls -ld /etc
drwxr-xr-x 1 root root 4440 Dec  4 01:10 /etc
Gust ~ # ls -ld //etc
drwxr-xr-x 1 root root 4440 Dec  4 01:10 //etc
Gust ~ # ls -ld /
drwxr-xr-x 1 root root 380 Nov 18 17:35 /
Gust ~ # ls -ld //
drwxr-xr-x 1 root root 380 Nov 18 17:35 //
Gust ~ #


So the first rule of paranoid system management is "press backspace 
after tab when expanding directory names".

(Note also what the realpath command does, said command ne library being 
frequently and silently used in some utilities.)
