From: James Cloos <cloos@jhcloos.com>
Subject: Df [Was: Re: Issues when volume is full]
Date: Thu, 04 Mar 2010 16:51:16 -0500
Message-ID: <m31vfziwlv.fsf_-_@lugabout.jhcloos.org>
References: <c5b98f841003041258u720a2b0dwe7e02254e2ca617b@mail.gmail.com>
	<20100304211009.GB8678@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>,
	Robert LeBlanc <robert@leblancnet.us>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100304211009.GB8678@localhost.localdomain> (Josef Bacik's
	message of "Thu, 4 Mar 2010 16:10:09 -0500")
List-ID: <linux-btrfs.vger.kernel.org>

>>>>> "J" == Josef Bacik <josef@redhat.com> writes:

J> Yeah this is an unfortunate side-affect of how we currently do df.

Speaking of that, it would be cool were df -i to be enabled.  Fs's like
xfs, AIUI, which have fully dynamic inode allocation just use the number
of blocks as the max possible number of inodes.  Reporting that and
iused would be helpful.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
