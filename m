Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:39955 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751784Ab2FMHV3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 03:21:29 -0400
Message-ID: <4FD83F75.5000600@gmx.net>
Date: Wed, 13 Jun 2012 09:21:25 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: C Anthony Risinger <anthony@xtfx.me>
CC: Matthew Hawn <steamraven@yahoo.com>, linux-btrfs@vger.kernel.org
Subject: Re: Moving top level to a subvolume
References: <1339183466.55421.YahooMailNeo@web160803.mail.bf1.yahoo.com> <4FD2552D.20003@gmx.net> <CAGAVQTGctBTEKTCvhNbAsw7zMg5NfBm8n=Kf=wULKRNm5LQSjQ@mail.gmail.com>
In-Reply-To: <CAGAVQTGctBTEKTCvhNbAsw7zMg5NfBm8n=Kf=wULKRNm5LQSjQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 13.06.2012 09:04, C Anthony Risinger wrote:
> On Fri, Jun 8, 2012 at 2:40 PM, Arne Jansen <sensille@gmx.net> wrote:
>> On 06/08/2012 09:24 PM, Matthew Hawn wrote:
>>> I just converted my root filesystem to btrfs with btrfs-convert.  However, since I am running Ubuntu, I would like to have the same subvolume structure as a default install,. How do I move the top-level subvolume (where all my files currently are) to another subvolume?
>>
>> Just snapshot the root subvol and continue working in the snapshot.
> 
> ... yeah but that solution totally sucks when you:
> 
> a) have a lot of data
> b) need to do this via script
> c) ???
> 
> ... because in a), data will *copied* the slow way, and in b) you
> leave a bunch of junk laying around in the old root that will rot
> unless you `rm -rf` it ... and idk about you, but issuing what is very
> near to that command on someone else's machine -- via script -- makes
> me REALLY uneasy ;-)

well, don't put data in the top level in the first place. Yes, you have
to remove the content of the subvol / by rm -rf, but I don't really see
the problem with it.
What I don't understand is why you think data will be copied.

> 
> i have asked this exact question at least 4 times specifically, and
> referenced it probably 8-10, in the last 3 years or more.  i needed it
> then.  i still need it now.  but since i never got an answer up/down
> or around, i gave up and told people to `rm -rf`themselves ...
> 
> http://markmail.org/message/7hj5ioqrztkeerqv
> 
> ... that's from May of 2010, but i don't think it's the first.
> 
> so, would it possible to implement this, or could someone kindly (and
> briefly!) explain why it cannot be done?

The default subvol ('/') has the special number 5 and is expected to
always be around. All other subvols get numbers starting with 256.
Creating a new 5 and internally renumbering the old 5 isn't easy, because
each tree block has an owner recorded in it. Also, all backreferences
have the root number in them. If you have to touch each tree block, you
can as well choose the snapshot/rm -rf approach.

> 
> 1. people install stuff to the top-level
> 2. top-level is unmanageable
> 3. ^^^^ problem
> 
> in my case i wrote an initramfs hook that implemented rollback
> functionality, but there was not way for me to cleanly -- and safely
> -- "rotate" the user's setup to one that DOES NOT have user items in
> the top-level volume.

Can't instead add code to the installer that warns a user if he wants
to install into the default subvol?
Or you could hack mkfs.btrfs to always create an additional subvol.
Even making / readonly except for creating mountpoint could be possible.
Just some random ideas...

-Arne

> 

