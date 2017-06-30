Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51246 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751695AbdF3PyR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Jun 2017 11:54:17 -0400
Date: Fri, 30 Jun 2017 17:53:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Sargun Dhillon <sargun@sargun.me>
Cc: linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com, mkh@rqc.ru
Subject: Re: [PATCH v2 4/4] btrfs: Add qgroup_auto_cleanup mount flag to
 automatically cleanup qgroups
Message-ID: <20170630155305.GW2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170526204414.GA18176@ircssh-2.c.rugged-nimbus-611.internal>
 <20170526204507.GA18221@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170526204507.GA18221@ircssh-2.c.rugged-nimbus-611.internal>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 26, 2017 at 08:45:08PM +0000, Sargun Dhillon wrote:
> This patch introduces a new mount option - qgroup_auto_cleanup.
> The purpose of this mount option is to cause btrfs to automatically
> delete qgroups on subvolume deletion. This only cleans up the
> associated level-0 qgroup, and not qgroups that are above it.
> 
> Since this behaviour is API-breaking, as people may already have scripts
> that do this cleanup on subvolume destruction, this feature, at least
> for now, must be opt-in.

I'd rather make the auto-cleaning default and I don't remember why this
wasn't actually done back then.

I don't like mount options for fine grained tuning of a filesystem, IMO
it's almost always the bad interface for that. But people propose
various mout options because it's easy to implement and test (known
interface, existing tools). Ok for testing and first draft but as it's
an interface that's supposed to be forever, it's good to take time to
think it through.

>From the API-breaking point you wrote above, sounds like switching
auto-cleaning on by default is not a good option.

The mount option is somehow persistent, ie. stored in a config file and
applied on mount. I was thinking about a sysfs tunable, this would
require a post-mount action, less comfort. Another option is to
add a new property for the filesystem. That would need some more
preparatory work though but I'd prefer this approach.
