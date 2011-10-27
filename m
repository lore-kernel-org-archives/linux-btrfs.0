From: Stefan Majer <stefan.majer@gmail.com>
Subject: Re: ceph on btrfs [was Re: ceph on non-btrfs file systems]
Date: Thu, 27 Oct 2011 12:59:39 +0200
Message-ID: <CADdPHGtimucFn5k8A-RWDGYa-C3u7wB-bajxgT0LtiNH4HZ7=A@mail.gmail.com>
References: <4EA86FD7.4030407@tuxadero.com>
	<4EA93844.3010601@tuxadero.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Sage Weil <sage@newdream.net>, chb@muc.de,
	Josef Bacik <josef@redhat.com>, chris.mason@oracle.com
To: Martin Mailand <martin@tuxadero.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EA93844.3010601@tuxadero.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Martin,

a quick dig into your perf report show a large amount of swapper work.
If this is the case, i would suspect latency. So do you have not
enough physical ram in your machine ?

Greetings

Stefan Majer

On Thu, Oct 27, 2011 at 12:53 PM, Martin Mailand <martin@tuxadero.com> =
wrote:
> Hi
> resend without the perf attachment, which could be found here:
> http://tuxadero.com/multistorage/perf.report.txt.bz2
>
> Best Regards,
> =A0martin
>
> -------- Original-Nachricht --------
> Betreff: Re: ceph on btrfs [was Re: ceph on non-btrfs file systems]
> Datum: Wed, 26 Oct 2011 22:38:47 +0200
> Von: Martin Mailand <martin@tuxadero.com>
> Antwort an: martin@tuxadero.com
> An: Sage Weil <sage@newdream.net>
> Kopie (CC): Christian Brunner <chb@muc.de>, ceph-devel@vger.kernel.or=
g,
> =A0linux-btrfs@vger.kernel.org
>
> Hi,
> I have more or less the same setup as Christian and I suffer the same
> problems.
> But as far as I can see the output of latencytop and perf differs for=
m
> Christian one, both are attached.
> I was wondering about the high latency from btrfs-submit.
>
> Process btrfs-submit-0 (970) Total: 2123.5 msec
>
> I have as well the high IO rate and high IO wait.
>
> avg-cpu: =A0%user =A0 %nice %system %iowait =A0%steal =A0 %idle
> =A0 =A0 =A0 =A0 =A0 =A00.60 =A0 =A00.00 =A0 =A02.20 =A0 82.40 =A0 =A0=
0.00 =A0 14.80
>
> Device: =A0 =A0 =A0 =A0 rrqm/s =A0 wrqm/s =A0 =A0 r/s =A0 =A0 w/s =A0=
 =A0rkB/s =A0 =A0wkB/s
> avgrq-sz avgqu-sz =A0 await r_await w_await =A0svctm =A0%util
> sda =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.00 =A0 =A0 0.00 =A0 =A00.00 =A0 =A0=
8.40 =A0 =A0 0.00 =A0 =A074.40
> 17.71 =A0 =A0 0.03 =A0 =A03.81 =A0 =A00.00 =A0 =A03.81 =A0 3.81 =A0 3=
=2E20
> sdb =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.00 =A0 =A0 7.00 =A0 =A00.00 =A0269.=
80 =A0 =A0 0.00 =A01224.80
> 9.08 =A0 107.19 =A0398.69 =A0 =A00.00 =A0398.69 =A0 3.15 =A085.00
>
> top - 21:57:41 up =A08:41, =A01 user, =A0load average: 0.65, 0.79, 0.=
76
> Tasks: 179 total, =A0 1 running, 178 sleeping, =A0 0 stopped, =A0 0 z=
ombie
> Cpu(s): =A00.6%us, =A02.4%sy, =A00.0%ni, 70.8%id, 25.8%wa, =A00.0%hi,=
 =A00.3%si,
> 0.0%st
> Mem: =A0 4018276k total, =A01577728k used, =A02440548k free, =A0 =A01=
0496k buffers
> Swap: =A01998844k total, =A0 =A0 =A0 =A00k used, =A01998844k free, =A0=
1316696k cached
>
> =A0 PID USER =A0 =A0 =A0PR =A0NI =A0VIRT =A0RES =A0SHR S %CPU %MEM =A0=
 =A0TIME+ =A0COMMAND
>
> =A01399 root =A0 =A0 =A020 =A0 0 =A0548m 103m 3428 S =A00.0 =A02.6 =A0=
 2:01.85 ceph-osd
>
> =A01401 root =A0 =A0 =A020 =A0 0 =A0548m 103m 3428 S =A00.0 =A02.6 =A0=
 1:51.71 ceph-osd
>
> =A01400 root =A0 =A0 =A020 =A0 0 =A0548m 103m 3428 S =A00.0 =A02.6 =A0=
 1:50.30 ceph-osd
>
> =A01391 root =A0 =A0 =A020 =A0 0 =A0 =A0 0 =A0 =A00 =A0 =A00 S =A00.0=
 =A00.0 =A0 1:18.39
> btrfs-endio-wri
>
> =A0 976 root =A0 =A0 =A020 =A0 0 =A0 =A0 0 =A0 =A00 =A0 =A00 S =A00.0=
 =A00.0 =A0 1:18.11
> btrfs-endio-wri
>
> =A01367 root =A0 =A0 =A020 =A0 0 =A0 =A0 0 =A0 =A00 =A0 =A00 S =A00.0=
 =A00.0 =A0 1:05.60
