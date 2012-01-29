From: Nikolaus Rath <Nikolaus@rath.org>
Subject: Re: blocked tasks right after mounting
Date: Sat, 28 Jan 2012 23:07:20 -0500
Message-ID: <874nvff8xz.fsf@vostro.rath.org>
References: <874nvf50bm.fsf@vostro.rath.org> <87zkd73l6e.fsf@vostro.rath.org>
	<pan.2012.01.29.02.59.23@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.01.29.02.59.23@cox.net> (Duncan's message of "Sun, 29
	Jan 2012 02:59:23 +0000 (UTC)")
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan@cox.net> writes:
> Nikolaus Rath posted on Sat, 28 Jan 2012 10:23:53 -0500 as excerpted:
>
>> Nikolaus Rath <Nikolaus@rath.org> writes:
>>> Hello,
>>>
>>> When trying to rsync to btrfs, the process just hangs. dmesg output
>>> alternates between:
>> [...]
>>=20
>> I guess I should also mention that this is reproducible, and I don't
>> even need to run rsync. Simply mounting the file system produces a
>> similar warning soon afterwards:
>>=20
>> [  678.316046] usb 1-4: new high speed USB device number 7 using=20
> ehci_hcd
>
>> [  678.450429] scsi7 : usb-storage 1-4:1.0
>
>> [  681.659675] sd 7:0:0:0: [sdg] No Caching mode page present
>> [  681.659679] sd 7:0:0:0: [sdg] Assuming drive cache: write through
>
>> [  681.673562] sd 7:0:0:0: [sdg] Attached SCSI disk
>> [  791.512475] Btrfs loaded
>> [  791.513625] device label Videos devid 1 transid 142 /dev/mapper/
>> udisks-luks-uuid-7adf0c16-c741-485e-86dd-8a209fe4ce85-uid1000
>> [  791.567843] btrfs: disk space caching is enabled
>> [  960.456073] INFO: task sync:4930 blocked for more than 120 second=
s.
>
> Two points, based on the wiki at:  https://btrfs.wiki.kernel.org/
[...]
>
> You can also try mounting read-only, which I found mentioned as a hin=
t=20
> somewhere, as well, and there's a newer tool (that I don't see covere=
d on=20
> the wiki, I read about it elsewhere) that will often let you at least=
=20
> copy the data out of a bad btrfs partition, if it's necessary.  That=20
> might allow you to get the data off, at least, if you don't have prop=
er=20
> backups, which you DEFINITELY should have, given that btrfs is still=20
> experimental and under rapid development.

There's no important data on the drive, and I have no personal interest
in getting this to work or debugging it further. I just wanted to repor=
t
this in case someone else would like to figure out what might be going
on here (in which case I'd be willing to assist).

Sorry if my mail gave the wrong impression. I meant to offer help if
that's an unknown bug, I didn't mean to ask for help :-).

Best,

   -Nikolaus

--=20
 =C2=BBTime flies like an arrow, fruit flies like a Banana.=C2=AB

  PGP fingerprint: 5B93 61F8 4EA2 E279 ABF6  02CF A9AD B7F8 AE4E 425C
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
