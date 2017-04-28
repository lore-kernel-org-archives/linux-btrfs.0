Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:53226 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1950717AbdD1Tj3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Apr 2017 15:39:29 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:59450)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1d4Bji-001AVL-Km
        for linux-btrfs@vger.kernel.org; Fri, 28 Apr 2017 20:39:26 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1d4Bje-0004ra-Ia
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Apr 2017 20:39:22 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22787.39530.223012.644477@tree.ty.sabi.co.uk>
Date: Fri, 28 Apr 2017 20:39:22 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs, journald logs, fragmentation, and fallocate
In-Reply-To: <2bfe32ee-4db6-f3ca-ce87-ec72ce300bd0@inwind.it>
References: <CAJCQCtQk1p6rzUYaO19ei51YC+w1uj1qJ77OdLmL5JN3w1zNfw@mail.gmail.com>
        <5fd31e68-0199-8935-0873-78b4e7c6eb69@inwind.it>
        <CAJCQCtQCV2DmpsEFtRVdJDMkT54bzbU66+5W873mpJAyXf5k9A@mail.gmail.com>
        <2bfe32ee-4db6-f3ca-ce87-ec72ce300bd0@inwind.it>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> The gotcha though is there's a pile of data in the journal
>> that would never make it to rsyslogd. If you use journalctl
>> -o verbose you can see some of this.

> You can send *all the info* to rsyslogd via imjournal
> http://www.rsyslog.com/doc/v8-stable/configuration/modules/imjournal.html
> In my setup all the data are stored in json format in the
> /var/log/cee.log file:
> $ head /var/log/cee.log 2017-04-28T18:41:41.931273+02:00
> venice liblogging-stdlog: @cee: { "PRIORITY": "6", "_BOOT_ID":
> "a86d74bab91f44dc974c76aceb97141f", "_MACHINE_ID": [ ... ]

Ahhhhhh the horror the horror, I will never be able to unsee
that. The UNIX way of doing things is truly dead.

>> The same behavior happens with NTFS in qcow2 files. They
>> quickly end up with 100,000+ extents unless set nocow.
>> It's like the worst case scenario.

In a particularly demented setup I had to decastrophize with
great pain a Zimbra QCOW2 disk image (XFS on NFS on XFS on
RAID6) containining an ever growing number Maildir email archive
ended up with over a million widely scattered microextents:

  http://www.sabi.co.uk/blog/1101Jan.html?110116#110116
