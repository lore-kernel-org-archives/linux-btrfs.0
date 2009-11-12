From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: btrfsck: checksum verify failed
Date: Fri, 13 Nov 2009 00:44:47 +0300
Message-ID: <a4423d670911121344k4b2fbc5j165525602f801aa4@mail.gmail.com>
References: <a4423d670911111808i3affd6d4q4aa14c6086d9c28f@mail.gmail.com>
	 <20091112140233.GB5211@think>
	 <a4423d670911120616k2538809erc006c26fe86eb14d@mail.gmail.com>
	 <20091112145051.GB3196@think>
	 <a4423d670911120743o3759d594v533bc6ff8cdedd9@mail.gmail.com>
	 <20091112172502.GA2811@think>
	 <a4423d670911120941x47ca35e7l661e13861dba750e@mail.gmail.com>
	 <20091112200349.GB2811@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Chris Mason <chris.mason@oracle.com>,
	Alexander Beregalov <a.beregalov@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091112200349.GB2811@think>
List-ID: <linux-btrfs.vger.kernel.org>

2009/11/12 Chris Mason <chris.mason@oracle.com>:
> On Thu, Nov 12, 2009 at 08:41:44PM +0300, Alexander Beregalov wrote:
>> 2009/11/12 Chris Mason <chris.mason@oracle.com>:
>> > On Thu, Nov 12, 2009 at 06:43:00PM +0300, Alexander Beregalov wrot=
e:
>> >> 2009/11/12 Chris Mason <chris.mason@oracle.com>:
>> >> > On Thu, Nov 12, 2009 at 05:16:34PM +0300, Alexander Beregalov w=
rote:
>> >> >> 2009/11/12 Chris Mason <chris.mason@oracle.com>:
>> >> >> > On Thu, Nov 12, 2009 at 05:08:53AM +0300, Alexander Beregalo=
v wrote:
>> >> >> >> # for i in `seq 1 20`; do btrfsck /dev/sde|grep "checksum v=
erify
>> >> >> >> failed";echo; done
>> >> >> >> checksum verify failed on 31945617408 wanted 6607632D found=
 9CC3ED0
>> >> >> >> checksum verify failed on 31945617408 wanted 6607632D found=
 AFBBF41
>> >> >> >
>> >> >> > Was your filesystem mounted at the time? =C2=A0It's strange =
that the checksum
>> >> >> > keeps changing, that points to the data in the block changin=
g.
>> >> >>
>> >> >> It was not.
>> >> >> Any tips how I can try to find a root cause?
>> >> >> It is raid0 of two disks.
>> >> >
>> >> > Well, I'd start by looking for anything else that could be touc=
hing the
>> >> > FS or the devices. =C2=A0You shouldn't see more than two differ=
ent csums in this
>> >> > configuration (one from each disk).
>> >> I always see only these two blocks in output.
>> >
>> > The wanted is always the same but the found is always different?
>>
>> Yes, exactly. The bits marked as X look as random.
>
> Ok, I've added a new tool to the btrfs-unstable-progs repo. =C2=A0It =
is
> called btrfs-map-logical and it will print the logical->physical mapp=
ing
> for any metadata or data block in the FS. =C2=A0The FS should not be =
mounted
> when you run this program...it'll mostly work mounted but the results
> won't be 100% accurate.
>
> For your case:
>
> btrfs-map-logical -l 31945617408 -c 1 -o mirror1 /dev/sde
> btrfs-map-logical -l 31945617408 -c 2 -o mirror2 /dev/sde
>
> This will print to the screen the mappings for that block and also sa=
ve
> the contents of the first mirror of the block to a file called mirror=
1.
> The second command will save the contents of the second mirror.
>
> If the FS isn't mounted and isn't being changed by someone else, you
> should get exactly the same mappings every time and exactly the same
> contents in the files mirror1 and mirror2 every time.
>
> Just let me know if you have any problems. =C2=A0The most recent comm=
it in
> the btrfs-progs repo is:
>
> commit ab8fb4c99516c186641bda1dbc0e788f68b4dc77
> Author: Chris Mason <chris.mason@oracle.com>
> Date: =C2=A0 Thu Nov 12 14:34:09 2009 -0500
>
> =C2=A0 =C2=A0Add btrfs-map-logical program to map and read logical bl=
ock numbers
>
> If you check kernel.org and this commit isn't there, just try again ;=
)
> The mirror takes a few minutes to update. =C2=A0I'm pretty sure it go=
es
> faster if you hit reload over and over again, but that's just a guess=
=2E
>
> -chris
>

