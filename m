Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:41646 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214Ab2FMQUK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 12:20:10 -0400
Message-ID: <4FD8BDBB.8080709@libero.it>
Date: Wed, 13 Jun 2012 18:20:11 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Arne Jansen <sensille@gmx.net>
CC: C Anthony Risinger <anthony@xtfx.me>, Matthew Hawn <steamraven@yahoo.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Moving top level to a subvolume
References: <1339183466.55421.YahooMailNeo@web160803.mail.bf1.yahoo.com> <4FD2552D.20003@gmx.net> <CAGAVQTGctBTEKTCvhNbAsw7zMg5NfBm8n=Kf=wULKRNm5LQSjQ@mail.gmail.com> <4FD83F75.5000600@gmx.net>
In-Reply-To: <4FD83F75.5000600@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/13/2012 09:21 AM, Arne Jansen wrote:
> On 13.06.2012 09:04, C Anthony Risinger wrote:
>> On Fri, Jun 8, 2012 at 2:40 PM, Arne Jansen <sensille@gmx.net> wrote:
>>> On 06/08/2012 09:24 PM, Matthew Hawn wrote:
>>>> I just converted my root filesystem to btrfs with btrfs-convert.  However, since I am running Ubuntu, I would like to have the same subvolume structure as a default install,. How do I move the top-level subvolume (where all my files currently are) to another subvolume?
>>>
>>> Just snapshot the root subvol and continue working in the snapshot.
>>
>> ... yeah but that solution totally sucks when you:
>>
>> a) have a lot of data
>> b) need to do this via script
>> c) ???
>>
>> ... because in a), data will *copied* the slow way, and in b) you
>> leave a bunch of junk laying around in the old root that will rot
>> unless you `rm -rf` it ... and idk about you, but issuing what is very
>> near to that command on someone else's machine -- via script -- makes
>> me REALLY uneasy ;-)
> 
> well, don't put data in the top level in the first place. Yes, you have
> to remove the content of the subvol / by rm -rf, but I don't really see
> the problem with it.

It is slow. You have to change a lot of metadata (each shared metadata
block have to be unshared, and then one copy will be deleted ).

> What I don't understand is why you think data will be copied.
> 
>>
>> i have asked this exact question at least 4 times specifically, and
>> referenced it probably 8-10, in the last 3 years or more.  i needed it
>> then.  i still need it now.  but since i never got an answer up/down
>> or around, i gave up and told people to `rm -rf`themselves ...
>>
>> http://markmail.org/message/7hj5ioqrztkeerqv
>>
>> ... that's from May of 2010, but i don't think it's the first.
>>
>> so, would it possible to implement this, or could someone kindly (and
>> briefly!) explain why it cannot be done?
> 
> The default subvol ('/') has the special number 5 and is expected to
> always be around. All other subvols get numbers starting with 256.
> Creating a new 5 and internally renumbering the old 5 isn't easy, because
> each tree block has an owner recorded in it. Also, all backreferences
> have the root number in them. If you have to touch each tree block, you
> can as well choose the snapshot/rm -rf approach.

I don't know very well the internal of btrfs. Do you think that It is
possible to move/swap the root subvolume ?

> 
>>
[...]

> Or you could hack mkfs.btrfs to always create an additional subvol.

Which can be the default one: so nobody should complain. I



> Even making / readonly except for creating mountpoint could be possible.
> Just some random ideas...
> 
> -Arne
> 
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

