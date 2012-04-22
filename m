From: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
Subject: Re: Boot speed/mount time regression with 3.4.0-rc2
Date: Sun, 22 Apr 2012 11:16:57 +0200
Message-ID: <CAFDW0jKmJzDBVyzC7uEWs-Bx9x0SHZs3duFjd9dAo_VW21sEBw@mail.gmail.com>
References: <20120410151645.GC2296@localhost.localdomain>
	<CAFDW0j+=qe49pX3frjEoozOMz-gKKxqJ+jeeTgyXEskDL_9W8w@mail.gmail.com>
	<20120411170422.GA2506@localhost.localdomain>
	<CAFDW0jJZ16jPn766fdn3Hm=WWkR71n0kJapfPZzgHd3o71b1hQ@mail.gmail.com>
	<20120412133747.GE1924@localhost.localdomain>
	<20120412142349.GI1924@localhost.localdomain>
	<CAFDW0jJq46TXa_a1soYESgjZosBDM8razvT271S3_SoyQeBbSA@mail.gmail.com>
	<CAE5mzvjJ+fuixm=OpKua6t6s6sncz1RGwXem8D6ZS=jDRDQ3+g@mail.gmail.com>
	<CAFDW0jL4TTWtqMw4f_1WpQuEU7Q1SoTUo_rBVGcdHt008Sx1Zw@mail.gmail.com>
	<CAFDW0jKMEQ+oMN41euh1cMy4h+6Qntt5UL9+0HZw4r9SpDJVvQ@mail.gmail.com>
	<20120413134716.GB1923@localhost.localdomain>
	<CAFDW0jKRig6GTB4Oq4VG8xZQN4ArUnft1X9ST7cfyLHFTUs4NA@mail.gmail.com>
	<20120422105919.28b027a0@sf.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>, cwillu <cwillu@cwillu.com>,
	Calvin Walton <calvin.walton@kepstin.ca>,
	linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120422105919.28b027a0@sf.home>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 22, 2012 at 9:59 AM, Sergei Trofimovich <slyich@gmail.com> =
wrote:
> On Sat, 21 Apr 2012 22:54:41 +0200
> Ahmet Inan <ainan@mathematik.uni-freiburg.de> wrote:
>
>> On Fri, Apr 13, 2012 at 3:47 PM, Josef Bacik <josef@redhat.com> wrot=
e:
>> > On Fri, Apr 13, 2012 at 02:26:19PM +0200, Ahmet Inan wrote:
>> >> On Fri, Apr 13, 2012 at 1:22 PM, Ahmet Inan
>> >> <ainan@mathematik.uni-freiburg.de> wrote:
>> >> > On Fri, Apr 13, 2012 at 8:49 AM, cwillu <cwillu@cwillu.com> wro=
te:
>> >> >>> dmesg and fstab attached as requested.
>> >> >>
>> >> >> Need dmesg after you've hit alt-sysrq-w a couple times during =
the slow period.
>> >> >
>> >> > here.
>> >> >
>> >> > i guess i should also increase dmesg history size next time.
>> >> > other than the slow boot, everything seems normal after 10-20mi=
nutes.
>> >> >
>> >> > fyi: the space_cache option is not really helping with those
>> >> > twenty computers. the one thing i observed is, that sometimes
>> >> > they reboot fast and only to reboot slow again after that.
>> >>
>> >> sorry for spaming the list with my dmesg files,
>> >> please tell me, how i could do better.
>> >>
>> >> here a more complete dmesg.
>> >
>> > Hrm so you are getting blocked task warnings just trying to mount =
the
>> > filesystem, so either your disk is really really really slow or th=
ere's
>> > something bigger going on. =C2=A0Let me think about this some and =
I'll get back to
>> > you.
>>
>> Josef, i finally found out something:
>>
>> btrfs in kernel =3D> fast boot
>> btrfs as module =3D> very slow boot
>>
>> and here see the results:
>> http://aam.mathematik.uni-freiburg.de/IAM/homepages/ainan/bootchart_=
btrfs_in_kernel.png
>>
>> this is much, much better!
>>
>> I dont understand why btrfs as a module performs that bad on rotatin=
g disk.
>> On SSD i had no issues and also i never used space_cache before.
>
> There is a suspiction that putting space_cache (or anything else) to =
fstab for rootfs
> does not get applied due to a bug:
>
> =C2=A0 =C2=A0http://www.mail-archive.com/linux-btrfs@vger.kernel.org/=
msg16039.html

Thats right.

space_cache only got enabled for real, after ive set the option in the
boot argument once.
Even if it looks like it gets enabled in dmesg via /etc/fstab,
the next boot without space_cache doesnt show space_cache enabled.

But this is another problem i will look into later.
At the moment the biggest problem is having btrfs as a module.

> Do all of your affected computers run 3.4.0-rc kernels?

They run vanilla/linux-3.3.2 with btrfs/for-linus.
The unaffected computers have <=3D vanilla/linux-3.2.9 with
btrfs/for-linus from 2 months ago or so.

Ahmet
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
