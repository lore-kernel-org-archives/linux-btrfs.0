Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57061 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082AbaAISUc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jan 2014 13:20:32 -0500
Received: by mail-ie0-f174.google.com with SMTP id at1so3989646iec.33
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jan 2014 10:20:31 -0800 (PST)
Message-ID: <52CEE872.8040804@gmail.com>
Date: Thu, 09 Jan 2014 13:20:34 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: How does btrfs handle bad blocks in raid1?
References: <CAFvQSYRWBqMdAm-9yWhv4SS1YW-LB71iOZvgkNPc9BG3Wh7erw@mail.gmail.com>	<20140109104247.GH15634@carfax.org.uk> <pan$ab233$2067aff9$a13049e6$e769dc55@cox.net> <52CE9B9C.2040006@gmail.com> <DA8C6B1F-100C-46D0-8DF5-F77C85FB9A50@colorremedies.com>
In-Reply-To: <DA8C6B1F-100C-46D0-8DF5-F77C85FB9A50@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-01-09 12:31, Chris Murphy wrote:
> 
> On Jan 9, 2014, at 5:52 AM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> Just a thought, you might consider running btrfs on top of LVM in
>> the interim, it isn't quite as efficient as btrfs by itself, but
>> it does allow N-way mirroring (and the efficiency is much better
>> now that they have switched to RAID1 as the default mirroring
>> backend)
> 
> The problem that in case of mismatches, it's ambiguous which are
> correct.
> 
At the moment that is correct, I've been planning for some time now to
write a patch so that the RAID1 implementation on more than 2 devices
checks what the majority of other devices say about the block, and
then updates all of them with the majority.  Barring a manufacturing
defect or firmware bug, any group of three or more disks is
statistically very unlikely to have a read error at the same place on
each disk until they have accumulated enough bad sectors that they are
totally unusable, so this would allow recovery in a non-degraded RAID1
array in most cases.

