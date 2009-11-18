From: Roland Dreier <rdreier@cisco.com>
Subject: Re: UI issues around RAID1
Date: Wed, 18 Nov 2009 09:59:24 -0800
Message-ID: <adamy2jaf43.fsf@roland-alpha.cisco.com>
References: <adapr7ib96f.fsf@roland-alpha.cisco.com>
	<20091116202043.GA9779@localhost.localdomain>
	<4B01C8AF.5040308@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B01C8AF.5040308@hp.com> (jim owens's message of "Mon, 16 Nov
	2009 16:48:31 -0500")
List-ID: <linux-btrfs.vger.kernel.org>


 > > Yeah df is just a fun ball of wax in many respects.  We don't take into account
 > > RAID and we don't subtrace space thats strictly for metadata, so there are
 > > several things that need to be fixed for df.  Thanks,

 > But as we have said many times... if we have different
 > raid types active on different files, any attempt to make
 > df report "raid adjusted numbers" instead of the current raw
 > total storage numbers is going to sometimes give wrong answers.
 > 
 > So I think it is dangerous to try.  The current output
 > may be ugly, but it is always consistent and explainable.

It does seem like a big problem, especially as we add in other RAID
levels etc.  However on the flip side, the accounting of the "used"
space does seem off and maybe fixable?

In other words if I create a btrfs filesystem out of two 1GB devices
with RAID1 for data and metadata, then df shows a total size of 2GB for
the filesystem.  But if I then create a .5 GB file on that filesystem,
the used space is shown as .5 GB only -- ie the accounting of total size
is at the device/block level, but the accounting of used space is at the
logical/filesystem level.  Which leads to very confusing df output.

I wonder if it's possible to come up with a way to make things
consistent at least, or figure out a way to define more useful
information about space left on the filesystem.

 - Roland
