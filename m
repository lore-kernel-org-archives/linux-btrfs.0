From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: support for Oracle db consistent backups with btrfs snapshoting?
Date: Mon, 20 Feb 2012 19:48:42 +0100
Message-ID: <4F42958A.3080704@gmail.com>
References: <CANLWtDBALsG2S3u_HE21UxMXjUBPjNrEEtKAqR+_tFzPcG4WNQ@mail.gmail.com> <4F4266D3.10108@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: Andrew Henry <adhenry.9@gmail.com>, linux-btrfs@vger.kernel.org
To: nspmangalore@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F4266D3.10108@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm no NetApp expert, but as far as I know they have their own piece of=
=20
software which integrates their snapshots with oracle.

Creating consistent backups of a database isn't a problem that a=20
filesystem should solve at all. A simple approach for your problem woul=
d=20
be "Put DB in hot backup mode and then create a snapshot". I'm not sure=
=20
if there is a way to integrate RMAN backups with btrfs snapshots. Maybe=
=20
an oracle expert could help out.

Kind regards,
=46elix Blanke

On 2/20/12 4:29 PM, Shyam Prasad N wrote:
> On 02/20/2012 07:49 PM, Andrew Henry wrote:
>> Will there be support for consistent backups =C3=A1 la NetApp when u=
sing
>> snapshots on btrfs filesystems that contain Oracle databases?
>>
>> Im not that familiar with NetApp, and don't know whether there needs
>> to be "extra support" for the Oracle bits for their snapshoting to
>> work, so please forgive me if this is a silly question.
>>
>> Andrew
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Hi Andrew,
>
> I don't know how exactly oracle db implements consistent backups, but=
 I
> can imagine how.
> Oracle db probably runs some sort of script after commit of a databas=
e
> snapshot which commands NetApp filer to create a snapshot.
> If that is so, I don't see the oracle/btrfs configuration to be much
> different either. The oracle-side scripts can be made to run btrfs
> snapshot creation commands in this case.
>
> Hope that helps.
>
> Thanks,
> Shyam
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
