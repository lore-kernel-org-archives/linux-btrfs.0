From: Gustavo Alves <gjalves@gjalves.com.br>
Subject: Re: assertion failures
Date: Fri, 26 Feb 2010 18:26:58 -0300
Message-ID: <69e11d1f1002261326h293aafbfp2c8028820a4b103a@mail.gmail.com>
References: <20100225004004.GK25641@think>
	 <20100225140420.4EBA940954@viridian.itc.virginia.edu>
	 <69e11d1f1002251028s3df20904yb9e90be36c883bbe@mail.gmail.com>
	 <20100226161332.GA12841@think> <20100226161523.GB12841@think>
	 <69e11d1f1002261157x1b305776w96f6bfcef4b8ae2f@mail.gmail.com>
	 <20100226211050.GN12841@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Gustavo Alves <gjalves@gjalves.com.br>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100226211050.GN12841@think>
List-ID: <linux-btrfs.vger.kernel.org>

In the tragic day I have done a "halt" command, but, as usual, never
finished as btrfs freezes before umount. I waited almost 5 minutes and
then pressed the power button.

The struct of the machine was very similar with the machine listed belo=
w.

 --- Physical volume ---
  PV Name               /dev/sda
  VG Name               specchio
  PV Size               465.76 GiB / not usable 12.02 MiB
  Allocatable           yes (but full)
  PE Size               128.00 MiB
  Total PE              3726
  Free PE               0
  Allocated PE          3726
  PV UUID               YpNYXY-AI1i-1D8D-9BAa-1DeY-hWNL-ZOtBIh

  --- Physical volume ---
  PV Name               /dev/sdb1
  VG Name               specchio
  PV Size               931.51 GiB / not usable 11.19 MiB
  Allocatable           yes
  PE Size               128.00 MiB
  Total PE              7452
  Free PE               24
  Allocated PE          7428
  PV UUID               G1mWRL-I7zx-bwbi-zYe8-tc2q-DrtD-tH6jIi

  --- Physical volume ---
  PV Name               /dev/sdd
  VG Name               specchio
  PV Size               931.51 GiB / not usable 13.71 MiB
  Allocatable           yes (but full)
  PE Size               128.00 MiB
  Total PE              7452
  Free PE               0
  Allocated PE          7452
  PV UUID               TWCEea-UURq-8HbM-NgkC-2J3Y-1qYE-TN7vud

  --- Physical volume ---
  PV Name               /dev/sdc
  VG Name               specchio
  PV Size               1.36 TiB / not usable 15.40 MiB
  Allocatable           yes
  PE Size               128.00 MiB
  Total PE              11178
  Free PE               11024
  Allocated PE          154
  PV UUID               hUbv4T-2Q0i-plGb-EO6a-2vAo-uHwj-Vda8zz

--- Volume group ---
  VG Name               specchio
  System ID
  Format                lvm2
  Metadata Areas        4
  Metadata Sequence No  37
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                15
  Open LV               15
  Max PV                0
  Cur PV                4
  Act PV                4
  VG Size               3.64 TiB
  PE Size               128.00 MiB
  Total PE              29808
  Alloc PE / Size       18760 / 2.29 TiB
  Free  PE / Size       11048 / 1.35 TiB
  VG UUID               AKxGo3-MVTJ-7XdC-GeTW-23e8-5Ee2-HY2PZ0

----
Gustavo Junior Alves

On Fri, Feb 26, 2010 at 6:10 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
> On Fri, Feb 26, 2010 at 04:57:27PM -0300, Gustavo Alves wrote:
>> In my case, kernel 2.6.32-0.51.rc7.git2.fc13.i686.PAE and BTRFS unde=
r LVM2.
>>
>
> Did you also have power-off based reboots? =A0Depending on the
> configuration LVM (anything other than a single drive) won't send bar=
riers to
> the device.
>
> -chris
>
>> ----
>> Gustavo Junior Alves
>> Specchio Solu=E7=F5es em TI
>>
>>
>> On Fri, Feb 26, 2010 at 1:15 PM, Chris Mason <chris.mason@oracle.com=
> wrote:
>> > On Fri, Feb 26, 2010 at 11:13:32AM -0500, Chris Mason wrote:
>> >> On Thu, Feb 25, 2010 at 03:28:19PM -0300, Gustavo Alves wrote:
>> >> > I've got the same error before in a similar situation (24 parti=
tions,
>> >> > only two with problems). Unfortunally I erased all data after t=
his
>> >> > error. Strange that all I've done was shutdown and poweron the
>> >> > machine.
>> >>
>> >> Basically it looks like the tree of data checksums isn't right. =A0=
Which
>> >> kernels were you running when you had these problems?
>> >
>> > Sorry, I mixed up this corruption with one farther down. =A0The sa=
me
>> > question stands though, this error generally means that IO either =
didn't
>> > happen or happened in the wrong place.
>> >
>> > So, the more details you can give about your config the easier it =
will
>> > be to nail it down.
>> >
>> > -chris
>> >
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
