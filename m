Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:33607 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756950AbcIVR3X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 13:29:23 -0400
Received: by mail-oi0-f54.google.com with SMTP id r126so105821398oib.0
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Sep 2016 10:29:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGfcS_kOo49_5OxF0-TodBZjjkKeGsPiYHJFeSa6x=OtB0LfOg@mail.gmail.com>
References: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>
 <CAGfcS_kOo49_5OxF0-TodBZjjkKeGsPiYHJFeSa6x=OtB0LfOg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 22 Sep 2016 11:29:22 -0600
Message-ID: <CAJCQCtQkHgPUiei9xZScQXgkdspBZW9oPph2PC8vd7C6xAuWhw@mail.gmail.com>
Subject: Re: unable to handle kernel paging request - btrfs
To: Rich Freeman <r-btrfs@gw.thefreemanclan.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 22, 2016 at 10:46 AM, Rich Freeman
<r-btrfs@thefreemanclan.net> wrote:
> On Sep 22, 2016 8:18 AM, "Rich Freeman" <r-btrfs@thefreemanclan.net> wrote:
>>
>> I have been getting panics consistently after doing a btrfs replace
>> operation on a raid1 and rebooting.  I linked a photo of the panic; I
>> haven't been able to get a text capture of it.
>>
>> https://ibin.co/2vx0HhDeViu3.jpg
>>
>> I'm getting this error on the latest 4.4, 4.1, and even on an old
>> 3.18.26 kernel I had lying around.
>
>
> Apologies for replying out of order, but I lost the reply (the
> downside to running btrfs on my mail server).
>
> I was also suspicious of memory but memtestx86 hasn't found anything
> in (though I haven't run it longer than 10min).

It can take hours or days. Only the most obvious memory problems are
found in minutes with memtest86+. And it's possible it won't find the
more rare problems.

I mentioned this in a related thread:

As for hardware induced corruptions there are lots of threads in the
archive, quick search:

http://www.spinics.net/lists/linux-btrfs/msg56954.html
http://www.spinics.net/lists/linux-btrfs/msg57008.html




Sysrescuecd is my
> normal rescue image and I haven't gotten that to panic, but I haven't
> tried to start any services from it. Unfortunately it is openrc based
> so getting systemd running on my btrfs image inside a container will
> be painful. Maybe I can find a systemd based rescue image that
> includes nspawn.

This ISO can be dd'd to a USB stick and will boot almost anything,
BIOS or UEFI, even a Mac.
https://kojipkgs.fedoraproject.org/compose/rawhide/Fedora-Rawhide-20160921.n.0/compose/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-Rawhide-20160921.n.0.iso


You could of course use an actual release version of Fedora, I just
happen to have the URL handy and have tested that ISO. It has kernel
4.8rc7 and btrfs-progs 4.7.2. It is a "live" cd. You might prefer to
add 3 to boot parameters to not get a graphical boot. Login is either
root or liveuser, no password. Change the password for either one,
then 'systemctl start sshd' and 'ip a' to get an IP to login to
remotely.


>
> I suspect I'll have the same issue though as several kernels have failed.
>
> I'll do more extensive RAM tests just in case.  However, the
> consistency of the error messages suggests a bug to me.

Or binary file corruption.

-- 
Chris Murphy
