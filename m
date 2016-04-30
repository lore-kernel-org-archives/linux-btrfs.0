Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:36233 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbcD3K2g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Apr 2016 06:28:36 -0400
Received: by mail-lf0-f45.google.com with SMTP id u64so142964178lff.3
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Apr 2016 03:28:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRk+V0vhdCsyi-3aoNDimV0E4XJjQc9Us35uO59HpjSAQ@mail.gmail.com>
References: <CAGGqMYQPVQoKDcuDqp0D=3BCD+oTghew0fyzqo58BSLFrmrEJQ@mail.gmail.com>
	<CAJCQCtTG68BicgFwoyYgM0OzphsVbstgWTNybF3CeBo1VCJhNg@mail.gmail.com>
	<CAGGqMYTso0XNjgfmWfY8g3Xs9xym5gHFcTizzAq1_Y-mMTTx0w@mail.gmail.com>
	<CAJCQCtRk+V0vhdCsyi-3aoNDimV0E4XJjQc9Us35uO59HpjSAQ@mail.gmail.com>
Date: Sat, 30 Apr 2016 12:28:34 +0200
Message-ID: <CAGGqMYSZ8P=ZVSgL4zWJKi7uuYLxRMZh=XEzPYpT2PykQD58oQ@mail.gmail.com>
Subject: Re: receive snapshot, complains about missing file
From: Alexander Fougner <fougner89@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Heh, sorry about the noise!

2016-04-29 22:28 GMT+02:00 Chris Murphy <lists@colorremedies.com>:
> On Fri, Apr 29, 2016 at 2:20 PM, Alexander Fougner <fougner89@gmail.com> wrote:
>> 2016-04-29 22:17 GMT+02:00 Chris Murphy <lists@colorremedies.com>:
>>> On Fri, Apr 29, 2016 at 2:01 PM, Alexander Fougner <fougner89@gmail.com> wrote:
>>>> Hello,
>>>>
>>>> Kernel 4.4.x and progs 4.5.1 on both client/host.
>>>>
>>>> As the topic says, I noticed that my automatic backus stopped working
>>>> a while back. The cause seems to be related to snapshot
>>>> inconsistencies.
>>>>
>>>> WARNING: [btrfs send/receive]
>>>> (send=/mnt/btrfs_pool/__snapshots/@home.20160404,
>>>> receive=/srv/backup/optimus) At subvol
>>>> /mnt/btrfs_pool/__snapshots/@home.20160404
>>>> WARNING: [btrfs send/receive]
>>>> (send=/mnt/btrfs_pool/__snapshots/@home.20160404,
>>>> receive=/srv/backup/optimus) At snapshot @home.20160404
>>>> ERROR: cannot open
>>>> srv/backup/optimus/@home.20160403/alex/Android/LNU/Ass1/.gradle/2.8/taskArtifacts/taskArtifacts.bin:
>>>> No such file or directory
>>>> ERROR: Failed to send/receive btrfs subvolume:
>>>> /mnt/btrfs_pool/__snapshots/@home.20160404
>>>> [/mnt/btrfs_pool/__snapshots/@home.20160403] ->
>>>> fractal:/srv/backup/optimus
>>>> WARNING: Deleted partially received (garbled) subvolume:
>>>> fractal:/srv/backup/optimus/@home.20160404
>>>> ERROR: Error while resuming backups, aborting
>>>>
>>>> However, the file exists in all relevant places.
>>>>
>>>> This is the relevant part from btrfs receive -vvv, before it stops working.
>>>>
>>>> rename o1283816-161574-0 -> alex/Android/LNU/Ass1
>>>> (kopia)/.gradle/2.8/taskArtifacts/cache.properties
>>>> utimes alex/Android/LNU/Ass1 (kopia)/.gradle/2.8/taskArtifacts
>>>> truncate alex/Android/LNU/Ass1
>>>> (kopia)/.gradle/2.8/taskArtifacts/cache.properties size=30
>>>> chown alex/Android/LNU/Ass1
>>>> (kopia)/.gradle/2.8/taskArtifacts/cache.properties - uid=1000,
>>>> gid=1000
>>>> chmod alex/Android/LNU/Ass1
>>>> (kopia)/.gradle/2.8/taskArtifacts/cache.properties - mode=0664
>>>> utimes alex/Android/LNU/Ass1 (kopia)/.gradle/2.8/taskArtifacts/cache.properties
>>>> mkfile o1283817-161574-0
>>>> rename o1283817-161574-0 -> alex/Android/LNU/Ass1
>>>> (kopia)/.gradle/2.8/taskArtifacts/taskArtifacts.bin
>>>> utimes alex/Android/LNU/Ass1 (kopia)/.gradle/2.8/taskArtifacts
>>>> ERROR: cannot open
>>>> srv/backup/optimus/@home.20160403/alex/Android/LNU/Ass1/.gradle/2.8/taskArtifacts/taskArtifacts.bin:
>>>> No such file or directory
>>>>
>>>>
>>>
>>> Do scrub and btrfs check (no repair) complete without errors?

Send side

sudo btrfs check /dev/sda1
Checking filesystem on /dev/sda1
UUID: 2deed283-bc4e-4d8b-bc6c-9ca035d90342
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 106157568114 bytes used err is 0
total csum bytes: 102001828
total tree bytes: 1585774592
total fs tree bytes: 1387134976
total extent tree bytes: 74448896
btree space waste bytes: 348106294
file data blocks allocated: 272060542976
 referenced 190188584960

Receive side only outputs this:
sudo btrfs check -p /dev/sdc
Couldn't open file system


Scrub completes without errors on both FS.

>>>
>> Scrub does, don't know about btrfs check yet. Will run check and report back.
>
> And actually it applies to both source and destination file systems.
> Chances are it's the receive one that has the problem, but better to
> be certain. Maybe send is sending something (?) that receive isn't
> expecting and the problem is actually there?
>
>
> --
> Chris Murphy
