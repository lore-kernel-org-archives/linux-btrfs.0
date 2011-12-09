From: Chris Mason <chris.mason@oracle.com>
Subject: Re: BUG during btrfs device delete missing
Date: Fri, 9 Dec 2011 11:52:06 -0500
Message-ID: <20111209165206.GE8971@shiny>
References: <CAHh_JMPvmRNRrhh0aQhQiej+NP4Vb36MbFtECFphc8cUM9B=ZQ@mail.gmail.com>
 <CAHh_JMOxrqLRC2ad5n3DuArL1hQdNiixO7jd8StYSKLkbLUB7A@mail.gmail.com>
 <20111208194556.GS8971@shiny>
 <CAHh_JMOfLyHV=BSnW8J=8tn6huH0A2AvKqk6+WdOLCdG6zqkAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: David Marcin <djmarcin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAHh_JMOfLyHV=BSnW8J=8tn6huH0A2AvKqk6+WdOLCdG6zqkAA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 08, 2011 at 12:27:52PM -0800, David Marcin wrote:
> Hi Chris,
> This was on 3.2-rc2 but I tried with rc4 and it segfaulted again. =A0=
I
> think the traces were the same but I've rebooted and can't say for
> sure.
> David
> On Thu, Dec 8, 2011 at 11:45 AM, Chris Mason <chris.mason@oracle.com>=
 wrote:
> > Which kernel is this? =A0This looks like one I recently fixed.
> >
> > -chris
> >
> > On Thu, Dec 08, 2011 at 11:06:47AM -0800, David Marcin wrote:
> >> raid10 metadata and data filesystem. =A0dmesg log follows. =A0The =
system
> >> is unable to unmount the filesystem after this occurs.
> >>
> >> Filesystem mounted at/mnt/btrfs with -o compress,degraded
> >> Command: btrfs device delete missing /mnt/btrfs
> >>
> >> [ =A0283.398222] ------------[ cut here ]------------
> >> [ =A0283.398289] kernel BUG at /home/apw/COD/linux/fs/btrfs/transa=
ction.c:1329!

So this crash means we failed to write all the blocks required to commi=
t
the transaction.  The reason is that we're getting failed bios to the
missing device, and that failure isn't properly eaten by the
raid aware endio code.

If you pull the top commit from my for-linus branch, it should all work=
=2E

I know you've got a big FS here, I haven't tested this on raid10 yet,
only raid1.  If you want to wait a bit for safety I'll do a raid10 run
too.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
