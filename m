Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:33056 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbcDHXBu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Apr 2016 19:01:50 -0400
Received: by mail-io0-f178.google.com with SMTP id o126so126463603iod.0
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Apr 2016 16:01:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRms_q+d_O-5NQymJRU9da5VVbHAVrdKA7fm7Aez1pLEQ@mail.gmail.com>
References: <CAFKQ2BsxWYejWOPMCw5JuF-SXM03-papUu6LXM5KBNKthxAPxg@mail.gmail.com>
	<CAJCQCtQCLWca9YycOSTC8Q4c78a8AVe7uFXAoe2vqEUQVFHiNA@mail.gmail.com>
	<57064231.2070201@gmail.com>
	<CAJCQCtSAaTYYMJhTTAsEXXDUzUdLEpJARHPRfihDNZrvZtEo4Q@mail.gmail.com>
	<5707961D.6000803@gmail.com>
	<CAJCQCtQwNDoB75XYdsdcvedbnc1ox3YOi8aaiw0DZ=1Q=21WBw@mail.gmail.com>
	<5707F602.9020504@gmail.com>
	<CAJCQCtSBX1Uk2Ojx0=tePGGO9tdS+6691cM9Gy=K7RK7HAZVoQ@mail.gmail.com>
	<5708060A.8040105@gmail.com>
	<CAJCQCtRms_q+d_O-5NQymJRU9da5VVbHAVrdKA7fm7Aez1pLEQ@mail.gmail.com>
Date: Fri, 8 Apr 2016 17:01:49 -0600
Message-ID: <CAJCQCtRCpWYNohiMBW8GC8UC-xbLbyyU-Xsj8Wd2t9TSj755RQ@mail.gmail.com>
Subject: Re: unable to mount btrfs pool even with -oro,recovery,degraded,
 unable to do 'btrfs restore'
From: Chris Murphy <lists@colorremedies.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For raid5 it's different. No single chunks are created while copying
files to a degraded volume.

And the scrub produces very noisy kernel messages. Looks like there's
a message for each missing block (or stripe?), thousands per file. And
also many uncorrectable errors like this:

[267466.792060] f23s.localdomain kernel: BTRFS error (device dm-8):
unable to fixup (regular) error at logical 3760582656 on dev /dev/dm-7
[267467.508588] f23s.localdomain kernel: scrub_handle_errored_block:
401 callbacks suppressed

[root@f23s ~]# btrfs scrub start /mnt/1/
ERROR: there are uncorrectable errors

[root@f23s ~]# btrfs scrub status /mnt/1/
scrub status for 51e1efb0-7df3-44d5-8716-9ed4bdadc93e
    scrub started at Fri Apr  8 14:35:25 2016 and finished after 00:11:26
    total bytes scrubbed: 3.21GiB with 45186 errors
    error details: read=95 super=2 verify=8 csum=45081
    corrected errors: 44935, uncorrectable errors: 249, unverified errors: 0

Subsequent balance and scrub have no messages at all. So...
uncorrectable? Really? That's confusing.

FYI, for a scrub with no errors it's 4m24s, but with the same data and
1/2 of it needing to be rebuilt during the scrub took 16m4s, so about
4x longer to reconstruct. Seems excessive.

Chris Murphy
