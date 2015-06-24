Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46788 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbbFXPt1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Jun 2015 11:49:27 -0400
Date: Wed, 24 Jun 2015 17:49:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: alias btrfs device delete to btrfs device
 remove
Message-ID: <20150624154925.GA726@suse.cz>
Reply-To: dsterba@suse.cz
References: <83c7d294299d9b66238f7369b1171c24d35b9294.1434508872.git.osandov@fb.com>
 <20150623154038.GK6761@twin.jikos.cz>
 <20150623213006.GA20385@huxley.DHCP.TheFacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150623213006.GA20385@huxley.DHCP.TheFacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 23, 2015 at 02:30:06PM -0700, Omar Sandoval wrote:
> > No need to introduce the wrappers, it's enough to add an alternative
> > usage string and the callback function will be the same. Also please
> > keep the aliased entries next to each other.
> 
> So the reason I did that way is that this:
> 
> static int cmd_rm_dev(int argc, char **argv)
> {
> 	char	*mntpnt;
> 	int	i, fdmnt, ret=0, e;
> 	DIR	*dirstream = NULL;
> 
> 	if (check_argc_min(argc, 3))
> 		usage(cmd_rm_dev_usage);
> 
> would use the same usage string for both commands. E.g., if you do
> "btrfs device delete", the usage string would say
> "btrfs device remove...". That's a small cosmetic issue, but what do you
> think?

Ah right, I forgot about the separate usage string. We'll have to pass
it to the callback somehow in general, as it is printed eg. in the
'default:' branch of the geopt switch loop. The alias wrappers are
probably inevitable:

{ "delete", cmd_device_delete, cmd_device_delete_usage, NULL, 0 },
{ "remove", cmd_device_remove, cmd_device_remove_usage, NULL, 0 },

int cmd_device_delete(int argc, char **argv) {
	return _cmd_device_delete(argc, argv, cmd_device_delete_usage);
}

int cmd_device_remove(int argc, char **argv) {
	return _cmd_device_delete(argc, argv, cmd_device_remove_usage);
}

This follows a pattern so we can add a macro wrapper eventually if this
proves to be the best option.
