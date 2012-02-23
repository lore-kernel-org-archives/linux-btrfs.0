From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: [RFC] btrfs auto snapshot
Date: Thu, 23 Feb 2012 19:13:09 +0700
Message-ID: <CAG1y0sddAf4zdvj82Xx-H0_YH8ssyzmtOJ1-+sUVnRUJM4+gTw@mail.gmail.com>
References: <4E4B2452.9070407@oracle.com>
	<1483419.CO5JBoDgFX@bursa22>
	<4F462ADE.4040507@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Hubert Kario <hka@qbs.com.pl>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: Anand Jain <Anand.Jain@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F462ADE.4040507@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 23, 2012 at 7:02 PM, Anand Jain <Anand.Jain@oracle.com> wro=
te:
>
>
> =A0autosnap code is available either end of this week or early
> =A0next week

I thought you stopped working on this :D

Alternatives are good though. Will test yours when it's out.

=46WIW, I also have another one, based on zfsonlinux's autosnapshot scr=
ipt :D

> and what you will notice is autosnap snapshots
> =A0are named using uuid.
>
> =A0Main reason to drop time-stamp based names is that,
> =A0 =A0- test (clicking on Take-snapshot button) which took more
> =A0than one snapshot per second was failing.
> =A0 =A0- a more descriptive creation time is available using a
> =A0 command line option as in the example below.
> =A0-----
> =A0# btrfs su list -t tag=3D@minute,parent=3D/btrfs/sv1 /btrfs
> =A0/btrfs/.autosnap/6c0dabfa-5ddb-11e1-a8c1-0800271feb99 Thu Feb 23 1=
3:01:18
> 2012 /btrfs/sv1 @minute
> =A0/btrfs/.autosnap/5669613e-5ddd-11e1-a644-0800271feb99 Thu Feb 23 1=
3:15:01
> 2012 /btrfs/sv1 @minute
> =A0-----
> =A0As of now code for time-stamp as autosnap snapshot name is
> =A0commented out, if more people wanted it to be a time-stamp
> =A0based names, I don't mind having that way. Please do let me know.

=46or me the main bonus point of having timestamp in names in the
abiility to sort it by creation date by simply using "ls". As for the
more-than-one-click-per-second problem, in my script I simply let it
fail and return informative-enough error message.

A workaround would be adding nanosecond timestamp, or put the UUID
AFTER the time stamp, e.g:
/btrfs/.autosnap/@minute_20120223_131501_123456_5669613e-5ddd-11e1-a644=
-0800271feb99

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
