Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50085 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964896AbcJGQyg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Oct 2016 12:54:36 -0400
Date: Fri, 7 Oct 2016 18:54:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Tim Small <tim@seoss.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Making statfs return qgroup info (for container use case etc.)
Message-ID: <20161007165434.GF11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <32dfef18-ca3b-6c29-252a-4fc9e36b373a@seoss.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <32dfef18-ca3b-6c29-252a-4fc9e36b373a@seoss.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 06, 2016 at 02:51:58PM +0100, Tim Small wrote:
> I use btrfs for containers (e.g. full OS style containers using lxc/lxd
> etc. rather than application containers).  btrfs de-duplication and
> send/receive are very useful features for this use-case.
> 
> Each container runs in its own subvolume, and I use quotas to stop one
> container exhausting the disk space of the others.
> 
> df shows the total space + free space for the entire filesystem - which
> is confusing for users within the containers.  Worse - they don't have
> any way of knowing how much quota they actually have left (other than du
> -xs / vs. whatever I've told them).
> 
> It'd be really nice if running e.g. statfs("/home", ...) within a
> container could be made to return the qgroup usage + limit for the path
> (e.g. by passing in an option at mount time - such as qgroup level
> maybe?) , instead of the global filesystem data in f_bfree f_blocks etc.

The container usecase will not go away anytime soon, and I think we can
implement the proposal.

Geting the limits of qgroup attached to a subvolume is lightweight
enough for the statfs call.  Statfs gets the dentry as a parameter, so
we can iterate up to the first subvolume which would be marked as "stop
here" and use the limits for statfs reporting. The remaining part is to
add a new ioctl to mark the subvolume 'stop here'.

For the first implementation, this would be just a runtime flag, ie.
manually set by the user. I'd need to check wheter the flag persistnce
would be ok.

> A useful tweak might be to only return the qgroup info within non-root
> user namespaces, or perhaps just if the root UID != 0 (since the normal
> use case for this is unprivileged containers), but I've no idea how
> viable that idea is.

I'm not sure if we should rely on an arbitrary UID to change the output.

> Yet another idea - (since btrfs always returns 0 for f_files - used for
> inodes by other FS), then perhaps having the option of returning quota
> information there would be useful (or maybe return quota referenced size
> info in f_blocks and f_bfree, and exclusive size info in f_files and
> f_free)?

That's a misuse, the programs reading df would special case to interpret
the values different from the documented meaning. But I think we can
avoid that.

> Googling shows that this question has come up briefly on the #btrfs IRC
> channel in the past.

Yeah, and by that time I didn't have an idea how to implement that.

> Does sound like something that could be added to btrfs?
> 
> What I need to do currently only works with zfs, but I don't really want
> to go there if I can avoid it...
> 
> ref:  search for btrfs in this web page:
> 
> https://www.stgraber.org/2016/03/26/lxd-2-0-resource-control-412/
> 
> ... the shown working example is on zfs...

Thanks for the link, that's actually useful as the usecase description.
