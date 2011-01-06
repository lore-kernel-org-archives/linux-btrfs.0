From: Marcin Kuk <marcin.kuk@gmail.com>
Subject: Re: Synching a Backup Server
Date: Thu, 6 Jan 2011 20:34:39 +0100
Message-ID: <AANLkTi=-igY2M_UU+XYvOhqWG0Wj1X8dkttgBCvbOw+q@mail.gmail.com>
References: <201101060935.14059.CACook@quantum-sci.com>
	<AANLkTi=iWyKFOoaY6JjTuhg_0CyAtOh=s2gcBUuHGwau@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Carl Cook <CACook@quantum-sci.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=iWyKFOoaY6JjTuhg_0CyAtOh=s2gcBUuHGwau@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011/1/6 Freddie Cash <fjwcash@gmail.com>:
> On Thu, Jan 6, 2011 at 9:35 AM, Carl Cook <CACook@quantum-sci.com> wr=
ote:
>>
>> I am setting up a backup server for the garage, to back up my HTPC i=
n case of theft or fire. =A0The HTPC has a 4TB RAID10 array (mdadm, JFS=
), and will be connected to the backup server using GB ethernet. =A0The=
 backup server will have a 4TB BTRFS RAID0 array. =A0Debian Testing run=
ning on both.
>>
>> I want to keep a duplicate copy of the HTPC data, on the backup serv=
er, and I think a regular full file copy is not optimal and may take da=
ys to do. =A0So I'm looking for a way to sync the arrays at some interv=
al. =A0Ideally the sync would scan the HTPC with a CRC check to look fo=
r differences, copy over the differences, then email me on success.
>>
>> Is there a BTRFS tool that would do this?
>
> No, but there's a great tool called rsync that does exactly what you =
want. =A0:)
>
> This is (basically) the same setup we use at work to backup all our
> remote Linux/FreeBSD systems to a central backups server (although ou=
r
> server runs FreeBSD+ZFS).
>
> Just run rsync on the backup server, tell it to connect via ssh to th=
e
> remote server, and rsync / (root filesystem) into /backups/htpc/ (or
> whatever directory you want). =A0Use an exclude file to exclude the
> directories you don't want backed up (like /proc, /sys, /dev).
>
> If you are comfortable compiling software, then you should look into
> adding the HPN patches to OpenSSH, and enabling the None cipher. =A0T=
hat
> will give you 30-40% network throughput increase.
>
> After the rsync completes, snapshot the filesystem on the backup
> server, using the current date for the name.
>
> Then repeat the rsync process the next day, into the exact same
> directory. =A0Only files that have changed will be transferred. =A0Th=
en
> snapshot the filesystem using the current date.
>
> And repeat ad nauseum. =A0:)
>
> Some useful rsync options to read up on:
> =A0--hard-links
> =A0--numeric-ids
> =A0--delete-during
> =A0--delete-excluded
> =A0--archive
>
> The first time you run the rsync command, it will take awhile, as it
> transfers every file on the HTPC to the backups server. =A0However, y=
ou
> can stop and restart this process as many times as you like. =A0rsync
> will just pick up where it left off.
>
>> Also with this system, I'm concerned that if there is corruption on =
the HTPC, it could be propagated to the backup server. =A0Is there some=
 way to address this? =A0Longer intervals to sync, so I have a chance t=
o discover?
>
> Using snapshots on the backup server allows you to go back in time to
> recover files that may have been accidentally deleted, or to recover
> files that have been corrupted.
>
> Be sure to use rsync 3.x, as that will start transferring data a *lot=
*
> sooner, shortening the overall time needed for the sync. =A0rsync 2.x
> scans the entire remote filesystem first, builds a list of files, the=
n
> compares that list to the files on the backup server. =A0rsync 3.x sc=
ans
> a couple directories, then starts transferring data while scanning
> ahead.
>
> Once you have a working command-line for rsync, adding it to a script
> and then using cron to schedule it completes the setup.
>
> Works beautifully. =A0:) =A0Saved our bacon several times over the pa=
st 2 years.
> --
> Freddie Cash
> fjwcash@gmail.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Rsync is good, but not for all cases. Be aware of databases files -
you should do snapshot filesystem before rsyncing.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
