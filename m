Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:51811 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935915Ab3DQRao (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Apr 2013 13:30:44 -0400
Received: by mail-ob0-f181.google.com with SMTP id wo10so1662944obc.26
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Apr 2013 10:30:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130417065506.GA21083@panda>
References: <CAG42UxdVpz7a0FPEc7Ajm+jHHrqG7zT2=JaPZcFzMQT18eqzww@mail.gmail.com>
 <20130417065506.GA21083@panda>
From: Matt Pursley <mpursley@gmail.com>
Date: Wed, 17 Apr 2013 10:30:02 -0700
Message-ID: <CAG42Uxcjk-T9e-9uO6L+dLzqo3N7c+RMvUyaS2WE_aFWK9niJA@mail.gmail.com>
Subject: Re: One random read streaming is fast (~1200MB/s), but two or more
 are slower (~750MB/s)?
To: sander@humilis.net
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 16, 2013 at 11:55 PM, Sander <sander@humilis.net> wrote:
> Matt Pursley wrote (ao):
>> I have an LSI HBA card (LSI SAS 9207-8i) with 12 7200rpm SAS drives
>> attached.  When it's formated with mdraid6+ext4 I get about 1200MB/s
>> for multiple streaming random reads with iozone.  With btrfs in
>> 3.9.0-rc4 I can also get about 1200MB/s, but only with one stream at a
>> time.
>
> Just curious, is that btrfs on top of mdraid6, or is this experimental
> btrfs raid6 without md?



This is the "experimental btrfs raid6 without md".

But, I did do a "mdraid6 with btrfs" test last night... and with that
setup I only get the ~750MB/s result.. even with just one
thread/stream...

I will flip the system back to "btrfsraid6+btrfs" today to verify that
I still get the full 1200MB/s with one stream/thread and ~750MB/s with
two or more streams/threads with that setup...


Thanks,
Matt



___
mdraid6+btrfs_64GBRam_80files # sysctl vm.drop_caches=1 ; dd
of=/dev/null if=/var/data/persist/testfile bs=640k
vm.drop_caches = 1
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 18.2109 s, 720 MB/s
___
