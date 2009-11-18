From: Roland Dreier <rdreier@cisco.com>
Subject: Re: UI issues around RAID1
Date: Wed, 18 Nov 2009 09:54:28 -0800
Message-ID: <adar5rvafcb.fsf@roland-alpha.cisco.com>
References: <adapr7ib96f.fsf@roland-alpha.cisco.com>
	<20091116202043.GA9779@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091116202043.GA9779@localhost.localdomain> (Josef Bacik's
	message of "Mon, 16 Nov 2009 15:20:43 -0500")
List-ID: <linux-btrfs.vger.kernel.org>


 > >  - Unless I'm missing something, there doesn't seem to be any way later
 > >    on to see that I set the data policy to raid1, except using
 > >    btrfs-dump-tree and checking the flags bits for the appropriate
 > >    group.  Which can make things confusing if I have a bunch of btrfs
 > >    filesystems around.

 > You aren't missing anything, theres just nothing that spits that information out
 > yet.  btrfs-show would probably be a good place to do this.

Thanks.  I'll look at adding in show more info about RAID policy to the
btrfs-show output.

 - R.
