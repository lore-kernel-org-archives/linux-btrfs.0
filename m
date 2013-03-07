Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:32802 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365Ab3CGVMf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Mar 2013 16:12:35 -0500
Received: by mail-oa0-f49.google.com with SMTP id j6so1204670oag.36
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Mar 2013 13:12:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAE5mzvhig1Y8=C2A9RP_SrCok_fqReOdPzQaZ_-iRBSbRUkZ9Q@mail.gmail.com>
References: <CANDob0JBA8P1jVtB7zd=qfHVcBZMrC7pusNcSr3+OtKQv5=49g@mail.gmail.com>
 <CAE5mzvhig1Y8=C2A9RP_SrCok_fqReOdPzQaZ_-iRBSbRUkZ9Q@mail.gmail.com>
From: Steve Heyns <notzippy@gmail.com>
Date: Thu, 7 Mar 2013 13:12:15 -0800
Message-ID: <CANDob0L4Yh6eLdN9038NFsQ3xEiS7kR1utNX+vjBiJc1gyKOdg@mail.gmail.com>
Subject: Re: Drive low space / huge performance hit.
To: cwillu <cwillu@cwillu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 # btrfs fi show /dev/sda1

Label: 'DevSystem_Backup'  uuid: e781af8b-bc92-4fc3-aeb9-b21712bcadf9
        Total devices 1 FS bytes used 134.48GB
        devid    1 size 350.00GB used 276.04GB path /dev/sda1

thanks


On Thu, Mar 7, 2013 at 12:50 PM, cwillu <cwillu@cwillu.com> wrote:
> btrfs fi show /dev/
