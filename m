From: Christian Brunner <chb@muc.de>
Subject: Re: ceph on btrfs [was Re: ceph on non-btrfs file systems]
Date: Wed, 26 Oct 2011 10:12:41 +0200
Message-ID: <CAO47_--RTCNYP1s6O-jjjd_spT2=RrDJjBegd1S3YKz=on2YnQ@mail.gmail.com>
References: <CAO47_-9L7SdQwhJ27B6yzrqG8xvj+CeZHeSutgeCixcv7kUidg@mail.gmail.com>
	<Pine.LNX.4.64.1110252221510.6574@cobra.newdream.net>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1110252221510.6574@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

2011/10/26 Sage Weil <sage@newdream.net>:
> On Wed, 26 Oct 2011, Christian Brunner wrote:
>> >> > Christian, have you tweaked those settings in your ceph.conf? =A0=
It would be
>> >> > something like 'journal dio =3D false'. =A0If not, can you veri=
fy that
>> >> > directio shows true when the journal is initialized from your o=
sd log?
>> >> > E.g.,
>> >> >
>> >> > =A02011-10-21 15:21:02.026789 7ff7e5c54720 journal _open dev/os=
d0.journal fd 14: 104857600 bytes, block size 4096 bytes, directio =3D =
1
>> >> >
>> >> > If directio =3D 1 for you, something else funky is causing thos=
e
>> >> > blkdev_fsync's...
>> >>
>> >> I've looked it up in the logs - directio is 1:
>> >>
>> >> Oct 25 17:20:16 os00 osd.000[1696]: 7f0016841740 journal _open
>> >> /dev/vg01/lv_osd_journal_0 fd 15: 17179869184 bytes, block size 4=
096
>> >> bytes, directio =3D 1
>> >
>> > Do you mind capturing an strace? =A0I'd like to see where that blk=
dev_fsync
>> > is coming from.
>>
>> Here is an strace. I can see a lot of sync_file_range operations.
>
> Yeah, these all look like the flusher thread, and shouldn't be hittin=
g
> blkdev_fsync. =A0Can you confirm that with
>
> =A0 =A0 =A0 =A0filestore flusher =3D false
> =A0 =A0 =A0 =A0filestore sync flush =3D false
>
> you get no sync_file_range at all? =A0I wonder if this is also perf l=
ying
> about the call chain.

Yes, setting this makes the sync_file_range calls go away.

Is it safe to use these settings with "filestore btrfs snap =3D 0"?

Thanks,
Christian
--
To unsubscribe from this list: send the line "unsubscribe ceph-devel" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
