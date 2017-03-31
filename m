Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp153.dfw.emailsrvr.com ([67.192.241.153]:54710 "EHLO
        smtp153.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933165AbdCaM2Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 08:28:25 -0400
Received: from smtp32.relay.dfw1a.emailsrvr.com (localhost [127.0.0.1])
        by smtp32.relay.dfw1a.emailsrvr.com (SMTP Server) with ESMTP id 0246FA0172
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Mar 2017 08:28:24 -0400 (EDT)
Received: by smtp32.relay.dfw1a.emailsrvr.com (Authenticated sender: m.khalili-AT-rqc.ru) with ESMTPSA id 56B11A0129
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Mar 2017 08:28:23 -0400 (EDT)
Subject: Re: Do different btrfs volumes compete for CPU?
To: linux-btrfs@vger.kernel.org
References: <43a14754-1047-552e-78a9-6503dfc0d121@rqc.ru>
 <pan$8edd9$3260f40b$e8e8873f$59ccb7af@cox.net>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <ef8ec943-6d26-d7e9-d4ac-05e2ce7a8532@rqc.ru>
Date: Fri, 31 Mar 2017 15:28:20 +0300
MIME-Version: 1.0
In-Reply-To: <pan$8edd9$3260f40b$e8e8873f$59ccb7af@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you very much for reply and suggestions, more comments below. 
Still, is there a definite answer on root question: are different btrfs 
volumes independent in terms of CPU, or are there some shared workers 
that can be point of contention?

> What would have been interesting would have been if you had any reports
> from for instance htop during that time, showing wait percentage on the
> various cores and status (probably D, disk-wait) of the innocent
> process.  iotop output would of course have been even better, but also
> rather more special-case so less commonly installed.
Curiously, I have had iotop but not htop running. [btrfs-transacti] had 
some low-level activity in iotop (I still assume it was CPU-limited), 
the innocent process did not have any activity anywhere. Next time I'll 
also take notice of process state in ps (sadly, my omission).

> I believe you will find that the problem isn't btrfs, but rather, I/O
> contention
This possibility did not come to my mind. Can USB drivers be still that 
bad in 4.4? Is there any way to discriminate these two situations (btrfs 
vs usb load)?

BTW, USB adapter used is this one (though storage array only supports 
USB 3.0): https://www.asus.com/Motherboard-Accessory/USB_31_TYPEA_CARD/

> and that if you try the same thing with one of the
> filesystems being for instance ext4, you'll see the same problem there as
> well
Not sure if it's possible to reproduce the problem with ext4, since it's 
not possible to perform such extensive metadata operations there, and 
simply moving large amount of data never created any problems for me 
regardless of filesystem.

--

With Best Regards,
Marat Khalili