sh-4.0$  sudo ./btrfs-map-logical -l 31945617408 -c 1 -o /tmp/mirror1
/dev/sde; md5sum /tmp/mirror1
mirror 1 logical 31945617408 physical 16913231872 device /dev/sde
mirror 2 logical 31945617408 physical 16893308928 device /dev/sdf
bcce5ab8cc65c948650376e936952547  /tmp/mirror1

sh-4.0$  sudo ./btrfs-map-logical -l 31945617408 -c 2 -o /tmp/mirror2
/dev/sde; md5sum /tmp/mirror2
mirror 1 logical 31945617408 physical 16913231872 device /dev/sde
mirror 2 logical 31945617408 physical 16893308928 device /dev/sdf
347034331d8879096e262a736fd02ba0  /tmp/mirror2

sh-4.0$  sudo ./btrfs-map-logical -l 31945617408 -c 1 -o /tmp/mirror1
/dev/sde; md5sum /tmp/mirror1
mirror 1 logical 31945617408 physical 16913231872 device /dev/sde
mirror 2 logical 31945617408 physical 16893308928 device /dev/sdf
bcce5ab8cc65c948650376e936952547  /tmp/mirror1

sh-4.0$  sudo ./btrfs-map-logical -l 31945617408 -c 2 -o /tmp/mirror2
/dev/sde; md5sum /tmp/mirror2
mirror 1 logical 31945617408 physical 16913231872 device /dev/sde
mirror 2 logical 31945617408 physical 16893308928 device /dev/sdf
347034331d8879096e262a736fd02ba0  /tmp/mirror2

Does that mean that the problem is not in FS and I need to check
discs, IO controller, memory.

The same result with mount FS, but when I unmounted it there was a bug:

BUG: unable to handle kernel paging request at 6b6b6c9f
IP: [<f9a3c696>] caching_kthread+0x286/0x410 [btrfs]
*pde =3D 00000000
Oops: 0002 [#1]
last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed
Modules linked in: hwmon_vid btrfs zlib_deflate zlib_inflate sata_sil
i2c_nforce2

Pid: 15258, comm: btrfs-cache-311 Not tainted (2.6.32-rc6-00346-gaa021b=
a #4)
EIP: 0060:[<f9a3c696>] EFLAGS: 00010286 CPU: 0
EIP is at caching_kthread+0x286/0x410 [btrfs]
EAX: 6b6b6b6b EBX: f6f9e098 ECX: 0000000e EDX: effc5f00
ESI: f4d95ab0 EDI: f26f4000 EBP: e84e7f98 ESP: e84e7f20
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process btrfs-cache-311 (pid: 15258, ti=3De84e6000 task=3Df6450000 task=
=2Eti=3De84e6000)
Stack:
 00000000 ffffffff 81c00000 00000007 4324c000 effc5508 effc54b8 f26f5bd=
0
<0> f62c20c0 000b6000 00000000 effc54b0 ffffffff ffffffff 00000032 e7b1=
4678
<0> f26f4000 f4d95ab0 c0007f98 00074324 00a80000 00000010 00000000 0743=
24d0
Call Trace:
 [<f9a3c410>] ? caching_kthread+0x0/0x410 [btrfs]
 [<c103ce4c>] ? kthread+0x6c/0x80
 [<c103cde0>] ? kthread+0x0/0x80
 [<c1003513>] ? kernel_thread_helper+0x7/0x14
Code: c7 8b 45 9c b9 01 00 00 00 ba 03 00 00 00 c7 04 24 00 00 00 00
e8 fb 4d 5e c7 8b 45 b4 e8 53 d5 ff ff 8b 75 cc 8b 86 a0 00 00 00 <ff>
88 34 01 00 00 31 c0 83 c4 6c 5b 5e 5f c9 c3 66 90 77 09 3b
EIP: [<f9a3c696>] caching_kthread+0x286/0x410 [btrfs] SS:ESP 0068:e84e7=
f20
CR2: 000000006b6b6c9f
---[ end trace 72d6516d4c697ae6 ]---
device: 'btrfs-4': device_unregister
device: 'btrfs-4': device_create_release
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
