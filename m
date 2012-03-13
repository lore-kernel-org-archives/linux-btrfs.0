From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: immutable (WORM) file system
Date: Tue, 13 Mar 2012 00:09:08 +0000 (UTC)
Message-ID: <pan.2012.03.13.00.09.08@cox.net>
References: <CAP7LQsLiDC8Y=g+ocQGYdC-4LdpDWs9QkL+PvMD311wR2UY0GQ@mail.gmail.com>
	<CAAE6i0j4n9_7=swv8NJE1FVToXjPCefT+NtSbbaShs6UBKVQjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Chester posted on Mon, 12 Mar 2012 14:52:47 -0500 as excerpted:

> On Mon, Mar 12, 2012 at 2:36 PM, Fong Vang <sudoyang@gmail.com> wrote=
:
>> Does anyone know if there's a plan to provide an option to make a BT=
RFS
>> filesystem a WORM (write-one-read-many)? =C2=A0So essentially, once =
a file
>> has been written it cannot be altered nor deleted. =C2=A0To delete w=
ould
>> require a newfs. =C2=A0I know that there's extended attributes but r=
oot can
>> alter that on individual files.
>>
>> Anyway, thanks in advance for any help.

> There's support for Read-only snapshots, so you might be able to use
> that with some clever scripting =3D\

[Quote rearranged into standard contextual quote and reply order.]

If I'm reading between the lines correctly, that's not going to suffice=
=2E =20
It sounds to me like the request is for an indelible/immutable journal,=
=20
potentially backed by a legal requirement.

Think (US) SOX, Sarbanes-Oxley, requirements, or similar elsewhere.  Or=
=20
consider a criminal computer-related case where an investigator's every=
=20
action while analyzing a suspect's drive is write-once recorded, creati=
ng=20
a permanent record to be used in court.  Or for that matter, consider t=
he=20
audit trail of an electronic voting machine.

In such cases an indelible log that cannot be altered without destructi=
on=20
is vital.

--=20
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
