From: Dongjun Shin <djshin90@gmail.com>
Subject: Re: ssd optimised mode
Date: Tue, 24 Feb 2009 13:09:21 +0900
Message-ID: <7fe698080902232009j20cd5b5eu8fa1a4a1d83a4f17@mail.gmail.com>
References: <934e480c0902200326m7647d87cq28bfa1675ef012f4@mail.gmail.com>
	 <20090220160134.GE24890@unused.rdu.redhat.com>
	 <1235147425.13249.16.camel@think.oraclecorp.com>
	 <3a7f57190902211707h37ff1478vdc0e5ffff66fa4da@mail.gmail.com>
	 <1235399593.11205.15.camel@think.oraclecorp.com>
	 <3a7f57190902231616h15578ceal968c190b10a40157@mail.gmail.com>
	 <yq1prh8sgxt.fsf@sermon.lab.mkp.net>
	 <3a7f57190902231953p1cf0be4aq911f065a74048b0c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Dmitri Nikulin <dnikulin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3a7f57190902231953p1cf0be4aq911f065a74048b0c@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 24, 2009 at 12:53 PM, Dmitri Nikulin <dnikulin@gmail.com> w=
rote:
> On Tue, Feb 24, 2009 at 1:32 PM, Martin K. Petersen
> <martin.petersen@oracle.com> wrote:
>>>>>>> "Dmitri" =3D=3D Dmitri Nikulin <dnikulin@gmail.com> writes:
>>
>> Dmitri> Already SanDisk are offering a proprietary "Extreme FFS"
>> Dmitri> (perhaps even based on Unix FFS) for Windows Vista only.
>>
>> Extreme FFS is SanDisk's next generation FTL/firmware. =A0It's not a
>> filesystem that plugs into the OS.
>
> If that's the case, why is it marketed for Windows Vista only, and
> referring to filesystem features like marking unused blocks? Surely i=
f
> it was at the device level it would be OS-neutral, and marketed as
> such.
>

It's marketed for Windows 7 and Windows 7 has feature that send down
trim/discard info to the storage.

Anyway, Linux support for trim is under way [1].

--=20
Dongjun

[1] http://git.kernel.org/?p=3Dlinux/kernel/git/willy/ssd.git;a=3Dshort=
log;h=3Dtrim-20090212
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
