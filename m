Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16.italiaonline.it ([212.48.25.144]:34202 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750825AbdEBTu2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 May 2017 15:50:28 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Can I see what device was used to mount btrfs?
References: <1e2e2e5c-5ee8-85c1-1db4-74293d8c9c1e@gmail.com>
 <20170502135820.2ft7bsoceeqhnbqf@angband.pl>
 <CAA91j0V97dCb+j_thg0oi7B4D29VVKcqtRcpCWbgQyzi+FScKA@mail.gmail.com>
 <20170502184923.jdpfx3pwkl5avdph@angband.pl>
To: Adam Borowski <kilobyte@angband.pl>,
        Andrei Borzenkov <arvidjaar@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <c7f3c9fe-2f28-e102-9df7-273dc5a6ca8e@inwind.it>
Date: Tue, 2 May 2017 21:50:19 +0200
MIME-Version: 1.0
In-Reply-To: <20170502184923.jdpfx3pwkl5avdph@angband.pl>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-05-02 20:49, Adam Borowski wrote:
>> It could be some daemon that waits for btrfs to become complete.  Do we
>> have something?
> Such a daemon would also have to read the chunk tree.

I don't think that a daemon is necessary. As proof of concept, in the past I developed a mount helper [1] which handled the mount of a btrfs filesystem:
this handler first checks if the filesystem is a multivolume devices, if so it waits that all the devices are appeared. Finally mount the filesystem.

> It's not so simple -- such a btrfs device would have THREE states:
> 
> 1. not mountable yet (multi-device with not enough disks present)
> 2. mountable ro / rw-degraded
> 3. healthy

My mount.btrfs could be "programmed" to wait a timeout, then it mounts the filesystem as degraded if not all devices are present. This is a very simple strategy, but this could be expanded.

I am inclined to think that the current approach doesn't fit well the btrfs requirements.  The roles and responsibilities are spread to too much layer (udev, systemd, mount)... I hoped that my helper could be adopted in order to concentrate all the responsibility to only one binary; this would reduce the interface number with the other subsystem (eg systemd, udev).

For example, it would be possible to implement a sane check that prevent to mount a btrfs filesystem if two devices exposes the same UUID... 


BR
G.Baroncelli

[1] See "[RFC][PATCH v2] mount.btrfs helper" thread ( https://marc.info/?l=linux-btrfs&m=141736989508243&w=2 )



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
