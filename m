Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:35118 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3HDAvg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Aug 2013 20:51:36 -0400
Received: by mail-we0-f176.google.com with SMTP id q56so1482130wes.7
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Aug 2013 17:51:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <047d7b86daaa49592f04e3146f9d@google.com>
References: <CAOna0f2V=Aw8isLVkQy9RUKT60JOq0prsXuEVQke=QRjbRWUSg@mail.gmail.com>
	<047d7b86daaa49592f04e3146f9d@google.com>
Date: Sun, 4 Aug 2013 02:51:34 +0200
Message-ID: <CAOna0f2ADMzkOrY-x64Fmi4rcdQzAHtoXD_8xw+JPq1LQ8Otdw@mail.gmail.com>
Subject: Re: Delivery Status Notification (Failure)
From: Jesper Utoft <jesper.utoft@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello everybody.

I have run into serious trouble with my btrfs volume.

As an example after adding two disks to a btrfs volume they show up as
filled with data in btrfs filesystem show.

In btrfs fi df /mnt it says
Data RAID1: total=4.64TB, used=11.46TB
System.. (total > used so i think it is fine)
Metadata, Rid1: total=9.00GB, used=18.33GB

Obviously something have gone wrong
I have currently no idea on what to do.
I have tried running btrfsck but that didn't do anything.

The system i ubuntu 13.04 live cd kernel 3.8.0-19.

I have had trouble booting this server for a day's time, i end up in
initramfs with a mount issue.

Have anybody heard about something like this.
Please point me in the right direction :)

Thank you very much.
Cheers Jesper
