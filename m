Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f181.google.com ([209.85.208.181]:41461 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725755AbeITFGS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 01:06:18 -0400
Received: by mail-lj1-f181.google.com with SMTP id y17-v6so6610605ljy.8
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2018 16:26:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAPd04b4nXw_qe7+8msY26UDr-m+MBpzYn_UdqGQX8Z-KxNN_0w@mail.gmail.com>
 <d502c26f-5270-a3f5-53c7-80f7f51bbe20@siedziba.pl> <b256bf67-74a9-cd74-9de5-ce7c56d7373a@petezilla.co.uk>
In-Reply-To: <b256bf67-74a9-cd74-9de5-ce7c56d7373a@petezilla.co.uk>
From: "James A. Robinson" <jim.robinson@gmail.com>
Date: Wed, 19 Sep 2018 16:25:22 -0700
Message-ID: <CAPd04b7H2wywUajtTTDF=FSBxcr1d1H48_htp8jaCeE+kJsvfQ@mail.gmail.com>
Subject: Re: state of btrfs snapshot limitations?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 19, 2018 at 4:04 PM Pete <pete@petezilla.co.uk> wrote:
> snapshots.  You need to delete it out of them as well which defeats the
> idea of read only snapshots if you are using them.

I wouldn't say it defeats the idea of read-only snapshots. If you want
to be able to "go back in time" and see what changed, you have to
pay the price, right?  At least until someone figures out a quantum
computer that can generate all possible states of data at once!

> I've since made /tmp a subvolume to prevent snap-shotting to partially
> mitigate this.  I'm wondering if I should make /lib/modules one for the
> same reason.  In previous posts on this mailing list people have

Yes, in my scheme I'm excluding things like tmp and the trash folder
when I populate the actual backup directory.

I decided on a 'opt-in' scheme where I have to specifically select
specific folders to send over to the backup server, rather than
attempt to track everything on disk.  Of course I am in danger
of missing an important directory and not realizing it until it's too
late.

> Now I've seen it I can't un-see it!

I think we should just redefine end-of-line to 0x00 to let him have
his 0x0a! :)

So with my scheme, similar to yours, I've got a bit of overlap in
that I take a snapshot under hourly as well as a daily snapshot,
but my hourly will rotate off at the end of the 24 hour period.

Here's an example list of the snapshots accumulated so far,
you can see that the positions change as time proceeds and
older snapshots are replaced with newer ones for the
hour and minute buckets.

$ sudo btrfs subvolume list /snapshot/
ID 259 gen 2271 top level 5 path c
ID 1024 gen 1064 top level 5 path d/2018/0915
ID 1106 gen 1216 top level 5 path d/2018/0916
ID 1227 gen 1435 top level 5 path d/2018/0917
ID 1348 gen 1681 top level 5 path d/2018/0918
ID 1566 gen 2017 top level 5 path h/1700
ID 1571 gen 2026 top level 5 path h/1800
ID 1576 gen 2035 top level 5 path h/1900
ID 1581 gen 2044 top level 5 path h/2000
ID 1586 gen 2053 top level 5 path h/2100
ID 1591 gen 2062 top level 5 path h/2200
ID 1596 gen 2071 top level 5 path h/2300
ID 1602 gen 2081 top level 5 path h/0000
ID 1607 gen 2090 top level 5 path h/0100
ID 1612 gen 2099 top level 5 path h/0200
ID 1617 gen 2108 top level 5 path h/0300
ID 1622 gen 2119 top level 5 path h/0400
ID 1627 gen 2133 top level 5 path h/0500
ID 1632 gen 2148 top level 5 path h/0600
ID 1637 gen 2159 top level 5 path h/0700
ID 1642 gen 2169 top level 5 path h/0800
ID 1648 gen 2182 top level 5 path h/0900
ID 1654 gen 2193 top level 5 path h/1000
ID 1660 gen 2203 top level 5 path h/1100
ID 1666 gen 2213 top level 5 path h/1200
ID 1672 gen 2224 top level 5 path h/1300
ID 1678 gen 2239 top level 5 path h/1400
ID 1684 gen 2253 top level 5 path h/1500
ID 1687 gen 2260 top level 5 path m/30
ID 1688 gen 2263 top level 5 path m/45
ID 1689 gen 2266 top level 5 path d/2018/0919
ID 1690 gen 2267 top level 5 path h/1600
ID 1691 gen 2268 top level 5 path m/00
ID 1692 gen 2271 top level 5 path m/15

The script as it currently stands:

