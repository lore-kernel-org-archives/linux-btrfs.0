Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:34551 "EHLO
        mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750928AbdAFRn3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Jan 2017 12:43:29 -0500
Received: by mail-yw0-f176.google.com with SMTP id l145so11330177ywb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Jan 2017 09:43:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAK5rZE7J2Awyy6FCm2VyNjE22-ckTetsO+9bCP-4cSsiRjiaeg@mail.gmail.com>
References: <c0d145b6-6c81-ef52-4876-85eab927bae7@techsquare.com>
 <pan$bae57$81ae2edc$f6b8d81e$acf53525@cox.net> <CAK5rZE7J2Awyy6FCm2VyNjE22-ckTetsO+9bCP-4cSsiRjiaeg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 6 Jan 2017 10:43:28 -0700
Message-ID: <CAJCQCtTXvJ1wBMUdtmQiTGJu+ggvORqME67AFmQipq58NGhiGw@mail.gmail.com>
Subject: Re: kernel crash after upgrading to 4.9
To: Imran Geriskovan <imran.geriskovan@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 6, 2017 at 8:15 AM, Imran Geriskovan
<imran.geriskovan@gmail.com> wrote:
>>> I seem to have a similar issue to a subject in December:
>>> Subject: page allocation stall in kernel 4.9 when copying files from one
>>> btrfs hdd to another
>>> In my case, this is caused when rsync'ing large amounts of data over NFS
>>> to the server with the BTRFS file system.  This was not apparent in the
>>> previous kernel (4.7).
>
> As I browse through latest series of btrfs corruption/crash reports
> I wonder which kernel version is reasonably safest to use.
> 4.7, 4.8 or 4.9 series?
>
> What are your experiences and recommendations?

I'm using 4.8.15. With 4.9 and 4.10 I'm seeing a regression where a
volume goes read only for inexplicable reasons. Both btrfs check and
scrub show no problems.
http://www.spinics.net/lists/linux-btrfs/msg61817.html




-- 
Chris Murphy
