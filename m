Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:35226 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750899AbcIAX7d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Sep 2016 19:59:33 -0400
Received: by mail-oi0-f43.google.com with SMTP id p186so104903365oia.2
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Sep 2016 16:59:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <SY3PR01MB1386E1F96B74EFB2A61007AC9EE20@SY3PR01MB1386.ausprd01.prod.outlook.com>
References: <CAJCQCtT5YA9EMq1ZC-qeZcNLUeg1GocBm3nT2nZFEBigmV4BxQ@mail.gmail.com>
 <CAJCQCtQjX+0nAWRNPK2gYNoi8wvHxTMEzm6v84PZKXnTLxc50Q@mail.gmail.com>
 <CAJCQCtT0=gEwBerYXYnyueMk3JnmGZp71qBJFB5N4qR4ASF7cg@mail.gmail.com>
 <CAJCQCtRZNNTZ5ymH-X9Cq=h+_aaATym40W42BJ-xM5ECJOQnDg@mail.gmail.com>
 <CAJCQCtTo7nS7grh-9XWTKXX_h2pXPXCbLMRGmTfa=NzHq2Aa6g@mail.gmail.com>
 <CAJCQCtS374FCEqSx0qBdF1oa6=y48A4p0pMN0u456adQETyS_Q@mail.gmail.com>
 <SY3PR01MB13864A03DC2503EF7E0381A49EE20@SY3PR01MB1386.ausprd01.prod.outlook.com>
 <CAJCQCtTMrA=CutAMjXy+_CPqLGyfwCfYnpug1rAJuLQWv2rKDA@mail.gmail.com> <SY3PR01MB1386E1F96B74EFB2A61007AC9EE20@SY3PR01MB1386.ausprd01.prod.outlook.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 1 Sep 2016 17:59:31 -0600
Message-ID: <CAJCQCtRVwecxS7r7tK0Um5x4DGjRtjWA-eX5u9MC00OTdatD1g@mail.gmail.com>
Subject: Re: btrfs-progs 4.7, check reports many "incorrect local backref
 count" messages
To: Paul Jones <paul@pauljones.id.au>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 1, 2016 at 5:51 PM, Paul Jones <paul@pauljones.id.au> wrote:
>> -----Original Message-----
>> From: chris@colorremedies.com [mailto:chris@colorremedies.com] On
>>
>> On Thu, Sep 1, 2016 at 12:51 AM, Paul Jones <paul@pauljones.id.au> wrote:
>> >> -----Original Message-----
>> >> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
>> >> owner@vger.kernel.org] On Behalf Of Chris Murphy
>> >> Sent: Thursday, 1 September 2016 7:59 AM
>> >> To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
>> >> Subject: Re: btrfs-progs 4.7, check reports many "incorrect local
>> >> backref count" messages
>> >>
>> >> This is still happening with btrfs-progs 4.7.1 and there is zero
>> >> information in the long result what to do about the problem, and
>> >> whether it's sane to try have --repair fix it, let alone what the original
>> cause of the problem was.
>> >
>> > I just potentially damaged a perfectly good filesystem because of this. I was
>> getting hundreds of "Incorrect local backref count" so I decided to try repair,
>> which seemed to complete ok. I then rescanned without repair and btrfs
>> check eventually crashed with an assertion. That's when I figured something
>> may be wrong.
>>
>> Wait, so you did a --repair and then the following-up check crashes?
>> But does the file system mount and does it still work? The first is bad enough,
>> but if it won't mount this is terrible.
>
> Correct. I forgot to mention the crash was with btrfs-progs 4.7.1 and kernel 4.7.2. After that I reverted to btrfs-progs 4.6.1 and kernel 4.6.7
> The filesystem still mounted, so I tried to run scrub but that got stuck at 0 bytes (with no errors). I reset the system (reboot didn't finish) and run repair a few more times, and even though there were still errors every time I noticed the last few errors appeared to be the same.
> I mounted and tried scrub again, which worked the second time. I let it run overnight and it didn't find any errors. I'm just about to rsync (with checksums) from the backup to verify the data is still good.
>
> I'd suggest btrfs-progs 4.7.x is withdrawn until this can be fixed.

Yeah upstream can't really do that, it's up to the distros. The main
thing though is that it didn't actually make the file system worse
off, it just sounds like it wasted some time on your end.

My complaint about this is I have no idea what the messages mean, how
big of a problem they are, whether they should be repaired, and what
to do about the fact they claim to be repaired but aren't.



-- 
Chris Murphy
