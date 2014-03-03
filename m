Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:45011 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbaCCFVt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Mar 2014 00:21:49 -0500
Date: Sun, 2 Mar 2014 21:21:47 -0800
From: Marc MERLIN <marc@merlins.org>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 3.14.0-rc3 btrfs scrub is preventing my laptop from going to
 sleep
Message-ID: <20140303052147.GB24835@merlins.org>
References: <20140227190656.GA28338@merlins.org>
 <530FE3CE.70809@cn.fujitsu.com>
 <20140301050937.GD18300@merlins.org>
 <20140301152235.GA26926@merlins.org>
 <5313F45F.9090709@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ew6BAiZeqk4r7MaW"
In-Reply-To: <5313F45F.9090709@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 03, 2014 at 11:17:51AM +0800, Wang Shilong wrote:
> Hi Marc,
> 
> On 03/01/2014 11:22 PM, Marc MERLIN wrote:
> >On Fri, Feb 28, 2014 at 09:09:37PM -0800, Marc MERLIN wrote:
> >>On Fri, Feb 28, 2014 at 09:18:06AM +0800, Wang Shilong wrote:
> >>>Could you run the following command when scrub is blocked, we can know more
> >>>why scrub is blocked here.
> >>>
> >>># echo w >  /proc/sysrq-trigger
> >>># dmesg
> >Yes, there you go:
> >
> >(attached because it's too big for the list)
> >
> >http://marc.merlins.org/tmp/btrfs_nofreeze.txt
> Could you please try the following patch, and let's see if it helps:
> 
> https://patchwork.kernel.org/patch/3680431/

I just applied your patch, along with the other btrfs send patch to
3.14.0-rc5

I didn't help with ACPI sleep. Do you have a laptop you can try this on?
It'll likely be faster than me doing this remotely :)

Here's the log of failure:
http://marc.merlins.org/tmp/btrfs_nofreeze2.txt
 
> This patch addressed a deadlock for device replace, but i guess scrub
> may also trigger this problem if there are errors related to the disk.

Hope the log above helps.
 
> BTW, is there  some errors related to scrub device, something like:
> 
> # btrfs device stat <device>

You mean this?
legolas:~# btrfs scrub stat /dev/mapper/cryptroot 
scrub status for 4850ee22-bf32-4131-a841-02abdb4a5ba6
	scrub started at Sun Mar  2 20:52:21 2014, running for 1587 seconds
	total bytes scrubbed: 298.96GiB with 1 errors
	error details: csum=1
	corrected errors: 0, uncorrectable errors: 1, unverified errors: 0

Yes, I know I have an error that will flush when the older snapshots
get rotated out.

I wrote a fancy cronjob that captures syslog errors as the scrub happens
and tells me which file(s) created the problem.

Anyway, scrub is working fine and helping out, except for preventing S3
sleep while it's running. If you can reproduce great, but if you need me
to try more patches, let me know and I'll be happy to help, even with
the delay.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=btrfs-scrub

#! /bin/bash

test -x /sbin/btrfs || exit 0

export PATH=/usr/local/bin:$PATH

# bash shortcut for `basename $0`
PROG=${0##*/}
lock=/var/run/$PROG

# shlock (from inn) does the right thing and grabs a lock for a dead process
# (it checks the PID in the lock file and if it's not there, it
# updates the PID with the value given to -p)
if ! shlock -p $$ -f $lock; then
    echo "$lock held, quitting" >&2
    exit
fi

if which on_ac_power >/dev/null 2>&1; then
    ON_BATTERY=0
    on_ac_power >/dev/null 2>&1 || ON_BATTERY=$?
    if [ "$ON_BATTERY" -eq 1 ]; then
	exit 0
    fi
fi

for btrfs in $(grep btrfs /proc/mounts | awk '{ print $1 }' | sort -u)
do
    logger "Starting scrub of $btrfs"
    tail -n 0 -f /var/log/syslog | grep "BTRFS: " | grep -Ev '(disk space caching is enabled|unlinked .* orphans|turning on discard|device label .* devid .* transid|enabling SSD mode|BTRFS: has skinny extents|BTRFS: device label)' &
    /sbin/btrfs scrub start -Bd $btrfs
    pkill -f 'tail -n 0 -f /var/log/syslog'
    logger "Ended scrub of $btrfs"
done

rm $lock


--ew6BAiZeqk4r7MaW--
