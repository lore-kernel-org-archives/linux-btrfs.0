From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: Mass-Hardlinking Oops
Date: Mon, 12 Oct 2009 22:50:05 +0200
Message-ID: <4AD3967D.1070907@wpkg.org>
References: <4A74401B.90801@mccme.ru> <20090803145741.GC3765@think>	<4A76FB78.5000207@wpkg.org> <20090803235920.C13173@mccme.ru> <87my3y3r8u.fsf@faran.nsc.liu.se> <4AD35667.3020103@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: =?UTF-8?B?UMOkciBBbmRlcnNzb24=?= <paran@lysator.liu.se>,
	linux-btrfs@vger.kernel.org
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AD35667.3020103@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

jim owens wrote:
> P=C3=A4r Andersson wrote:
>> I just ran into the max hard link per directory limit, and remembere=
d
>> this thread. I get EMLINK when trying to create more than 311 (not 2=
72)
>> links in a directory, so at least the BUG() is fixed.
>>
>> What is the reason for the limit, and is there any chance of increas=
ing
>> it to something more reasonable as Mikhail suggested?
>>
>> For comparison I tried to create 200k hardlinks to the the same file=
 in
>> the same directory on btrfs, ext4, reiserfs and xfs:
>=20
> what real-world application uses and needs this many hard links?

The number of links depends on the length of a filename.

Is _13_ (yes, thirteen) hardlinks in a directory a big number? I don't =
think so.

On systems storing user data, I regularly see user files having maximum=
 length: mostly files=20
and/or directories saved by users using a webbrowser - the files take t=
heir name from the
website title, and these titles can be really long.

Consider that most sides of the world use UTF-8 characters, so the maxi=
mum file name is easily achieved.


Below, we hit this limit with just 13 hardlinks - it's not me to decide=
 if 13 is "this many hard links".


cd /tmp
dd if=3D/dev/zero of=3Dbtrfs.img bs=3D1M count=3D400
mkfs.btrfs btrfs.img
mount -o loop btrfs /mnt/btrfs/
touch aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
i=3D1 ; while [ $i -ne 40 ] ; do
> ln $LNFILE $i$LNFILE                         =20
> echo $i
> i=3D$((i+1))
> done                                                                 =
                                                                       =
                      =20
1                                                                      =
                                                                       =
                      =20
2                                                                      =
                                                                       =
                      =20
3                                                                      =
                                                                       =
                      =20
4                                                                      =
                                                                       =
                      =20
5
6
7
8
9
10
11
12
13
ln: Erzeuge harte Verkn=C3=BCpfung =E2=80=9E14aaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaa=E2=80=9C =E2=87=92  =E2=80=9Eaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaa=E2=80=9C: Datei oder Verzeichnis nicht gefunden
14
ln: Erzeuge harte Verkn=C3=BCpfung =E2=80=9E15aaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaa=E2=80=9C =E2=87=92  =E2=80=9Eaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaa=E2=80=9C: Datei oder Verzeichnis nicht gefunden
15
ln: Erzeuge harte Verkn=C3=BCpfung =E2=80=9E16aaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaa=E2=80=9C =E2=87=92  =E2=80=9Eaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaa=E2=80=9C: Datei oder Verzeichnis nicht gefunden
16

Message from syslogd@dom at Mon Oct 12 22:31:49 2009 ...
dom klogd: [ 9657.948456] Oops: 0000 [#1] SMP
Get=C3=B6tet
17

Message from syslogd@dom at Mon Oct 12 22:31:49 2009 ...
dom klogd: [ 9657.948459] last sysfs file: /sys/devices/system/cpu/cpu7=
/cache/index2/shared_cpu_map

Message from syslogd@dom at Mon Oct 12 22:31:49 2009 ...
dom klogd: [ 9657.948574] Stack:

Message from syslogd@dom at Mon Oct 12 22:31:49 2009 ...
dom klogd: [ 9657.948589] Call Trace:



--=20
Tomasz Chmielewski
http://wpkg.org
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
