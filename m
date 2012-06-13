Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58578 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab2FMHFU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 03:05:20 -0400
Received: by lbbgm6 with SMTP id gm6so981843lbb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Jun 2012 00:05:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FD2552D.20003@gmx.net>
References: <1339183466.55421.YahooMailNeo@web160803.mail.bf1.yahoo.com> <4FD2552D.20003@gmx.net>
From: C Anthony Risinger <anthony@xtfx.me>
Date: Wed, 13 Jun 2012 02:04:58 -0500
Message-ID: <CAGAVQTGctBTEKTCvhNbAsw7zMg5NfBm8n=Kf=wULKRNm5LQSjQ@mail.gmail.com>
Subject: Re: Moving top level to a subvolume
To: Arne Jansen <sensille@gmx.net>
Cc: Matthew Hawn <steamraven@yahoo.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 8, 2012 at 2:40 PM, Arne Jansen <sensille@gmx.net> wrote:
> On 06/08/2012 09:24 PM, Matthew Hawn wrote:
>> I just converted my root filesystem to btrfs with btrfs-convert.  However, since I am running Ubuntu, I would like to have the same subvolume structure as a default install,. How do I move the top-level subvolume (where all my files currently are) to another subvolume?
>
> Just snapshot the root subvol and continue working in the snapshot.

... yeah but that solution totally sucks when you:

a) have a lot of data
b) need to do this via script
c) ???

... because in a), data will *copied* the slow way, and in b) you
leave a bunch of junk laying around in the old root that will rot
unless you `rm -rf` it ... and idk about you, but issuing what is very
near to that command on someone else's machine -- via script -- makes
me REALLY uneasy ;-)

i have asked this exact question at least 4 times specifically, and
referenced it probably 8-10, in the last 3 years or more.  i needed it
then.  i still need it now.  but since i never got an answer up/down
or around, i gave up and told people to `rm -rf`themselves ...

http://markmail.org/message/7hj5ioqrztkeerqv

... that's from May of 2010, but i don't think it's the first.

so, would it possible to implement this, or could someone kindly (and
briefly!) explain why it cannot be done?

1. people install stuff to the top-level
2. top-level is unmanageable
3. ^^^^ problem

in my case i wrote an initramfs hook that implemented rollback
functionality, but there was not way for me to cleanly -- and safely
-- "rotate" the user's setup to one that DOES NOT have user items in
the top-level volume.

-- 

C Anthony
