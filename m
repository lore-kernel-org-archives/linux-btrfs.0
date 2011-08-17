From: "David Pottage" <david@electric-spoon.com>
Subject: Re: [RFC] btrfs auto snapshot
Date: Wed, 17 Aug 2011 14:23:32 +0100
Message-ID: <2084d6628f888144198ac8450b470b7c.squirrel@www.chrestomanci.org>
References: <4E4B2452.9070407@oracle.com> <4E4B88BA.4030603@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>,
	"Chris Mason" <chris.mason@oracle.com>
To: "Anand Jain" <Anand.Jain@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E4B88BA.4030603@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

> And a rough implementation design is here below. (As of now this does
> not include the GNOME integration since I have no idea how to do that).
>
> Further, implementation will contain 2 new files
> /etc/init.d/btrfs and /<path>/btrfs-auto-snapshot,
>
> any idea where does a file like btrfs-auto-snapshot should be placed
> (with its purpose as mentioned below).
[...]
> 2.
> Crontab: Upon start, crontab will be updated with something like the
> following.
>     every 15min `<path>/btrfs-auto-snapshot cleanup>`
>     every 15min `/<path>/btrfs-auto-snapshot 15min`
>     every hr   `/<path>/btrfs-auto-snapshot hr`
>     every day  `/<path>/btrfs-auto-snapshot day`
>     every month `/<path>/btrfs-auto-snapshot month`
>     every year  `/<path>/btrfs-auto-snapshot year`

I think that you need to be careful not to impose your idea of when to
take snapshots and how long to keep them onto the design. For example
why take snapshots every 15 minutes? Why not every 10 or every hour?

Why treat monthly snapshots as special when it does not fit into most
working weeks? would weekly be more logical? What about 2 weekly (When
I worked at Nokia, internal releases where done on Tuesday of each even
numbered week, so we would have wanted the snapshot taken on that day
to be retained longer than snapshots taken on other days, or Tuesdays
in odd numbered weeks.)

I think a more flexible design would be to allow the user to specify
(via a config file for each subvolume) a label for each type of snapshot
and how long to keep snapshots depending on when they are taken. This
can be done using syntax similar to crontab:

Example

# Format: <label> <crontab like fields> <retention time>

# Keep 15 min snapshots for 6 hours.
15_minute	*/15 * * * *	6 hour

# Keep hourly snapshots for 5 day
hourly		0 * * * *	5 day

# Keep daily snapshots for 21 days. Use the noon snapshot
daily		0 12 * * *	21 day

# Keep weekly snapshots for 6 months, Use the Tuesday snapshot
# TODO: we would need a week number field to specify even
#       numbered weeks only.
weekly		0 12 * * 2	6 mon

The btrfs-auto-snapshot script would need to make sure that the crontab
entry that takes snapshots runs frequently enough.

-- 
David Pottage

Error compiling committee.c To many arguments to function.

