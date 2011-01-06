From: C Anthony Risinger <anthony@extof.me>
Subject: Re: Synching a Backup Server
Date: Thu, 6 Jan 2011 14:21:55 -0600
Message-ID: <AANLkTinZXirXQtd_Fd+AN+GbWbs0Wco7dxhEz+Cg6TjO@mail.gmail.com>
References: <201101060935.14059.CACook@quantum-sci.com>
	<AANLkTi=iWyKFOoaY6JjTuhg_0CyAtOh=s2gcBUuHGwau@mail.gmail.com>
	<AANLkTik-rhXAHW18id4WMMtdqXkicvzTZ47+2r6YMuY0@mail.gmail.com>
	<AANLkTi=8zq-=ZG2sJBaV4JJbd-SnPpV3BQHg7dZA6Yoo@mail.gmail.com>
	<AANLkTimB8vLf3_apgFc1t=7xN5ab+Sw_u8Wp2NZL=xkd@mail.gmail.com>
	<AANLkTimVFkAbnkd5BDavo6fDUJ1KcOVVC=6qA6nrkySx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Marcin Kuk <marcin.kuk@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Freddie Cash <fjwcash@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimVFkAbnkd5BDavo6fDUJ1KcOVVC=6qA6nrkySx@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 6, 2011 at 2:13 PM, Freddie Cash <fjwcash@gmail.com> wrote:
> On Thu, Jan 6, 2011 at 12:07 PM, C Anthony Risinger <anthony@extof.me=
> wrote:
>> On Thu, Jan 6, 2011 at 1:47 PM, Freddie Cash <fjwcash@gmail.com> wro=
te:
>>> On Thu, Jan 6, 2011 at 11:33 AM, Marcin Kuk <marcin.kuk@gmail.com> =
wrote:
>>>> Rsync is good, but not for all cases. Be aware of databases files =
-
>>>> you should do snapshot filesystem before rsyncing.
>>>
>>> We script a dump of all databases before the rsync runs, so we get
>>> both text and binary backups. =A0If restoring the binary files does=
n't
>>> work, then we just suck in the text dumps.
>>>
>>> If the remote system supports snapshots, doing a snapshot before th=
e
>>> rsync runs is a good idea, though. =A0It'll be nice when more
>>> filesystems support in-line snapshots. =A0The LVM method is pure cr=
ap.
>>
>> do you also use the --in-place option for rsync? =A0i would think th=
is
>> is critical to getting the most out of "btrfs folding backups", ie.
>> the most reuse between snapshots? =A0im able to set this exact metho=
d up
>> for my home network, thats why i ask... i have a central server that
>> runs everything, and i want to sync a couple laptops and netbooks
>> nightly, and a few specific directories whenever they change. =A0btr=
fs
>> on both ends.
>
> Yes, we do use --inplace, forgot about that one.
>
> Full rsync command used:
> ${rsync} ${rsync_options} \
> =A0 =A0--exclude-from=3D"${defaultsdir}/${rsync_exclude}" ${rsync_exc=
lude_server} \
> =A0 =A0--rsync-path=3D"${rsync_path}" --rsh=3D"${ssh} -p ${rsync_port=
} -i
> ${defaultsdir}/${rsync_key}" \
> =A0 =A0--log-file=3D"${logdir}/${rsync_server}.log" \
> =A0 =A0${rsync_user}@${rsync_server}:${basedir}/
> ${backupdir}/${sitedir}/${serverdir}/${basedir}/
>
> Where rsync_options is:
> --archive --delete-during --delete-excluded --hard-links --inplace
> --numeric-ids --stats
>
>> better yet, any chance you'd share some scripts? :-)
>
> A description of what we use, including all scripts, is here:
> http://forums.freebsd.org/showthread.php?t=3D11971

ah nice, i was hoping i didn't have to write it all myself; thanks!

>> as for the DB stuff, you definitely need to snapshot _before_ rsync.=
 =A0roughly:
>>
>> ) read lock and flush tables
>> ) snapshot
>> ) unlock tables
>> ) mount snapshot
>> ) rsync from snapshot
>
> Unfortunately, we don't use btrfs or LVM on remote servers, so there'=
s
> no snapshotting available during the backup run. =A0In a perfect worl=
d,
> btrfs would be production-ready, ZFS would be available on Linux, and
> we'd no longer need the abomination called LVM. =A0:)

heh, ain't 'dat the truth.

> Until then, DB text dumps are our fall-back. =A0:)

always good to have that contingency plan :-)

thanks again,

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
