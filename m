Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:32958 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbcD2UR0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 16:17:26 -0400
Received: by mail-ob0-f182.google.com with SMTP id x1so37937550obt.0
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Apr 2016 13:17:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGGqMYQPVQoKDcuDqp0D=3BCD+oTghew0fyzqo58BSLFrmrEJQ@mail.gmail.com>
References: <CAGGqMYQPVQoKDcuDqp0D=3BCD+oTghew0fyzqo58BSLFrmrEJQ@mail.gmail.com>
Date: Fri, 29 Apr 2016 14:17:24 -0600
Message-ID: <CAJCQCtTG68BicgFwoyYgM0OzphsVbstgWTNybF3CeBo1VCJhNg@mail.gmail.com>
Subject: Re: receive snapshot, complains about missing file
From: Chris Murphy <lists@colorremedies.com>
To: Alexander Fougner <fougner89@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 29, 2016 at 2:01 PM, Alexander Fougner <fougner89@gmail.com> wrote:
> Hello,
>
> Kernel 4.4.x and progs 4.5.1 on both client/host.
>
> As the topic says, I noticed that my automatic backus stopped working
> a while back. The cause seems to be related to snapshot
> inconsistencies.
>
> WARNING: [btrfs send/receive]
> (send=/mnt/btrfs_pool/__snapshots/@home.20160404,
> receive=/srv/backup/optimus) At subvol
> /mnt/btrfs_pool/__snapshots/@home.20160404
> WARNING: [btrfs send/receive]
> (send=/mnt/btrfs_pool/__snapshots/@home.20160404,
> receive=/srv/backup/optimus) At snapshot @home.20160404
> ERROR: cannot open
> srv/backup/optimus/@home.20160403/alex/Android/LNU/Ass1/.gradle/2.8/taskArtifacts/taskArtifacts.bin:
> No such file or directory
> ERROR: Failed to send/receive btrfs subvolume:
> /mnt/btrfs_pool/__snapshots/@home.20160404
> [/mnt/btrfs_pool/__snapshots/@home.20160403] ->
> fractal:/srv/backup/optimus
> WARNING: Deleted partially received (garbled) subvolume:
> fractal:/srv/backup/optimus/@home.20160404
> ERROR: Error while resuming backups, aborting
>
> However, the file exists in all relevant places.
>
> This is the relevant part from btrfs receive -vvv, before it stops working.
>
> rename o1283816-161574-0 -> alex/Android/LNU/Ass1
> (kopia)/.gradle/2.8/taskArtifacts/cache.properties
> utimes alex/Android/LNU/Ass1 (kopia)/.gradle/2.8/taskArtifacts
> truncate alex/Android/LNU/Ass1
> (kopia)/.gradle/2.8/taskArtifacts/cache.properties size=30
> chown alex/Android/LNU/Ass1
> (kopia)/.gradle/2.8/taskArtifacts/cache.properties - uid=1000,
> gid=1000
> chmod alex/Android/LNU/Ass1
> (kopia)/.gradle/2.8/taskArtifacts/cache.properties - mode=0664
> utimes alex/Android/LNU/Ass1 (kopia)/.gradle/2.8/taskArtifacts/cache.properties
> mkfile o1283817-161574-0
> rename o1283817-161574-0 -> alex/Android/LNU/Ass1
> (kopia)/.gradle/2.8/taskArtifacts/taskArtifacts.bin
> utimes alex/Android/LNU/Ass1 (kopia)/.gradle/2.8/taskArtifacts
> ERROR: cannot open
> srv/backup/optimus/@home.20160403/alex/Android/LNU/Ass1/.gradle/2.8/taskArtifacts/taskArtifacts.bin:
> No such file or directory
>
>

Do scrub and btrfs check (no repair) complete without errors?


-- 
Chris Murphy
