Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59983 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724AbbDNPHp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Apr 2015 11:07:45 -0400
Date: Tue, 14 Apr 2015 17:07:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Omar Sandoval <osandov@osandov.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/6] Btrfs: fail on mismatched subvol and subvolid
 mount options
Message-ID: <20150414150743.GR25622@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1428614837.git.osandov@osandov.com>
 <40c40f7f26acb30eea471b8c7b7bc01cce74be4d.1428614837.git.osandov@osandov.com>
 <55271BD9.7020903@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55271BD9.7020903@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 10, 2015 at 08:39:53AM +0800, Qu Wenruo wrote:
> > There's nothing to stop a user from passing both subvol= and subvolid=
> > to mount, but if they don't refer to the same subvolume, someone is
> > going to be surprised at some point. Error out on this case, but allow
> > users to pass in both if they do match (which they could, for example,
> > get out of /proc/mounts).
> Not sure should we do this extra check, as later mount options override 
> previous mount option.
> 
> I previous tried to do such thing for mount option like inode/noinode, 
> but was rejected for that reason.

Do you have a link to the discussion?

> So not sure such error-out behavior is OK or not.
> Maybe only taking the latest subvol/subvolid is a better choice?

If not sure, follow the principle of least surprise. If both subvolid
and subvol are passed and match then it's IMHO ok, no matter if the
options match "by accident" or intentionally. Eg. copy&paste from
/proc/mounts should work.

If the options do not match we can't decide which one is the right one.
The surprise would come if the user wants one (eg. subvolid) but the
other one would be applied in the end (subvol).
