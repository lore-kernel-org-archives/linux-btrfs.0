From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: Synching a Backup Server
Date: Thu, 6 Jan 2011 11:16:49 -0800
Message-ID: <AANLkTi=iWyKFOoaY6JjTuhg_0CyAtOh=s2gcBUuHGwau@mail.gmail.com>
References: <201101060935.14059.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Carl Cook <CACook@quantum-sci.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101060935.14059.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 6, 2011 at 9:35 AM, Carl Cook <CACook@quantum-sci.com> wrot=
e:
>
> I am setting up a backup server for the garage, to back up my HTPC in=
 case of theft or fire. =C2=A0The HTPC has a 4TB RAID10 array (mdadm, J=
=46S), and will be connected to the backup server using GB ethernet. =C2=
=A0The backup server will have a 4TB BTRFS RAID0 array. =C2=A0Debian Te=
sting running on both.
>
> I want to keep a duplicate copy of the HTPC data, on the backup serve=
r, and I think a regular full file copy is not optimal and may take day=
s to do. =C2=A0So I'm looking for a way to sync the arrays at some inte=
rval. =C2=A0Ideally the sync would scan the HTPC with a CRC check to lo=
ok for differences, copy over the differences, then email me on success=
=2E
>
> Is there a BTRFS tool that would do this?

No, but there's a great tool called rsync that does exactly what you wa=
nt.  :)

This is (basically) the same setup we use at work to backup all our
remote Linux/FreeBSD systems to a central backups server (although our
server runs FreeBSD+ZFS).

Just run rsync on the backup server, tell it to connect via ssh to the
remote server, and rsync / (root filesystem) into /backups/htpc/ (or
whatever directory you want).  Use an exclude file to exclude the
directories you don't want backed up (like /proc, /sys, /dev).

If you are comfortable compiling software, then you should look into
adding the HPN patches to OpenSSH, and enabling the None cipher.  That
will give you 30-40% network throughput increase.

After the rsync completes, snapshot the filesystem on the backup
server, using the current date for the name.

Then repeat the rsync process the next day, into the exact same
directory.  Only files that have changed will be transferred.  Then
snapshot the filesystem using the current date.

And repeat ad nauseum.  :)

Some useful rsync options to read up on:
  --hard-links
  --numeric-ids
  --delete-during
  --delete-excluded
  --archive

The first time you run the rsync command, it will take awhile, as it
transfers every file on the HTPC to the backups server.  However, you
can stop and restart this process as many times as you like.  rsync
will just pick up where it left off.

> Also with this system, I'm concerned that if there is corruption on t=
he HTPC, it could be propagated to the backup server. =C2=A0Is there so=
me way to address this? =C2=A0Longer intervals to sync, so I have a cha=
nce to discover?

Using snapshots on the backup server allows you to go back in time to
recover files that may have been accidentally deleted, or to recover
files that have been corrupted.

Be sure to use rsync 3.x, as that will start transferring data a *lot*
sooner, shortening the overall time needed for the sync.  rsync 2.x
scans the entire remote filesystem first, builds a list of files, then
compares that list to the files on the backup server.  rsync 3.x scans
a couple directories, then starts transferring data while scanning
ahead.

Once you have a working command-line for rsync, adding it to a script
and then using cron to schedule it completes the setup.

Works beautifully.  :)  Saved our bacon several times over the past 2 y=
ears.
--=20
=46reddie Cash
fjwcash@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
