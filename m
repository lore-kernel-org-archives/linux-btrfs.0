From: Mike Hommey <mh@glandium.org>
Subject: Re: Can you please define "snapshot" and "subvolume"?
Date: Thu, 7 Oct 2010 15:18:23 +0200
Message-ID: <20101007131823.GB1536@glandium.org>
References: <AANLkTimBsVGS=eJvpdf2Sq_Dg76zQRgy=E+3089zQ9D4@mail.gmail.com>
 <AANLkTikJ4Du-NjvvKo3_Nn00EWUekxn7xHJ-zpGZUfio@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Francis Galiegue <fgaliegue@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: =?iso-8859-15?B?Suly9G1l?= Poulin <jeromepoulin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikJ4Du-NjvvKo3_Nn00EWUekxn7xHJ-zpGZUfio@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 07, 2010 at 08:30:31AM -0400, J=E9r=F4me Poulin wrote:
> Just to tell you one of my use case, I do compilations of OpenWRT on =
a
> Btrfs filesystem, when I snapshot, I only snapshot the subvolume wher=
e
> all the sources are instead of the whole root filesystem, and when I
> need a snapshot of the root for backup purposes, only the root withou=
t
> all the snapshot (which are used to compile for different models of
> embedded devices) is snapshotted, which probably reduces the overhead
> (I can't tell for sure) and makes deletion instantaneous, the cleaner
> just wipes behind the subvolume remove command.

BTW, it would be very useful to be able to turn existing directories
into subvolumes.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
