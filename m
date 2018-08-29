Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:59223 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1727198AbeH2N5d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Aug 2018 09:57:33 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fuxFl-0001Tp-EX
        for linux-btrfs@vger.kernel.org; Wed, 29 Aug 2018 11:59:09 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: DRDY errors are not consistent with scrub results
Date: Wed, 29 Aug 2018 09:58:58 +0000 (UTC)
Message-ID: <pan$a7e58$50ac50ff$7213aaae$e428330b@cox.net>
References: <CAN4oSBdfDVGmG8L2vS9h9McEs5aSuP5RfTGREB2ZhGwmAg4JhA@mail.gmail.com>
        <CAJCQCtSq5K90gpfGQN8JhqQddBg62m8EG_bFuWN5XyzdNStDfw@mail.gmail.com>
        <CAN4oSBeHwnsm5Ecz1hAQLk6s6utHfn5XeR8xMhnZpmT-sb-_iw@mail.gmail.com>
        <CAJCQCtQ=CiB5cY8RL4tzps21d=umjzNM=BKjdUBCc7WiP0QF9A@mail.gmail.com>
        <CAJCQCtSGV1gz66X9BJAJosuhMTvd2=Me-X2tVDwJ0Eg9PA7BPA@mail.gmail.com>
        <CAN4oSBfAS75x7+D2Ms93NGB5H5MG-AOR5mHg2czGCECg6api3Q@mail.gmail.com>
        <CAJCQCtT3PrcFwFq3oAyPyQTNBRdSjevFEE7V5_AoKD6hEDgvyA@mail.gmail.com>
        <CAN4oSBdLEXS8DzZ+8Y-z5BxSe_7EUsA4ZEp4OAhWOhhZMwkM=w@mail.gmail.com>
        <CAJCQCtRPxtqqfCE_fRwzbfFAFMHCdO34T+riXQfd6-=BJX37SQ@mail.gmail.com>
        <CAN4oSBezSLqwLaYu-OPrgomcK-RnaJhkukMoun=8JKQbMfqSWA@mail.gmail.com>
        <CAJCQCtTZap+DRVe9yj-GjvJsvL=A+SoTzdTY=u2KjUV5WQhMsw@mail.gmail.com>
        <CAN4oSBdvw2BnL7NJeFNmWbnQfhiZzGM=bi4kPVLb3G1BykBL=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cerem Cem ASLAN posted on Wed, 29 Aug 2018 09:58:21 +0300 as excerpted:

> Thinking again, this is totally acceptable. If the requirement was a
> good health disk, then I think I must check the disk health by myself.
> I may believe that the disk is in a good state, or make a quick test or
> make some very detailed tests to be sure.

For testing you might try badblocks.  It's most useful on a device that 
doesn't have a filesystem on it you're trying to save, so you can use the 
-w write-test option.  See the manpage for details.

The -w option should force the device to remap bad blocks where it can as 
well, and you can take your previous smartctl read and compare it to a 
new one after the test.

Hint if testing multiple spinning-rust devices:  Try running multiple 
tests at once.  While this might have been slower on old EIDE, at least 
with spinning rust, on SATA and similar you should be able to test 
multiple devices at once without them slowing down significantly, because 
the bottleneck is the spinning rust, not the bus, controller or CPU.  I 
used badblocks years ago to test my new disks before setting up mdraid on 
them, and with full disk tests on spinning rust taking (at the time) 
nearly a day a pass and four passes for the -w test, the multiple tests 
at once trick saved me quite a bit of time!

It's not a great idea to do the test on new SSDs as it's unnecessary 
wear, writing the entire device four times with different patterns each 
time for a -w, but it might be worthwhile to try it on an ssd you're just 
trying to salvage, forcing it to swap out any bad sectors it encounters 
in the process.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
