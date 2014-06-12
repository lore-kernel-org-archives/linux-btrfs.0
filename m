Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay02.libero.it ([212.52.84.102]:32824 "EHLO
	outrelay02.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709AbaFLLHz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 07:07:55 -0400
Message-ID: <1462654576.2724341402571271931.JavaMail.defaultUser@defaultHost>
Date: Thu, 12 Jun 2014 13:07:51 +0200 (CEST)
From: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
Reply-To: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
To: <russell@coker.com.au>
Subject: R: Re: Slow startup of systemd-journal on BTRFS
Cc: systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>----Messaggio originale----
>Da: russell@coker.com.au
>Data: 12/06/2014 3.18
>A: <kreijack@inwind.it>
>Cc: "systemd Mailing List"<systemd-devel@lists.freedesktop.org>, "linux-btrfs"
<linux-btrfs@vger.kernel.org>
>Ogg: Re: Slow startup of systemd-journal on BTRFS
>
>On Wed, 11 Jun 2014 23:28:54 Goffredo Baroncelli wrote:
>>         https://bugzilla.redhat.com/show_bug.cgi?id=1006386
>> 
>> suggested me that the problem could be due to a bad interaction between
>> systemd and btrfs. NetworkManager was innocent.  It seems that
>> systemd-journal create a very hight fragmented files when it stores its
>> log. And BTRFS it is know to behave slowly when a file is highly
>> fragmented. This had caused a slow startup of systemd-journal, which in
>> turn had blocked the services which depend by the loggin system.
>
>On my BTRFS/systemd systems I edit /etc/systemd/journald.conf and put 
>"SystemMaxUse=50M".  That doesn't solve the fragmentation problem but 
reduces 
>it enough that it doesn't bother me.

IIRC my log files are about 80/100MB. So I am not sure if this could help.
I want to investigate also the option

    MaxFileSec=1d

which rotates the log file once a day (or a week)

>
>-- 
>My Main Blog         http://etbe.coker.com.au/
>My Documents Blog    http://doc.coker.com.au/
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


