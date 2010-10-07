From: Benjamin Griese <der.darude@gmail.com>
Subject: Re: Can you please define "snapshot" and "subvolume"?
Date: Thu, 7 Oct 2010 16:00:59 +0200
Message-ID: <AANLkTimg51BmZcY3MUneBYuFFTN8NWjuNM9561eB_5sk@mail.gmail.com>
References: <AANLkTimBsVGS=eJvpdf2Sq_Dg76zQRgy=E+3089zQ9D4@mail.gmail.com>
	<AANLkTikJ4Du-NjvvKo3_Nn00EWUekxn7xHJ-zpGZUfio@mail.gmail.com>
	<20101007131823.GB1536@glandium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>,
	Francis Galiegue <fgaliegue@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Mike Hommey <mh@glandium.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101007131823.GB1536@glandium.org>
List-ID: <linux-btrfs.vger.kernel.org>

+1 from me

On Thu, Oct 7, 2010 at 15:18, Mike Hommey <mh@glandium.org> wrote:
> On Thu, Oct 07, 2010 at 08:30:31AM -0400, J=E9r=F4me Poulin wrote:
>> Just to tell you one of my use case, I do compilations of OpenWRT on=
 a
>> Btrfs filesystem, when I snapshot, I only snapshot the subvolume whe=
re
>> all the sources are instead of the whole root filesystem, and when I
>> need a snapshot of the root for backup purposes, only the root witho=
ut
>> all the snapshot (which are used to compile for different models of
>> embedded devices) is snapshotted, which probably reduces the overhea=
d
>> (I can't tell for sure) and makes deletion instantaneous, the cleane=
r
>> just wipes behind the subvolume remove command.
>
> BTW, it would be very useful to be able to turn existing directories
> into subvolumes.
>
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
To be or not to be -- Shakespeare | To do is to be -- Nietzsche | To
be is to do -- Sartre | Do be do be do -- Sinatra
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
