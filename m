From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: Re: cannot resize (grow) fs
Date: Fri, 24 Sep 2010 07:58:38 +0000 (UTC)
Message-ID: <i7hlne$13j$2@dough.gmane.org>
References: <i7hdlm$13j$1@dough.gmane.org>
	<AANLkTiksuBxGMGuzgpx4eFeajhDRoGxwoodCdhCPr4q2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Sebastian 'gonX' Jensen, Fri, 24 Sep 2010 09:37:02 +0200:

> On 24 September 2010 07:41, Lubos Kolouch <lubos.kolouch@gmail.com>
> wrote:
>> Hello,
>>
>> I added disk to raid5 array on one of the backup hosts, running btrf=
s.
>>
>> So on /dev/md2 I have plenty of space now.
>>
>> However when I run
>>
>> btrfs filesystem resize max =C2=A0/dev/md2
>>
>> I get
>>
>> Resize '/dev/md2' of 'max'
>> ERROR: unable to resize '/dev/md2'
>>
>> The same result when I try resize +1g.
>>
>> strace gives me http://paste.pocoo.org/show/266523/
>>
>> Any ideas why and how can I extend the filesystem to fill the whole
>> volume?
>>
>> Thank you
>>
>> Lubos
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s"
>> in the body of a message to majordomo@vger.kernel.org More majordomo
>> info at =C2=A0http://vger.kernel.org/majordomo-info.html
>>
>>
> Hi Lubos,
>=20
> Firstly if I understood the documentation right, you have to specify =
the
> mount point rather than the drive itself. Secondly, I posted about th=
is
> issue a while ago. It seems that it will only extend the filesystem o=
n
> the hard drive that has devid 1. If you do not have any drives with
> devid 1 (e.g because you removed it), you can't resize your drive.
>=20
> I hope this is something that the btrfs developers will look into ASA=
P,
> because as it is now, resizing the FS on RAID arrays is impossible.
>=20
> Regards,
> Sebastian J.

Hi Sebastian

Thank you - unfortunately when I specify the mount point, the result is=
=20
the same.

The drive has devid 3, I was (forced by failure) playing with the drive=
s
quite a lot.

Seems like I am hitting all the nice issues with btrfs :)

Lubos

Lubos

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
