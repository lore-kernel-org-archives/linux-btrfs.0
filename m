Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39042 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754956AbbFWVaV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jun 2015 17:30:21 -0400
Date: Tue, 23 Jun 2015 14:30:06 -0700
From: Omar Sandoval <osandov@fb.com>
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: alias btrfs device delete to btrfs device
 remove
Message-ID: <20150623213006.GA20385@huxley.DHCP.TheFacebook.com>
References: <83c7d294299d9b66238f7369b1171c24d35b9294.1434508872.git.osandov@fb.com>
 <20150623154038.GK6761@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20150623154038.GK6761@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 23, 2015 at 05:40:39PM +0200, David Sterba wrote:
> On Thu, Jun 18, 2015 at 03:07:09PM -0700, Omar Sandoval wrote:
> > @@ -586,12 +606,13 @@ out:
> >  const struct cmd_group device_cmd_group = {
> >  	device_cmd_group_usage, NULL, {
> >  		{ "add", cmd_add_dev, cmd_add_dev_usage, NULL, 0 },
> > -		{ "delete", cmd_rm_dev, cmd_rm_dev_usage, NULL, 0 },
> > +		{ "remove", cmd_rm_dev, cmd_rm_dev_usage, NULL, 0 },
> >  		{ "scan", cmd_scan_dev, cmd_scan_dev_usage, NULL, 0 },
> >  		{ "ready", cmd_ready_dev, cmd_ready_dev_usage, NULL, 0 },
> >  		{ "stats", cmd_dev_stats, cmd_dev_stats_usage, NULL, 0 },
> >  		{ "usage", cmd_device_usage,
> >  			cmd_device_usage_usage, NULL, 0 },
> > +		{ "delete", cmd_del_dev, cmd_del_dev_usage, NULL, 0 },
> 
> No need to introduce the wrappers, it's enough to add an alternative
> usage string and the callback function will be the same. Also please
> keep the aliased entries next to each other.

So the reason I did that way is that this:

static int cmd_rm_dev(int argc, char **argv)
{
	char	*mntpnt;
	int	i, fdmnt, ret=0, e;
	DIR	*dirstream = NULL;

	if (check_argc_min(argc, 3))
		usage(cmd_rm_dev_usage);

would use the same usage string for both commands. E.g., if you do
"btrfs device delete", the usage string would say
"btrfs device remove...". That's a small cosmetic issue, but what do you
think?

> Suggestion for separate change: redefine the last argument (currently to
> denote hidden commands) to be a flag set and add a new one for aliases.
> That way we can automatically generate a compact help. Currently, the
> device section looks like this:
> 
>     btrfs device add [options] <device> [<device>...] <path>
>         Add a device to a filesystem
>     btrfs device remove <device> [<device>...] <path>
>         Remove a device from a filesystem
>     btrfs device scan [(-d|--all-devices)|<device> [<device>...]]
>         Scan devices for a btrfs filesystem
>     btrfs device ready <device>
>         Check device to see if it has all of its devices in cache for mounting
>     btrfs device stats [-z] <path>|<device>
>         Show current device IO stats. -z to reset stats afterwards.
>     btrfs device usage [options] <path> [<path>..]
>         Show detailed information about internal allocations in devices.
>     btrfs device delete <device> [<device>...] <path>
>         Remove a device from a filesystem (alias of remove)
> 
> For the first version it could be simply the first line of the usage string:
> 
>     btrfs device add [options] <device> [<device>...] <path>
>         Add a device to a filesystem
>     btrfs device delete <device> [<device>...] <path>
>     btrfs device remove <device> [<device>...] <path>
>         Remove a device from a filesystem
>     btrfs device scan [(-d|--all-devices)|<device> [<device>...]]
>         Scan devices for a btrfs filesystem
>     btrfs device ready <device>
>         Check device to see if it has all of its devices in cache for mounting
>     btrfs device stats [-z] <path>|<device>
>         Show current device IO stats. -z to reset stats afterwards.
>     btrfs device usage [options] <path> [<path>..]
>         Show detailed information about internal allocations in devices.
>         Remove a device from a filesystem (alias of remove)

Cool, that sounds like a good idea.

Thanks!
-- 
Omar
