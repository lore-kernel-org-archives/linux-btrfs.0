From: Shyam Prasad N <nspmangalore@gmail.com>
Subject: Re: support for Oracle db consistent backups with btrfs snapshoting?
Date: Mon, 20 Feb 2012 20:59:23 +0530
Message-ID: <4F4266D3.10108@gmail.com>
References: <CANLWtDBALsG2S3u_HE21UxMXjUBPjNrEEtKAqR+_tFzPcG4WNQ@mail.gmail.com>
Reply-To: nspmangalore@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Andrew Henry <adhenry.9@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CANLWtDBALsG2S3u_HE21UxMXjUBPjNrEEtKAqR+_tFzPcG4WNQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/20/2012 07:49 PM, Andrew Henry wrote:
> Will there be support for consistent backups =C3=A1 la NetApp when us=
ing
> snapshots on btrfs filesystems that contain Oracle databases?
>
> Im not that familiar with NetApp, and don't know whether there needs
> to be "extra support" for the Oracle bits for their snapshoting to
> work, so please forgive me if this is a silly question.
>
> Andrew
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Hi Andrew,

I don't know how exactly oracle db implements consistent backups, but I=
=20
can imagine how.
Oracle db probably runs some sort of script after commit of a database=20
snapshot which commands NetApp filer to create a snapshot.
If that is so, I don't see the oracle/btrfs configuration to be much=20
different either. The oracle-side scripts can be made to run btrfs=20
snapshot creation commands in this case.

Hope that helps.

Thanks,
Shyam
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
