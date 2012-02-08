From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] mkfs: Handle creation of filesystem larger than the
 first device
Date: Thu, 9 Feb 2012 00:20:15 +0100
Message-ID: <20120208232015.GE1696@quack.suse.cz>
References: <1327593785-23466-1-git-send-email-jack@suse.cz>
 <4F32F0AB.8030003@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.cz>
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F32F0AB.8030003@ubuntu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed 08-02-12 17:01:15, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 1/26/2012 11:03 AM, Jan Kara wrote:
> > make_btrfs() function takes a size of filesystem as an argument. It
> > uses this value to set the size of the first device as well which
> > is wrong for filesystems larger than this device. It results in
> > 'attemp to access beyond end of device' messages from the kernel.
> > So add size of the first device as an argument to make_btrfs().
> 
> I don't think this patch is correct.  Yes, the size switch only
> applies to the first device, so it doesn't make any sense to try to
> use a value larger than that device.  Attempting to do so probably
> should be trapped and it should error out, and the man page should
> probably clarify the fact that the size is only for the first device.
> 
> It looks like you think the size should somehow apply to multiple
> devices or to the total fs size when creating on multiple devices, and
> that just doesn't make sense.
  Thanks for your reply. I admit I was not sure what exactly size argument
should be. So after looking into the code for a while I figured it should
be a total size of the filesystem - or differently it should be size of
virtual block address space in the filesystem. Thus when filesystem has
more devices (or admin wants to add more devices later), it can be larger
than the first device. But I'm not really a btrfs developper so I might be
wrong and of course feel free to fix the issue as you deem fit.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
