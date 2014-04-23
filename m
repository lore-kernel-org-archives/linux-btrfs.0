Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:34450 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaDWPCZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 11:02:25 -0400
Received: by mail-ee0-f51.google.com with SMTP id c13so880561eek.24
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Apr 2014 08:02:24 -0700 (PDT)
Received: from [192.168.1.229] (188-194-184-29-dynip.superkabel.de. [188.194.184.29])
        by mx.google.com with ESMTPSA id x45sm7002330eef.15.2014.04.23.08.02.22
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Apr 2014 08:02:23 -0700 (PDT)
Message-ID: <5357D5FC.2010301@gmail.com>
Date: Wed, 23 Apr 2014 17:02:20 +0200
From: Andreas Reis <andreas.reis@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Bug: "corrupt leaf. slot offset bad": root subvolume unmountable,
 "btrfs check" crashes
References: <53554469.5070503@gmail.com> <53556DCC.3000108@gmail.com> <5356B1ED.8060608@gmail.com>
In-Reply-To: <5356B1ED.8060608@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ah. Thank you for the replies. I didn't get them as mails and spinics 
didn't update the thread until yesterday.

So I take it that the recommended course of action is not to wait for 
any more or less unlikely btrfs-progs fix, but to try --repair and be 
ready to restore from backup, too. Darn, and that over what probably 
doesn't amount to more than a few dozen KB. Wish I could simply replace 
the single subvolume instead, but I suppose that's one of btrfs's drawbacks.

I did a full partition backup some three weeks ago, so I'll have to 
spend some hours to figure out what has changed since then, and how to 
do incremental backups of it to different devices for the next time…

I don't have the time atm though; it'll probably take at least a week 
(unless the partition decides to die) to report back.

As a side note, there was an ostensibly similar issue fixed in 2012: 
https://bugzilla.novell.com/show_bug.cgi?id=760279 Guess that was a 
different underlying issue, though.

Duncan posted on Wed, 23 Apr 2014 02:55:36 +0000:

 > Andreas Reis posted on Tue, 22 Apr 2014 20:16:13 +0200 as excerpted:
 >
 > > Same failure with btrfs-progs from integration-20140421 (apart from
 > > the line number 1156).
 > >
 > > Can I get a bit of input on this? Is it safe to just ignore the
 > > error for now (as I'm doing atm), ie. remount as rw to skip the
 > > orphan cleanup?
 >
 > I explained orphans in my other reply.  Since they're simply not yet
 > completed file deletions, it should be /relatively/ safe to continue
 > ignoring and doing the manual remount rw, since that continues to
 > kwork.
