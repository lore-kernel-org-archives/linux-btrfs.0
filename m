Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:45789 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121AbaHVNNq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 09:13:46 -0400
Received: by mail-we0-f182.google.com with SMTP id k48so10713347wev.27
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Aug 2014 06:13:44 -0700 (PDT)
Message-ID: <53F74204.6040408@gmail.com>
Date: Fri, 22 Aug 2014 16:13:40 +0300
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: fdmanana@gmail.com, Duncan <1i5t5.duncan@cox.net>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Marc MERLIN <marc@merlins.org>,
        samjnaa@gmail.com
Subject: Re: Significance of high number of mails on this list?
References: <CAH-HCWVZPNkc7ycsL4jH0i6niVU3nqZiB2MLD6CfP85FckAg7g@mail.gmail.com>	<2217061.yFV10mnZWq@merkaba>	<CAH-HCWVxOA+NBD5ON_D2Np2mC6+PC=n5QCCc410pQC04X7VnxA@mail.gmail.com>	<53F6E9B7.1040701@gmail.com>	<pan$258d1$c3749601$d83e6a85$e56acf7f@cox.net> <CAL3q7H6PrjdSA-qjEsiX6vEMQbeYukn2R4vh=f4mteQNv0Y_qg@mail.gmail.com>
In-Reply-To: <CAL3q7H6PrjdSA-qjEsiX6vEMQbeYukn2R4vh=f4mteQNv0Y_qg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 22/8/2014 12:58 μμ, Filipe David Manana wrote:
> On Fri, Aug 22, 2014 at 8:35 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>> Konstantinos Skarlatos posted on Fri, 22 Aug 2014 09:56:55 +0300 as
>> excerpted:
>>
>>> I would stay with rsync for a while, because there is always the
>>> possibility of a bug that corrupts both your primary filesystem and your
>>> backup one, or send propagating corruption from one filesystem to
>>> another (Or maybe I am too paranoid, it would be good if we could have
>>> the opinion of a btrfs developer on this)
>> No claim to be a dev, btrfs or otherwise, here, but I believe in this
>> case you /are/ "being too paranoid."
>>
>> Both btrfs send and receive only deal with data/metadata they know how to
>> deal with.  If it's corrupt in some way or if they don't understand it,
>> they don't send/write it, they fail.
> Most of the time yes, however we have at least 1 know bug that affects
> 3.14.x only where send silently corrupts file data (replaces valid
> data with zeroes) at the destination:
>
> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=766b5e5ae78dd04a93a275690a49e23d7dcb1f39
>
> The fix landed in 3.15, but wasn't backported to 3.14.x yet (adding
> Chris to cc).

I didnt know about this one, but bugs like this are exactly the reason 
somebody should be "paranoid" and not rush to use new features, 
especially when they concern their only backup to an experimental 
filesystem.


>
>> IOW, if it works without error it's as guaranteed to be golden as these
>> things get.  The problem is that it doesn't always work without error in
>> the first place, sometimes it /does/ fail.  In that instance you can
>> always try again as the existing data/metadata shouldn't be damaged, but
>> if it keeps failing you may have to try something else, rsync, etc.
>>
>> --
>> Duncan - List replies preferred.   No HTML msgs.
>> "Every nonfree program has a lord, a master --
>> and if you use the program, he is your master."  Richard Stallman
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


-- 
Konstantinos Skarlatos

