Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52331 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563Ab2GYRKv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jul 2012 13:10:51 -0400
Received: by obbuo13 with SMTP id uo13so1329993obb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2012 10:10:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB9VWqBMe_8b3yD53XEkJoegbaqDAD-sinrE3ed3rYT0eyZDpA@mail.gmail.com>
References: <1341409174-13619-1-git-send-email-ablock84@googlemail.com>
	<500D43A7.1010801@gmx.net>
	<CAB9VWqAGTOttaz722LnMiufPNUZaLQU7epAdGFejK9gssuHnRg@mail.gmail.com>
	<20120725140036.GE30007@carfax.org.uk>
	<CAB9VWqBMe_8b3yD53XEkJoegbaqDAD-sinrE3ed3rYT0eyZDpA@mail.gmail.com>
Date: Wed, 25 Jul 2012 20:10:51 +0300
Message-ID: <CAHf9xvYr2w0S+5U0HNtg73PkXq9CwUO_7pRONoeK4QzC0BTdWQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] Experimental btrfs send/receive (btrfs-progs)
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Alexander Block <ablock84@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alexander,
can you pls let know like a day or two before you run out of time?
I have compiled a list of questions, but also want to do more testing
before I publish them all.

Thanks for your work,
Alex.

On Wed, Jul 25, 2012 at 7:56 PM, Alexander Block
<ablock84@googlemail.com> wrote:
> On Wed, Jul 25, 2012 at 4:00 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> On Wed, Jul 25, 2012 at 12:41:56PM +0200, Alexander Block wrote:
>>> On Mon, Jul 23, 2012 at 2:29 PM, Arne Jansen <sensille@gmx.net> wrote:
>>> > On 04.07.2012 15:39, Alexander Block wrote:
>>> >> Hello all,
>>> >>
>>> >> This is the user space side of btrfs send/receive.
>>> >>
>>> >> You can apply them manually or use my git repo:
>>> >>
>>> >> git://github.com/ablock84/btrfs-progs.git (branch send)
>>> >>
>>> >> The branch is based on Hugo's integration-20120605 branch. I had to add a temporary
>>> >> commit to fix a bug introduced in one of the strncpy/overflow patches that got into
>>> >> btrfs-progs. This fix is not part of the btrfs send/receive patchset, but you'll
>>> >> probably need it if you want to base on the integration branch. I hope this is not
>>> >> required in the future when a new integration branch comes out.
>>> >>
>>> >> Example usage:
>>> >>
>>> >> Multiple snapshots at once:
>>> >> btrfs send /mnt/snap[123] > snap123.btrfs
>>> >
>>> > a) Do we really want a single token command here, not
>>> > btrfs filesystem send or subvol send?
>>> In my opinion the single token is easier to type and remember. But if
>>> enough speaks for normal subcommands this can be changed (but by
>>> someone else as I'm running out of time).
>>
>>    Since everything else is two commands, yes, I think we need it for
>> consistency. (And, since it's a publically-visible interface, for
>> acceptance of the patches -- we don't want to be changing the way the
>> commands work after the fact).
>>
>>> > b) zfs makes sure stdout is not a tty, to prevent flooding
>>> > your console. This kinda makes sense.
>>> This makes sense. But again, this has to be done by someone else.
>>
>>    Can you keep a brief list of such cleanups/features and dump it on
>> the wiki as a proposed project when your time does run out, please.
>> That way the details don't get lost, and they can be found by other
>> people and dealt with independently.
> Added a page to the wiki:
> https://btrfs.wiki.kernel.org/index.php/Btrfs_Send/Receive
>>
>>    Hugo.
>>
>> --
>> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>>   PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>>     --- Turning,  pages turning in the widening bath, / The spine ---
>>         cannot bear the humidity. / Books fall apart; the binding
>>             cannot hold. / Page 129 is loosed upon the world.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