#!/bin/bash
#
# snapshots - sync and snapshot at intervals
#
# this script is assumed to be run on a 15 minute cycle,
# at 00, 15, 30, and 45 minutes after the hour.  It will
# sync ${source} to ${volume}/c/ and then take
# snapshots:
#
# ${volume}/d/<yyyy>/<mm><dd>
# ${volume}/h/<hh><mm>
# ${volume}/m/<mm>
#
# The daily snapshot is taken when run at 00:00
# The hourly snapshot is taken when run at *:00 minutes.
# The minute snapshot is taken every time it is run.
#
# So the directory structure created under ${volume} will be:
#
#    c: the most recently synced data from /backup
#
#    d: a daily snapshot with the naming scheme yyyy/mmdd
#
#    h: an hourly snapshot with the naming scheme hhmm, note
#    that it is on a 24-hour cycle, so if it is currently 13:30 then
#    snapshots 0000 through 1300 are from today, and snapshots
#    1400 through 2300 are from yesterday.
#
#    m: a minute snapshot (00, 15, 30, 45), also on a cycle meaning
#    if it is 14:20 then 00 and 15 are for 14:00 and 14:15, and 30 and
#    45 are from 13:30 and 13:45.
#
umask 0077

# fully qualified path to backup
source="/backup/";

# btrfs volume where snapshots are managed
volume=/snapshot

# local lock dir / pid file
lockdir="/var/tmp/snapshots.lock";
pid="${lockdir}/pid";

# compute current year, month, day of the month, hour, and minute
t=($(/bin/date +"%Y %m %d %H %M"));
year=${t[0]};
month=${t[1]};
day=${t[2]};
hour=${t[3]};
min=${t[4]};

function unlock {
    rm -rf "${lockdir}"
}

# is another instance already running?
mkdir "${lockdir}" 2>/dev/null
if [ "$?" != "0" ]; then
    PID=$(/bin/cat "$pid");
    if /bin/kill -0 "$PID" >/dev/null 2>&1; then
        exit;
    fi
else
    trap unlock QUIT TERM EXIT INT
    echo "$$" > "${pid}";
fi

# if volume is not mounted, terminate
if ! /bin/mount | /bin/grep -q "${volume}"; then
    /bin/echo "$0: snapshot aborted, ${volume} is not mounted";
    exit;
fi

# update 'c' subvolume
if [ ! -d "${volume}/c" ]; then
    /bin/btrfs subvolume create "${volume}/c/" || exit;
fi

/usr/bin/rsync -a --delete --numeric-ids --relative --exclude
lost+found "${source}" "${volume}/c/" || exit;
/usr/bin/touch -t "${year}${month}${day}${hour}${min}" "${volume}/c" || exit;

# btrfs_snapshot takes a relative path under
# ${volume} and creates a snapshot of 'c'
# to that target, replacing any existing
# snapshot at that target.
function btrfs_snapshot() {
    target="${1}";

    # refuse to overwrite 'c' subvolume
    if [ "$target" = "c" ]; then
        echo "$0: snapshot terminated, invalid target 'c' specified";
        exit;
    fi

    # ensure the parent directory of the snapshot exists
    target_parent=$(dirname "${volume}/${target}");
    if [ ! -d "${target_parent}" ]; then
        /bin/mkdir -m 0755 -p "${target_parent}";
    fi

    # btfs subvolume commands don't seem to accept any sort of
    # quiet flags, so we will record output to a log file, then
    # grep for lines that do *not* match our expected output.
    log="/tmp/snapshots.btrfs.$$";

    # remove the destination snapshot if it already exists
    if [ -d "${volume}/${target}" ]; then
        /bin/btrfs subvolume delete "${volume}/${target}" > "${log}" 2>&1;
        rc=$?
        if test "$rc" != 0; then
            /bin/cat "${log}";
            /bin/rm -f "${log}";
            exit $rc;
        else
            if /bin/grep -qv '^Delete subvolume (no-commit): ' "${log}"; then
                /bin/cat "${log}";
                /bin/rm -f "${log}";
                exit;
            fi
        fi
    fi

    # create the current snapshot
    /bin/btrfs subvolume snapshot -r "${volume}/c"
"${volume}/${target}" > "${log}" 2>&1;
    rc=$?
    if test "$rc" != 0; then
        /bin/cat "${log}";
        /bin/rm -f "${log}";
        exit $rc;
    else
        if /bin/grep -qv '^Create a readonly snapshot of ' "${log}"; then
            /bin/cat "${log}";
            /bin/rm -f "${log}";
            exit;
        fi
    fi

    /bin/rm -f "${log}";
}

# create top-level snapshot directories
for v in m h d; do
    if [ ! -d "${volume}/${v}" ]; then
        /bin/mkdir -m 0755 "${volume}/${v}" || exit;
    fi
done;

# at midnight take a daily snapshot
if [ ! "${hour}" = "00" ]  && [ "${min}" = "00" ]; then
    btrfs_snapshot "d/${year}/${month}${day}";
fi

# at minute 00 take an hourly snapshot
if [ "${min}" = "00" ]; then
    btrfs_snapshot "h/${hour}${min}";
fi

# always take an minute snapshot
btrfs_snapshot "m/${min}";
