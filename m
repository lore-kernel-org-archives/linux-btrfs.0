Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:34218 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbcBMTXc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Feb 2016 14:23:32 -0500
Received: by mail-wm0-f51.google.com with SMTP id b205so21086681wmb.1
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Feb 2016 11:23:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160212203426.GA24399@localhost.localdomain>
References: <CAJCQCtS3MsrF43PnueK3-4kVLGfTNGjN4Tv-c=Jo1jVWYL7ksw@mail.gmail.com>
 <CABXGCsOAyYa96E965ruKp9evCY3FrCdBr-GTPvCws5VqmjUC5Q@mail.gmail.com>
 <CAJCQCtRjCixev=Mt=jaL1ZytYaxj7Fa-AViLYGB-ALufyL98VA@mail.gmail.com>
 <CAJCQCtRtVjyjvSfT=BCZZwfaSvbD4YVxEBezfAx+-q7cwMHmRQ@mail.gmail.com>
 <CABXGCsNivrLgTEE+HZOLHXA-kpLVQOUv9L_nTw96nvy+DHodZg@mail.gmail.com>
 <CAJCQCtTrcnwvumgt-bOx+9wX+f50S9ja5rDrnYAsuuN1aDTsZA@mail.gmail.com>
 <20160211191741.GA4762@localhost.localdomain> <CABXGCsPN3MOLkU68gpw=TsnZLODEkYZ66ZHgUxMyeqbdNME9Sw@mail.gmail.com>
 <20160212032226.GA10542@localhost.localdomain> <CABXGCsNjHq4M8TBibeWQLyK+Of0cu++P3QQ=+e=TUuZjaPMLtA@mail.gmail.com>
 <20160212203426.GA24399@localhost.localdomain>
From: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>
Date: Sun, 14 Feb 2016 00:23:16 +0500
Message-ID: <CABXGCsMMkcMmEH8=d3TqJksB8uc_OVrRqfjX7E1RO+4R94O=Ug@mail.gmail.com>
Subject: Re: task btrfs-cleaner:770 blocked for more than 120 seconds.
To: bo.li.liu@oracle.com
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, I have not yet had time to apply your patch.

And get hang again when launch web browser.

Here new logs: http://btrfs.sy24.ru/kernel-sysrqw-btrfscleaner770blocked-3.txt

Addition info: when btrfs partition hangs also hang GUI it is normal?
For grab logs I switch to tty3 (Ctrl - Alt - F3)



--
Best Regards,
Mike Gavrilov.


2016-02-13 1:34 GMT+05:00 Liu Bo <bo.li.liu@oracle.com>:
> On Sat, Feb 13, 2016 at 12:15:08AM +0500, Михаил Гаврилов wrote:
>> 2016-02-12 8:22 GMT+05:00 Liu Bo <bo.li.liu@oracle.com>:
>> > You can try it on your 4.2.3 kernel or the latest 4.5, but I guess it
>> > doesn't not fix the real deadlock you're hitting...
>>
>> It means it is not final patch? you continue investigate problem? Can
>> I help you?
>
> Yeah, it's not the final patch, you can apply it and see if the deadlock
> will happen again.
>
> Unless we can get a way to reproduce it, I'm afraid there's little things we can  do here.
>
> Thanks,
>
> -liubo
