Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f172.google.com ([209.85.210.172]:60360 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788Ab3CGUuH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Mar 2013 15:50:07 -0500
Received: by mail-ia0-f172.google.com with SMTP id l29so842446iag.3
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Mar 2013 12:50:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANDob0JBA8P1jVtB7zd=qfHVcBZMrC7pusNcSr3+OtKQv5=49g@mail.gmail.com>
References: <CANDob0JBA8P1jVtB7zd=qfHVcBZMrC7pusNcSr3+OtKQv5=49g@mail.gmail.com>
Date: Thu, 7 Mar 2013 14:50:06 -0600
Message-ID: <CAE5mzvhig1Y8=C2A9RP_SrCok_fqReOdPzQaZ_-iRBSbRUkZ9Q@mail.gmail.com>
Subject: Re: Drive low space / huge performance hit.
From: cwillu <cwillu@cwillu.com>
To: Steve Heyns <notzippy@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 7, 2013 at 11:05 AM, Steve Heyns <notzippy@gmail.com> wrote:
> hi
>
> I am using compression lzo on my 350GB partition, I have 2 subvolumes
> on this partition. My kernel is 3.7 BTRFS v0.19 -
>
> According to my system (df -h) that partition has 75Gb available.
> According to btrfs
>
> btrfs fi df /mnt/DevSystem/
> Data: total=260.01GB, used=259.09GB
> System, DUP: total=8.00MB, used=36.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=8.00GB, used=7.87GB
> Metadata: total=8.00MB, used=0.00

Show btrfs fi show /dev/whatever
