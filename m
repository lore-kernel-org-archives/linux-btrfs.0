Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:33020 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbbF1SCi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Jun 2015 14:02:38 -0400
Received: by laar3 with SMTP id r3so40425435laa.0
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Jun 2015 11:02:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSv15DVDju7vhm=Luc5hqWvce__F7iovh87uxq37bNg0Q@mail.gmail.com>
References: <CA+xOVSOD1YY-=Cm+vmzTUV9cHe9idtDkRr0RmpRP5a0Z6eC4YQ@mail.gmail.com>
	<CA+xOVSNu547eo6TY_mwLypTGWuE5AmyMqC6GwR06Sir1282vqA@mail.gmail.com>
	<CAJCQCtSv15DVDju7vhm=Luc5hqWvce__F7iovh87uxq37bNg0Q@mail.gmail.com>
Date: Sun, 28 Jun 2015 21:02:37 +0300
Message-ID: <CA+xOVSMjO0e5TPfksr=TmnT9zc5=hJemYPtn_tg+xxsWbFMV=A@mail.gmail.com>
Subject: Re: btrfs replace seems to corrupt the file system
From: Mordechay Kaganer <mkaganer@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

B.H.

Thanks for the reply.

On Sun, Jun 28, 2015 at 7:45 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
> Option A: Maybe someone has advice on how to get the demoted device to
> be valid again as if the replace command hadn't been used. Because
> then you could try the replace again with newer kernel and progs, and
> see if the problem still happens. That's a good question to ask on IRC
> if you don't have a response by tomorrow.

To recover the old device, that's what i'm trying to do. Asked on IRC
also, no reply. As stated above, the device passes btrfs check without
errors but cannot mount because it complains about "ongoing replace"
and the replace device is missing.

> Option B: In the meantime, start to check some files to see if they're
> actually corrupt or if these csum errors are bogus.

Tried to copy some files that are reported with bad checksums out of
the "new" volume. Copy fails with messages like this:

[181896.761117] BTRFS info (device md1): csum failed ino 3849795 off
1388544 csum 2566472073 expected csum 3428551483
[181896.761362] BTRFS info (device md1): csum failed ino 3849795 off
1519616 csum 2566472073 expected csum 1565909691
[181896.761997] BTRFS info (device md1): csum failed ino 3849795
extent 5084061945856 csum 2566472073 wanted 2627769260 mirror 0
[181896.769091] BTRFS info (device md1): csum failed ino 3849795 off
1257472 csum 2566472073 expected csum 4184704592
[181896.769509] BTRFS info (device md1): csum failed ino 3849795 off
1257472 csum 2566472073 expected csum 4184704592
[181897.171789] BTRFS info (device md1): csum failed ino 2940181
extent 4288477184000 csum 2566472073 wanted 1434149511 mirror 0
[181897.171984] BTRFS info (device md1): csum failed ino 2940181
extent 4288477270016 csum 2566472073 wanted 439924019 mirror 0
[181897.172199] BTRFS info (device md1): csum failed ino 2940181
extent 4288477356032 csum 2566472073 wanted 3293573949 mirror 0

> Option C: Well, it's a backup so actually before A or B it's probably
> best to start making a new backup in case this one is beyond repair.
> So hopefully you have a 3rd location to put it into so you can keep
> both of these Btrfs volumes in their current states until you have a
> more clear idea what to do with them, but at least you're not delaying
> getting a current backup in place. Whether this new backup is Btrfs
> based or not is less important than actually having a backup.

Unfortunately, i don't have so much free storage, it's more than 15TB.
But i do have another backup, so the recovery is not so urgent. The
btrfs backup is the only place where i have the older snapshots of the
data (actually, this is why we decided using btrfs on the first hand)
and reformatting will mean to loose that older data.

-- משיח NOW!
Moshiach is coming very soon, prepare yourself!
יחי אדוננו מורינו ורבינו מלך המשיח לעולם ועד!