> btrfs-worker-1
>
> =A0 968 root =A0 =A0 =A020 =A0 0 =A0 =A0 0 =A0 =A00 =A0 =A00 S =A00.0=
 =A00.0 =A0 1:05.45
> btrfs-worker-0
>
> =A01163 root =A0 =A0 =A020 =A0 0 =A0141m 1636 1100 S =A00.0 =A00.0 =A0=
 1:00.56 collectd
>
> =A0 970 root =A0 =A0 =A020 =A0 0 =A0 =A0 0 =A0 =A00 =A0 =A00 S =A00.0=
 =A00.0 =A0 0:47.73
> btrfs-submit-0
>
> =A01402 root =A0 =A0 =A020 =A0 0 =A0548m 103m 3428 S =A00.0 =A02.6 =A0=
 0:34.86 ceph-osd
>
> =A01392 root =A0 =A0 =A020 =A0 0 =A0 =A0 0 =A0 =A00 =A0 =A00 S =A00.0=
 =A00.0 =A0 0:33.70
> btrfs-endio-met
>
> =A0 975 root =A0 =A0 =A020 =A0 0 =A0 =A0 0 =A0 =A00 =A0 =A00 S =A00.0=
 =A00.0 =A0 0:32.70
> btrfs-endio-met
>
> =A01415 root =A0 =A0 =A020 =A0 0 =A0548m 103m 3428 S =A00.0 =A02.6 =A0=
 0:28.29 ceph-osd
>
> =A01414 root =A0 =A0 =A020 =A0 0 =A0548m 103m 3428 S =A00.0 =A02.6 =A0=
 0:28.24 ceph-osd
>
> =A01397 root =A0 =A0 =A020 =A0 0 =A0548m 103m 3428 S =A00.0 =A02.6 =A0=
 0:24.60 ceph-osd
>
> =A01436 root =A0 =A0 =A020 =A0 0 =A0548m 103m 3428 S =A00.0 =A02.6 =A0=
 0:13.31 ceph-osd
>
>
> Here ist my setup.
> Kernel v3.1 + Josef
>
> The config for this osd (ceph version 0.37
> (commit:a6f3bbb744a6faea95ae48317f0b838edb16a896)) is:
> [osd.1]
> =A0 =A0 =A0 =A0 host =3D s-brick-003
> =A0 =A0 =A0 =A0 osd journal =3D /dev/sda7
> =A0 =A0 =A0 =A0 btrfs devs =3D /dev/sdb
> =A0 =A0 =A0 =A0btrfs options =3D noatime
> =A0 =A0 =A0 =A0filestore_btrfs_snap =3D false
>
> I hope this helps to pin point the problem.
>
> Best Regards,
> martin
>
>
> Sage Weil schrieb:
>>
>> On Wed, 26 Oct 2011, Christian Brunner wrote:
>>>
>>> 2011/10/26 Sage Weil <sage@newdream.net>:
>>>>
>>>> On Wed, 26 Oct 2011, Christian Brunner wrote:
>>>>>>>>
>>>>>>>> Christian, have you tweaked those settings in your ceph.conf? =
=A0It
>>>>>>>> would be
>>>>>>>> something like 'journal dio =3D false'. =A0If not, can you ver=
ify that
>>>>>>>> directio shows true when the journal is initialized from your =
osd
>>>>>>>> log?
>>>>>>>> E.g.,
>>>>>>>>
>>>>>>>> =A02011-10-21 15:21:02.026789 7ff7e5c54720 journal _open
>>>>>>>> dev/osd0.journal fd 14: 104857600 bytes, block size 4096 bytes=
, directio =3D 1
>>>>>>>>
>>>>>>>> If directio =3D 1 for you, something else funky is causing tho=
se
>>>>>>>> blkdev_fsync's...
>>>>>>>
>>>>>>> I've looked it up in the logs - directio is 1:
>>>>>>>
>>>>>>> Oct 25 17:20:16 os00 osd.000[1696]: 7f0016841740 journal _open
>>>>>>> /dev/vg01/lv_osd_journal_0 fd 15: 17179869184 bytes, block size=
 4096
>>>>>>> bytes, directio =3D 1
>>>>>>
>>>>>> Do you mind capturing an strace? =A0I'd like to see where that
>>>>>> blkdev_fsync
>>>>>> is coming from.
>>>>>
>>>>> Here is an strace. I can see a lot of sync_file_range operations.
>>>>
>>>> Yeah, these all look like the flusher thread, and shouldn't be hit=
ting
>>>> blkdev_fsync. =A0Can you confirm that with
>>>>
>>>> =A0 =A0 =A0 filestore flusher =3D false
>>>> =A0 =A0 =A0 filestore sync flush =3D false
>>>>
>>>> you get no sync_file_range at all? =A0I wonder if this is also per=
f lying
>>>> about the call chain.
>>>
>>> Yes, setting this makes the sync_file_range calls go away.
>>
>> Okay. =A0That means either sync_file_range on a regular btrfs file i=
s
>> triggering blkdev_fsync somewhere in btrfs, there is an extremely sn=
eaky
>> bug that is mixing up file descriptors, or latencytop is lying. =A0I=
'm
>> guessing the latter, given the other weirdness Josef and Chris were
>> seeing. =A0:)
>>
>>> Is it safe to use these settings with "filestore btrfs snap =3D 0"?
>>
>> Yeah. =A0They're purely a performance thing to push as much dirty da=
ta to
>> disk as quickly as possible to minimize the snapshot create latency.
>> You'll notice the write throughput tends to tank when them off.
>>
>> sage
>
>



--=20
Stefan Majer
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
