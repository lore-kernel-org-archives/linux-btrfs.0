Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:61607 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaHJIvD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Aug 2014 04:51:03 -0400
Received: by mail-we0-f181.google.com with SMTP id k48so7193628wev.26
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Aug 2014 01:51:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$d6d2e$b19333f0$ee4ea84e$5a707866@cox.net>
References: <CAETJ_S-BOjatUFPVPwKCmgMRfWG6K0WEJgE=F_Di2i=52fqGCQ@mail.gmail.com>
 <2242759.aOKEuU2TTR@xev> <20140809143206.GJ11855@bitfolk.com>
 <CAETJ_S8rf4Y_7x4+fDB19JfNZYa1wjQOwTHcdCxd9eHq17NgXg@mail.gmail.com>
 <CAETJ_S-VZk5pxgT4HCJnQwenL6eDP88z7tW-KEHYqtnn=NWbww@mail.gmail.com>
 <pan$29b1$ee1dac$e6091513$d07b2702@cox.net> <CAETJ_S8347mtU6-o9BW=_Q27atdcj6P-aFZ1551S6G6rXBS8=A@mail.gmail.com>
 <CAETJ_S9HsWEYrV2zrfr8ZSD69SoFCiHnND38HLo8pq7ENiEPbw@mail.gmail.com>
 <CAETJ_S8DT=yW6V8bmAJ5s-+ZbuLjnDUK_XWEFRwK_p8hoR+LWA@mail.gmail.com> <pan$d6d2e$b19333f0$ee4ea84e$5a707866@cox.net>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Sun, 10 Aug 2014 11:50:39 +0300
Message-ID: <CAGqmi75ne1BNzZdzU_RxOBEBaCgZsH0K1dLLUZ6y-YUn_byCbg@mail.gmail.com>
Subject: Re: 40TB volume taking over 16 hours to mount, any ideas?
To: ildefonso.camargo@gmail.com
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jose, I add my 50 cents,
i know, what you want backup data from raid through network and what
you have only 11 TB data from 40 TB fs
As i now, you can safety resize btrfs fs, without btrfs fi resize,
something like that:
$ btrfs fi df /
Data, single: total=81.00GiB, used=60.33GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=1.50GiB, used=507.48MiB
GlobalReserve, single: total=176.00MiB, used=0.00B

- I can cut partitions to 81+1.5+~256 = 83g and + 1G for safety = 84G.
And my data not lost and btrfs still working after this.
After, you can use free space on the disk, to create new fs and backup
data to him without problems,
Developers, please сorrect me if I'm wrong.


-- 
Best regards,
Timofey.
