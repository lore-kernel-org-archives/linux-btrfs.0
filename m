From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: Synching a Backup Server
Date: Thu, 6 Jan 2011 12:13:22 -0800
Message-ID: <AANLkTimVFkAbnkd5BDavo6fDUJ1KcOVVC=6qA6nrkySx@mail.gmail.com>
References: <201101060935.14059.CACook@quantum-sci.com>
	<AANLkTi=iWyKFOoaY6JjTuhg_0CyAtOh=s2gcBUuHGwau@mail.gmail.com>
	<AANLkTik-rhXAHW18id4WMMtdqXkicvzTZ47+2r6YMuY0@mail.gmail.com>
	<AANLkTi=8zq-=ZG2sJBaV4JJbd-SnPpV3BQHg7dZA6Yoo@mail.gmail.com>
	<AANLkTimB8vLf3_apgFc1t=7xN5ab+Sw_u8Wp2NZL=xkd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Marcin Kuk <marcin.kuk@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: C Anthony Risinger <anthony@extof.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimB8vLf3_apgFc1t=7xN5ab+Sw_u8Wp2NZL=xkd@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 6, 2011 at 12:07 PM, C Anthony Risinger <anthony@extof.me> =
wrote:
> On Thu, Jan 6, 2011 at 1:47 PM, Freddie Cash <fjwcash@gmail.com> wrot=
e:
>> On Thu, Jan 6, 2011 at 11:33 AM, Marcin Kuk <marcin.kuk@gmail.com> w=
rote:
>>> Rsync is good, but not for all cases. Be aware of databases files -
>>> you should do snapshot filesystem before rsyncing.
>>
>> We script a dump of all databases before the rsync runs, so we get
>> both text and binary backups. =C2=A0If restoring the binary files do=
esn't
>> work, then we just suck in the text dumps.
>>
>> If the remote system supports snapshots, doing a snapshot before the
>> rsync runs is a good idea, though. =C2=A0It'll be nice when more
>> filesystems support in-line snapshots. =C2=A0The LVM method is pure =
crap.
>
> do you also use the --in-place option for rsync? =C2=A0i would think =
this
> is critical to getting the most out of "btrfs folding backups", ie.
> the most reuse between snapshots? =C2=A0im able to set this exact met=
hod up
> for my home network, thats why i ask... i have a central server that
> runs everything, and i want to sync a couple laptops and netbooks
> nightly, and a few specific directories whenever they change. =C2=A0b=
trfs
> on both ends.

Yes, we do use --inplace, forgot about that one.

=46ull rsync command used:
${rsync} ${rsync_options} \
    --exclude-from=3D"${defaultsdir}/${rsync_exclude}" ${rsync_exclude_=
server} \
    --rsync-path=3D"${rsync_path}" --rsh=3D"${ssh} -p ${rsync_port} -i
${defaultsdir}/${rsync_key}" \
    --log-file=3D"${logdir}/${rsync_server}.log" \
    ${rsync_user}@${rsync_server}:${basedir}/
${backupdir}/${sitedir}/${serverdir}/${basedir}/

Where rsync_options is:
--archive --delete-during --delete-excluded --hard-links --inplace
--numeric-ids --stats

> better yet, any chance you'd share some scripts? :-)

A description of what we use, including all scripts, is here:
http://forums.freebsd.org/showthread.php?t=3D11971

> as for the DB stuff, you definitely need to snapshot _before_ rsync. =
=C2=A0roughly:
>
> ) read lock and flush tables
> ) snapshot
> ) unlock tables
> ) mount snapshot
> ) rsync from snapshot

Unfortunately, we don't use btrfs or LVM on remote servers, so there's
no snapshotting available during the backup run.  In a perfect world,
btrfs would be production-ready, ZFS would be available on Linux, and
we'd no longer need the abomination called LVM.  :)

Until then, DB text dumps are our fall-back.  :)

--=20
=46reddie Cash
fjwcash@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
