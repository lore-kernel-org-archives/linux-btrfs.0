Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:49145 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751290AbdHDJsg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Aug 2017 05:48:36 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1ddZDW-00018H-3u
        for linux-btrfs@vger.kernel.org; Fri, 04 Aug 2017 11:48:26 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
Date: Fri, 4 Aug 2017 09:48:16 +0000 (UTC)
Message-ID: <pan$22bfb$91592610$a75d335a$88c75043@cox.net>
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
        <fb2cf0a6-12b2-9356-657a-ffd58b375c75@dirtcellar.net>
        <b5feb803-c57c-b910-7775-30eaed7b681e@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Thu, 03 Aug 2017 15:03:53 -0400 as
excerpted:

>> Same thing with the trim feature that is marked OK . It clearly says
>> that is has performance implications. It is marked OK so one would
>> expect it to not cause the filesystem to fail, but if the performance
>> becomes so slow that the filesystem gets practically unusable it is of
>> course not "OK". The relevant information is missing for people to make
>> a decent choice and I certainly don't know how serious these
>> performance implications are, if they are at all relevant...
> The performance implications bit shouldn't be listed, that's a given for
> any filesystem with discard (TRIM is the ATA and eMMC command, UNMAP is
> the SCSI one, and ERASE is the name on SD cards, discard is the generic
> kernel term) support.  The issue arises from devices that don't have
> support for queuing such commands, which is quite rare for SSD's these
> days.

Not so entirely rare.  The generally well regarded Samsung EVO/Pro 850 
ssd series don't support queued-trim, and indeed, due to a fiasco where 
new firmware lied about such support[1], the kernel now blacklists queued-
trim on all samsung ssds.

(I actually bought a pair of samsung evo 1TB ssds after seeing them well 
recommended both on this list and in various reviews.  Only AFTER I had 
them and was wondering if I could now add discard to my btrfs mount 
options and therefore googling for samsung evo queued trim specifically, 
did I find out about this fiasco and samsung not supporting linux because 
anyone can write the code, or I'd have certainly reconsidered and would 
have very likely spent my money elsewhere.  I did actually check the 
current kernel's blacklisting code and verified it, tho I also noted it 
whitelists samsung ssds for actually honoring flush directives where the 
code treats non-whitelisted ssds as not honoring them due apparently to 
too many claiming to do so while not actually doing so, to get better 
performance, so it's a mixed bag, one whitelisting for actually flushing 
when it claims to, one blacklisting for not reliably handling queued-trim 
despite some firmware claiming to do so.  But the worst IMO is samsung 
support blackballing linux because anyone can write the code. =:^  That's 
worth blackballing samsung for, in my book; I just wish I'd found out 
before the purchase instead of after, tho the linux devs have at least 
made sure samsung ssd users don't lose data on linux due to samsung's 
lies, despite samsung's horrible support policy blackballing linux, at 
least at the time.)

---
[1] The firmware said it supported a new ata standard where it's 
apparently mandatory, but the result was repeatedly corrupted data, with 
samsung support repeatedly said they don't support Linux because anyone 
can write code to execute, but they weren't seeing the problem on MS yet 
simply because MS hadn't issued a release that supported the new 
standard, and had queued-trim disabled by default with the older 
standards due to such problems when it was enabled.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

