Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:35412 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751579AbdGZMg7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Jul 2017 08:36:59 -0400
Received: by mail-it0-f48.google.com with SMTP id h199so66196416ith.0
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Jul 2017 05:36:58 -0700 (PDT)
Subject: Re: btrfs raid assurance
To: Hugo Mills <hugo@carfax.org.uk>, waxhead <waxhead@dirtcellar.net>,
        =?UTF-8?Q?H=c3=a9rikz_Nawarro?= <herikz.nawarro@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAD6NJSxuix4N=kPbQ_=QRnKP4Ny6kLyVyEA4p=PvBfgtbwrUHw@mail.gmail.com>
 <20170725134656.GL7140@carfax.org.uk> <20170725135146.GM7140@carfax.org.uk>
 <CAD6NJSz0qMYhiqmseOQtG-ytVTck1aZykVe+U1FtXQvTMThs4g@mail.gmail.com>
 <20170725135835.GN7140@carfax.org.uk>
 <d07af24a-1689-fce4-296a-af4f10f3058d@dirtcellar.net>
 <20170725214505.GP7140@carfax.org.uk>
 <3ae7c0e5-ce84-cbc7-9e68-9e4df9aa4f18@gmail.com>
 <20170726122720.GQ7140@carfax.org.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <c9ec498e-05b3-7120-8042-f423fca0de92@gmail.com>
Date: Wed, 26 Jul 2017 08:36:54 -0400
MIME-Version: 1.0
In-Reply-To: <20170726122720.GQ7140@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-07-26 08:27, Hugo Mills wrote:
> On Wed, Jul 26, 2017 at 08:12:19AM -0400, Austin S. Hemmelgarn wrote:
>> On 2017-07-25 17:45, Hugo Mills wrote:
>>> On Tue, Jul 25, 2017 at 11:29:13PM +0200, waxhead wrote:
>>>>
>>>>
>>>> Hugo Mills wrote:
>>>>>
>>>>>>>     You can see about the disk usage in different scenarios with the
>>>>>>> online tool at:
>>>>>>>
>>>>>>> http://carfax.org.uk/btrfs-usage/
>>>>>>>
>>>>>>>     Hugo.
>>>>>>>
>>>> As a side note, have you ever considered making this online tool
>>>> (that should never go away just for the record) part of btrfs-progs
>>>> e.g. a proper tool? I use it quite often (at least several timers
>>>> per. month) and I would love for this to be a visual tool
>>>> 'btrfs-space-calculator' would be a great name for it I think.
>>>>
>>>> Imagine how nice it would be to run....
>>>>
>>>> btrfs-space-calculator -mraid1 -draid10 /dev/sda1 /dev/sdb1
>>>> /dev/sdc2 /dev/sdd2 /dev/sde3 for example and instantly get
>>>> something similar to my example below (no accuracy intended)
>>>
>>>     It's certainly a thought. I've already got the algorithm written
>>> up. I'd have to resurrect my C skills, though, and it's a long way
>>> down my list of things to do. :/
>>>
>>>     Also on the subject of this tool, I'd like to make it so that the
>>> parameters get set in the URL, so that people can copy-paste the URL
>>> of the settings they've got into IRC for discussion. However, that
>>> would involve doing more JavaScript, which is possibly even lower down
>>> my list of things to do than starting doing C again...
> 
>> Is the core logic posted somewhere?  Because if I have some time, I
>> might write up a quick Python script to do this locally (it may not
>> be as tightly integrated with the regular tools, but I can count on
>> half a hand how many distros don't include Python by default).
> 
>     If it's going to be done in python, I might as well do it myself --
> I can do python with my eyes closed. It's just C and JS I'm rusty with.
Same here ironically :)
> 
>     There is a write-up of the usable-space algorithm somewhere. I
> wrote it up in detail (with pseudocode) in a mail on this list. I've
> also got several pages of LaTeX somewhere where I tried and failed to
> prove the correctness of the formula. I'll see if I can dig them out
> this evening.
It looks like the Message-ID for the one on the mailing list is 
<20160311221703.GJ17196@carfax.org.uk>
I had forgotten that I'd archived that with the intent of actually doing 
something with it eventually...
