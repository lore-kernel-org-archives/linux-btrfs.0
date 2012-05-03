From: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
Subject: Re: Boot speed/mount time regression with 3.4.0-rc2
Date: Thu, 3 May 2012 15:40:03 +0200
Message-ID: <CAFDW0j+WQhQQ=ywUJGLeRCENp1KG3f-UhfYUbxRYemXoB-60=g@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: cwillu <cwillu@cwillu.com>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAFDW0jKRig6GTB4Oq4VG8xZQN4ArUnft1X9ST7cfyLHFTUs4NA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 21, 2012 at 10:54 PM, Ahmet Inan
<ainan@mathematik.uni-freiburg.de> wrote:
> On Fri, Apr 13, 2012 at 3:47 PM, Josef Bacik <josef@redhat.com> wrote=
:
>> On Fri, Apr 13, 2012 at 02:26:19PM +0200, Ahmet Inan wrote:
>>> On Fri, Apr 13, 2012 at 1:22 PM, Ahmet Inan
>>> <ainan@mathematik.uni-freiburg.de> wrote:
>>> > On Fri, Apr 13, 2012 at 8:49 AM, cwillu <cwillu@cwillu.com> wrote=
:
>>> >>> dmesg and fstab attached as requested.
>>> >>
>>> >> Need dmesg after you've hit alt-sysrq-w a couple times during th=
e slow period.
>>> >
>>> > here.
>>> >
>>> > i guess i should also increase dmesg history size next time.
>>> > other than the slow boot, everything seems normal after 10-20minu=
tes.
>>> >
>>> > fyi: the space_cache option is not really helping with those
>>> > twenty computers. the one thing i observed is, that sometimes
>>> > they reboot fast and only to reboot slow again after that.
>>>
>>> sorry for spaming the list with my dmesg files,
>>> please tell me, how i could do better.
>>>
>>> here a more complete dmesg.
>>
>> Hrm so you are getting blocked task warnings just trying to mount th=
e
>> filesystem, so either your disk is really really really slow or ther=
e's
>> something bigger going on. =C2=A0Let me think about this some and I'=
ll get back to
>> you.
>
> Josef, i finally found out something:
>
> btrfs in kernel =3D> fast boot
> btrfs as module =3D> very slow boot
>
> and here see the results:
> http://aam.mathematik.uni-freiburg.de/IAM/homepages/ainan/bootchart_b=
trfs_in_kernel.png
>
> this is much, much better!
>
> I dont understand why btrfs as a module performs that bad on rotating=
 disk.
> On SSD i had no issues and also i never used space_cache before.
>
> Im going to deploy the new kernel on our systems next week with
> btrfs in-kernel and come back with the results.

=46YI: a 100 computers here with all kinds of hardware constellations
work perfectly since the kernel upgrade (3.3.2 + for-linus) one week ag=
o.
We are very happy with the better btrfs performance.
Also boot times are very short again.
Even upgrading from different and very old Kernel versions worked flawl=
ess:
vanilla linux-2.6.38.8: "Old style space inode found, converting." grea=
t :-)

To make a long story short:
Thanks a lot!

Ahmet
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
