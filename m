Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:47735 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbaCYTrq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Mar 2014 15:47:46 -0400
Received: by mail-vc0-f179.google.com with SMTP id ij19so1191407vcb.24
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Mar 2014 12:47:45 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 25 Mar 2014 15:47:45 -0400
Message-ID: <CAJtFHUQCJhkDJiUgkrtoPJ=pN3+ngvAD_yhwb=_Kh1kQP+4xKA@mail.gmail.com>
Subject: Re: Bug in profile balance not present in normal balance
From: E V <eliventer@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> What about unallocated space, that is, the difference between total space
> and used space, per device, as reported by btrfs filesystem show?

File show gives:
        Total devices 3 FS bytes used 60.22TiB
        devid    1 size 30.01TiB used 17.61TiB path /dev/sdb
        devid    2 size 30.01TiB used 17.63TiB path /dev/sdc
        devid    3 size 40.02TiB used 27.48TiB path /dev/sdd

and the rest of btrfs df:
Data, RAID0: total=8.79TiB, used=8.79TiB
Data, single: total=53.68TiB, used=51.34TiB
System, RAID1: total=40.00MiB, used=6.64MiB
System, single: total=4.00MiB, used=0.00

As far as I can tell space shouldn't be an issue at all.
