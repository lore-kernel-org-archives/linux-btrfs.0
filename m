From: Chester <somethingsome2000@gmail.com>
Subject: Re: how can I copy files bigger than ~32 GB when using compress-force?
Date: Mon, 4 Oct 2010 23:12:12 -0500
Message-ID: <AANLkTim+YFZKBDMs9FAONrPdqN8ogw0Thnyeb1H4XySG@mail.gmail.com>
References: <4CAA4A34.80701@wpkg.org>
	<20101004222837.GD9759@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101004222837.GD9759@think>
List-ID: <linux-btrfs.vger.kernel.org>

I once tried to copy a chroot onto a USB mount, mounted with the
'compress,noatime' option, and the same thing kept happening to me. I
started using slower methods to transfer the files over, and I no
longer encountered the hanging problem. I was not copying any big
files, but it was a chroot, so there were lots of small files.

On Mon, Oct 4, 2010 at 5:28 PM, Chris Mason <chris.mason@oracle.com> wr=
ote:
>
> On Mon, Oct 04, 2010 at 11:42:12PM +0200, Tomasz Chmielewski wrote:
> > >I'm assuming this works without compress-force? =A0I can make a gu=
ess at
> > >what is happening, the compression forces a relatively small exten=
t
> > >size, and this is making our worst case metadata reservations get =
upset.
> >
> > Yes, it works without compress-force.
> >
> > Interesting is that cp or rsync sometimes just exit quite fast with
> > "no space left".
> >
> > Sometimes, they just "hang" (waited up to about an hour) - file siz=
e
> > does not grow anymore, last modified time is not updated, iostat
>
> Sorry is this hang/fast exit with or without compress-force.
>
> > does not show any bytes read/written, there are no btrfs or any
> > other processes taking too much CPU, cp/rsync is not in "D" state
> > (although it gets to "D" state and uses 100% CPU as I try to kill
> > it).
> >
> > Could it be we're hitting two different bugs here?
> >
> >
> > >Does it happen with any 32gb file that doesn't compress well?
> >
> > The 220 GB qcow2 file was basically uncompressible (backuppc archiv=
e
> > full of bzip2-compressed files).
>
> Ok, I think I know what is happening here, they all lead to the same
> chunk of code. =A0I'll be able to reproduce this locally.
>
> -chris
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
