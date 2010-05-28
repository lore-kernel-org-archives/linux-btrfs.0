From: trentbuck@gmail.com (Trent W. Buck)
Subject: Re: btrfsck: doesn't correct errors
Date: Fri, 28 May 2010 11:57:49 +1000
Message-ID: <87iq68n5ya.fsf@cybersource.com.au>
References: <201005271846.16832@fortytwo.ch>
	<20100527181553.GF25333@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik <josef@redhat.com> writes:

>> a btrfsck run on a 2T volume [with] 512M ram got [OOM killed].
>
> Yes, btrfsck keeps the entire extent tree in memory, so the bigger the
> fs, the more RAM it's going to use.

Is that an inherent property of btrfsck, or do you intend to address it
sometime before btrfs is labelled "production ready"?

