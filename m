Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616Ab3FENgi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Jun 2013 09:36:38 -0400
Date: Wed, 5 Jun 2013 15:36:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Zach Brown <zab@redhat.com>, Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/6] fix INT_MAX readdir hang, plus cleanups
Message-ID: <20130605133636.GA18160@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1370384280-28652-1-git-send-email-zab@redhat.com>
 <20130604231653.4088.91500@localhost.localdomain>
 <20130604232657.GE24721@lenny.home.zabbo.net>
 <51AEA3A0.4050203@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51AEA3A0.4050203@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 05, 2013 at 10:34:08AM +0800, Miao Xie wrote:
> On 	tue, 4 Jun 2013 16:26:57 -0700, Zach Brown wrote:
> > On Tue, Jun 04, 2013 at 07:16:53PM -0400, Chris Mason wrote:
> >> Quoting Zach Brown (2013-06-04 18:17:54)
> >>> Hi gang,
> >>>
> >>> I finally sat down to fix that readdir hang that has been in the back
> >>> of my mind for a while.  I *hope* that the fix is pretty simple: just
> >>> don't manufacture a fake f_pos, I *think* we can abuse f_version as an
> >>> indicator that we shouldn't return entries.  Does this look reasonable?
> >>
> >> I like it, and it doesn't look too far away from how others are abusing
> >> f_version.  Have you tried with NFS?  I don't think it'll hurt, but NFS
> >> loves to surprise me.
> > 
> > Mm, no, I hadn't.  I'll give it a go tomorrow.  What could go wrong? :)
> 
> If we can not use f_version, we can use private_data. I think this variant is
> safe.

private_data is used within the ioctl user transactions, so a
readdir(mountpoint) with a user transaction running can break it.

david
