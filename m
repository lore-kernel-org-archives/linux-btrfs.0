From: John <jello@waste.org>
Subject: Re: fixing slow sync(2)
Date: Mon, 10 Oct 2011 22:11:21 -0500
Message-ID: <CAE=-PDgp690RMQ_Cvm2GpUqknXZdUaVco2SeqWtTsSDkqMP9pA@mail.gmail.com>
References: <4E906B1F.6010609@dbservice.com>
	<20111008153553.GA25337@dhcp231-156.rdu.redhat.com>
	<CAE=-PDhvddavk9DyyF07gi0uq=a+WfGbXN89r28SRK9SYPaZfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAE=-PDhvddavk9DyyF07gi0uq=a+WfGbXN89r28SRK9SYPaZfA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Resending as plain text.

---------- Forwarded message ----------
=46rom: John <jello@waste.org>
Date: Mon, Oct 10, 2011 at 9:34 PM
Subject: Re: fixing slow sync(2)
To: Josef Bacik <josef@redhat.com>
Cc: Tomas Carnecky <tom@dbservice.com>, linux-btrfs@vger.kernel.org


On Sat, Oct 8, 2011 at 10:35 AM, Josef Bacik <josef@redhat.com> wrote:
>
> I think I fixed this, try my git tree
>
> git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-work.git
>
> Let me know if it helps. =A0And what are you doing when you call sync=
? =A0I've not
> been able to reproduce this problem so I'm having a hard time nailing=
 down what
> it is, so if I can get a reliable way to reproduce it I'll try and fi=
gure it
> out. =A0Thanks,

I've been seeing very slow syncs (and unmounts) and this helps. Under
3.0.0 if I mounted the FS (which is 200G, about 97G used with ~720
snapshots) it took about 3 minutes 40 seconds. If I did another sync
right away it took the same amount of time. With a kernel compiled
from your repo the first time I sync it takes about 1 minute, as soon
as I sync a=A0btrfs-endio-met and=A0btrfs-cache-0 process show up in to=
p
and a lot of IO happens. Once those go away (which takes a couple
minutes) then it takes well under a second. If I unmount and remount
it acts exactly the same. Will those changes be up in 3.1 or 3.2? If
you want me to test anything else, I'm happy to do so.
Thanks much.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
