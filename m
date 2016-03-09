Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:37086 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbcCIWI0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 17:08:26 -0500
Received: by mail-wm0-f45.google.com with SMTP id p65so4766565wmp.0
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Mar 2016 14:08:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ-0KqCmfeV9n7VMnvFvN=K3uEhGsSJKMeHwTxjz3to6Q@mail.gmail.com>
References: <CAD=QJKi-3PJQViAaRmGoz3_w6RQbRehDL9vXs14+CSHsG3ipTg@mail.gmail.com>
	<CAD=QJKg6xFSFjJdDyD+v0Rd2afeB-ZRRy2SncC1Db5fyT3cf9A@mail.gmail.com>
	<20160310023627.2e915667@natsu>
	<CAJCQCtQ-0KqCmfeV9n7VMnvFvN=K3uEhGsSJKMeHwTxjz3to6Q@mail.gmail.com>
Date: Wed, 9 Mar 2016 17:08:24 -0500
Message-ID: <CAD=QJKhw-2+b3i0K3oznR3zp5+z4A2XVgfQhdEA318XmQtR1Zg@mail.gmail.com>
Subject: Re: dstat shows unexpected result for two disk RAID1
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9 March 2016 at 16:43, Chris Murphy <lists@colorremedies.com> wrote:
> On Wed, Mar 9, 2016 at 2:36 PM, Roman Mamedov <rm@romanrm.net> wrote:
>> On Wed, 9 Mar 2016 15:25:19 -0500
> This is a better qualification than my answer.
>
>>
>> Now if you want to do some more performance evaluation, check with your dstat
>> if both disks happen to *write* data in parallel, when you write to the array,
>> as ideally they should. Last I checked they mostly didn't, and this almost
>> halved write performance on a Btrfs RAID1 compared to a single disk.
>
> I've found it to be about the same or slightly less than single disk.
> But most of my writes to raid1 are btrfs receive.

Here are my results for sending pv /tmpfs_mem_disk/deleteme.tar -pabet
> /scratch/deleteme.tar, after I've cleared all caches.  Pv states the
average rate was 77MiB/s, which seems low for a 4GB file.  Here is the
dstat section for peak rates for writing.

----system---- -dsk/total----dsk/sdb-----dsk/sdd--
            time     |  read     writ: read   writ: read  writ
09-03 16:48:43|   48k  145M:   0    74M:  48k   72M
09-03 16:48:44|      0   120M:   0    74M:   0     46M
09-03 16:48:45| 840k  144M:   0    74M:   0     70M
09-03 16:48:46|      0   147M:   0    80M:   0     67M

and for reading many >200MB raw WAVs from one subvolume while writing
a ~20GB tar to another subvolume:

09-03 16:59:57|  56M  103M:   0    54M:  56M   50M
09-03 16:59:58|  48M  118M:  32k   56M:  48M   62M
09-03 16:59:59|  54M  113M:   0    57M:  54M   55M
09-03 17:00:00|  43M  116M:   0    54M:  43M   63M
09-03 17:00:01|  60M  118M:   0    64M:  60M   54M
09-03 17:00:02|  57M   97M:  32k   48M:  54M   49M
