From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: graceful handling of removing a plugable storage device that is being written to
Date: Sun, 11 Sep 2011 18:53:20 +0200
Message-ID: <201109111853.20530.Martin@lichtvoll.de>
References: <1315751507.52552.YahooMailClassic@web29517.mail.ird.yahoo.com> (sfid-20110911_183202_857806_256156E9)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: "Hin-Tak Leung" <hintak_leung@yahoo.co.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1315751507.52552.YahooMailClassic@web29517.mail.ird.yahoo.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 11. September 2011 schrieb Hin-Tak Leung:
> --- On Sun, 11/9/11, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> > Cc to BTRFS mailinglist as it
> > triggered the idea of mine again.
> >=20
> >=20
> > Hi!
> >=20
> > Today I did it again and removed a BTRFS partition that is
> > written too.
> > That BTRFS as of Kernel 3.0.3 (debian package) does not
> > like very much. I
> > think thats a known issue and I wrote a mail to BTRFS
> > mailing list about
> > it.
> >=20
> > In there I wrote:
> > > Expected results:
> > >=20
> > > BTRFS fails gracefully except the loss of data from
> >=20
> > writes in flight, the
> >=20
> > > machine remains usable and BTRFS can be mounted
> >=20
> > again.
> >=20
> > And then cause the expected results IMHO are by no way the
> >=20
> > ideal results:
> > > Ideal results (IMHO):
> > >=20
> > > Linux behaved like AmigaOS and told me that I *must*
> >=20
> > insert the device
> >=20
> > > again and *continues* writing after I did this.
> >=20
> > But I never saw any other OS that did that.
> >=20
> > And I see the problems with high bandwidth writes piling up
> > in memory
> > causing severe memory pressure.
> >=20
> > But then could Linux just freeze processes that continue
> > writing to the
> > drive until it is replugged again? Of course that
> > shouldn=B4t happen to the
> > drive / resides on.
> >=20
> > And there is a userspace part in it - the possibly udev and
> > dbus  driven
> > notification to the user.
>=20
> How do you cope with
> (1) headless systems (one where there is no udev/dbus notification or
> display). (2) the user walking off in a hurry and never seeing the
> notification? Should the kernel/user processes freeze indefinitely?
>=20
> There is also a 3rd scenario - how how one malicious person or proces=
s
> doing a repeat insert/remove/write and get resource to pile up and
> crash the machine?
>=20
> It is probably possible/recommended with Amiga because Amiga is
> seldomly run headless?

This all are important and valid questions, IMHO. Still I think the=20
approach taken by AmigaOS has some merit here.

(1) headless systems:

a) servers usually do not have much to do with removable media. But sti=
ll,=20
what about FC or iSCSI LUNs? What should the kernel do here? Frankly, I=
=20
don=B4t know. Maybe its best to default to current behavior which impos=
es a=20
risk for data loss. But then NFS is used in enterprise environments, to=
o,=20
and it does block by default. Indefinetely. I have seen loads of 300 an=
d=20
more cause of that behavior which is there to *prevent* data loss on NF=
S=20
clients.

b) headless media systems: maybe its best to have to default to current=
=20
behavior, when its known that a notification can=B4t be done. But how t=
o=20
tell? Maybe best would be a timeout. Then the user even would have a=20
chance to reinsert the media.

(2) I thought about how long to wait / possibly freeze processes as wel=
l:=20
Maybe it would be good to let go after a while. But I think that also=20
depends on whether more writes are done. If its an USB stick and the us=
er=20
just copied some files to it and removed it prematurely without noticin=
g=20
the notification, then I think the kernel could wait indefinetely.

*But* and this brings up a serious issue, I did not think about before:=
=20
When the user mounts the USB stick somewhere else and finds out about t=
he=20
missing files only by then, there is a real risk for data loss, if the=20
kernel of the machine that stalled the I/O insists on completing the=20
writes if the user inserts the USB stick again.

Thus it seems to me that the kernel would have to check the last mount=20
time and the filesystem state. If the last mount time is newer and/or t=
he=20
filesystem is cleanly unmounted, I think the kernel must refuse any fur=
ther=20
attempts to complete outstanding writes in order to protect filesystem=20
integrity.

=46rankly, I never tried this on AmigaOS. I know that AmigaOS expects t=
he=20
exact same floppy disk to be inserted again. Only the same name isn=B4t=
=20
enough. But I have no idea, what AmigaOS would have done, when I insert=
ed=20
the disk into another Amiga, did something there and then insert it int=
o=20
the Amiga with the notification and pressed "okay". Probably it would h=
ave=20
eaten the disk then.

This is a serious issue which makes implementing my suggestion more=20
difficult. The kernel has to make sure not to eat a filesystem in order=
 to=20
complete outstanding writes!

(3) I wouldn=B4t worry too much about malicious persons. Why? Cause wit=
h=20
current standard ulimit values there are way easier methods to stall a=20
machine to a halt. I have seen more than once during holding Linux=20
performance tuning courses, that running the command "stress" with=20
aggressive parameters effectively offlines a Linux machine. I often do =
a=20
check list on how often course participants make one of the Linux serve=
rs=20
we work so unresponsive that a reboot is in order. So I think graceful=20
handling of media removal doesn=B4t add much to the existing issues=20
regarding that topic.

Ciao,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
