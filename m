Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:33795 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758220Ab3J2R1H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Oct 2013 13:27:07 -0400
Received: by mail-ie0-f172.google.com with SMTP id tp5so308661ieb.17
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Oct 2013 10:27:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOKNOqAv5yGNY3S77CO2w5Hk8wDZ2b9YTjSt_kc_-8TDkNnmKg@mail.gmail.com>
References: <CAOKNOqAv5yGNY3S77CO2w5Hk8wDZ2b9YTjSt_kc_-8TDkNnmKg@mail.gmail.com>
Date: Tue, 29 Oct 2013 17:27:05 +0000
Message-ID: <CAOKNOqAkvnfQ-VJMq5qhXP09jtJ8WDWX+KzhRDHufObrT-_pnA@mail.gmail.com>
Subject: Re: Moving over to use BTRFS - first time, needs encryption (btrfs:
 message 1 of 20)
From: Nigel Bray <nrbray@gmx.net>
To: btrfs.nrb@9ox.net
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Update:

I found this:
.. by upgrading kernel ...according to the BTRFS wiki, changing raid
levels after the filesystem has been created isn't supported for 3.2
series and older kernels.

Need to move from stable stock., >  Ubuntu 12.04LTS and Debian 7.2.

http://serverfault.com/questions/496503/converting-btrfs-filesystem-to-raid1-fails-with-inappropriate-ioctl-for-device
