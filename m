Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56661 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab2FMJpF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 05:45:05 -0400
Received: by lbbgm6 with SMTP id gm6so1070539lbb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Jun 2012 02:45:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FD83F75.5000600@gmx.net>
References: <1339183466.55421.YahooMailNeo@web160803.mail.bf1.yahoo.com>
 <4FD2552D.20003@gmx.net> <CAGAVQTGctBTEKTCvhNbAsw7zMg5NfBm8n=Kf=wULKRNm5LQSjQ@mail.gmail.com>
 <4FD83F75.5000600@gmx.net>
From: C Anthony Risinger <anthony@xtfx.me>
Date: Wed, 13 Jun 2012 04:44:43 -0500
Message-ID: <CAGAVQTGJrUoZ3SdoqmTadkZZst6TkbNoAHmRSXvJ7JEB3FTA+g@mail.gmail.com>
Subject: Re: Moving top level to a subvolume
To: Arne Jansen <sensille@gmx.net>
Cc: Matthew Hawn <steamraven@yahoo.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 13, 2012 at 2:21 AM, Arne Jansen <sensille@gmx.net> wrote:
> On 13.06.2012 09:04, C Anthony Risinger wrote:
>>
>> a) have a lot of data
>> b) need to do this via script
>> c) ???
>>
>> ... because in a), data will *copied* the slow way, and in b) you
>> leave a bunch of junk laying around in the old root that will rot
>> unless you `rm -rf` it ... [...]
>
> What I don't understand is why you think data will be copied.

at one point i tried to create a new subvol and `mv` files there, and
it took quite some time to complete
(cross-link-device-what-have-you?), but maybe things changed ... will
try it out.

>> [...]
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

ok this makes sense thanks, the last sentence especially ... top-level
volume is different.  it's identical to other subvols in 99% of ways
save one-gotcha-little-1%.  couldn't we shield ourselves a little
better?

>> 1. people install stuff to the top-level
>> 2. top-level is unmanageable
>> 3. ^^^^ problem
>> [...]
>
> Can't instead add code to the installer that warns a user if he wants
> to install into the default subvol?


> Just some random ideas...

i would like to see #5 cut off from natural access: accessible by an
_explicit_ manual mount only, cannot be made default, and cannot be
removed. maybe btrfs manages a proxy/facade subvol, say, #10, settable
by `--flag-origin` or `{insert-here}` option -- a symlink to subvol?
if, at absolutely any time or whatever reason, #10 pointer should not
exist, immediately snapshot #5 and update.

#5 -> #10 -> #256+ ?

... this might allow the root to be "replaced".  default is set to #10
proxy volume when FS is initialized.

> [...]
> Or you could hack mkfs.btrfs to always create an additional subvol.
> Even making / readonly except for creating mountpoint could be possible.

^^^^^ yeah, this sounds like exactly what i'm thinking, differing
mainly on who does the work... i just want a guaranteed way of
replacing the "logical root", at #10.  the "physical root" at #5 it's
more-or-less indestructible and off limits, and never available except
as a template.

... i am new to postgresql, but their template0/template1 feels
related to solving problems like this.

-- 

C Anthony
