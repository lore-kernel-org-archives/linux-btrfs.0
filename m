From: Whirm <truewhirm@yahoo.es>
Subject: Re: kernel BUG at fs/btrfs/inode.c:149!
Date: Mon, 16 May 2011 17:01:11 +0200
Message-ID: <201105161701.11645.truewhirm@yahoo.es>
References: <201105051954.48405.whirm@gmx.com> <201105161117.20768.whirm@gmx.com> <4DD13087.7000907@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DD13087.7000907@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 16 May 2011 16:11:19 Josef Bacik wrote:
> On 05/16/2011 05:17 AM, whirm@gmx.com wrote:
> > On Friday 13 May 2011 20:52:22 Josef Bacik wrote:
> >> On 05/13/2011 01:19 PM, whirm@gmx.com wrote:
> >>> On Thursday 05 May 2011 20:57:17 Josef Bacik wrote:
> >>> [..]
> >>> 
> >>>> It doesn't look like that bit had my debugging output.  Thanks,
> >>>> 
> >>>> Josef
> >>> 
> >>> Looks like the last message I sent didn't make to the list. Here's the
> >>> link to
> >> 
> >>> the debug log:
> >> So unfortunately I don't know how we ended up with duplicate entries in
> >> the free space cache, but I can make it so we discard the cache if this
> >> happens.  Please try the patch I just sent to the list
> >> 
> >> [PATCH] Btrfs: check for duplicate entries in the free space cache
> >> 
> >> this will make your fs able to be mounted at the very least.  I'll try
> >> and figure out how this sort of thing happens.  If you manage to make it
> >> happen on purpose let me know how you did it so I can figure out what
> >> I'm doing wrong.  Thanks,
> > 
> > I was able to mount it readonly and copy all the content from it without
> > problems (with vanilla linus' tree). The only out of ordinary thing I did
> > before the error coming up, was to defrag the filesystem (find ~/ -xdev
> > -type f -print0 | xargs -0 sudo ./btrfs filesystem defragment -c) with
> > btrfs-tools from the latest git. After this I think I rebooted once the
> > same day and everything was working ok. The day after in the morning I
> > powered up the laptop and I wasn't able to mount the home volume.
> > I'm on a 64 bit Debian SID with custom kernel. Using btrfs on home and
> > root and ext4 in 3 or 4 other FS, everything is on lvm in luks.
> > 
> > The only thing I think of I can try is to recreate the filesystem, copy
> > the same data on it, defrag and try to umount/remount several times...
> > (although the data will not be fragmented so we may not hit this error)
> > What do you say?
> 
> Sorry I'm having problems following what you are saying.  You mean this
> is how you got into this current situation, or that this is what is
> currently happening to you.  If it's the first one then cool, if you can
> try and make it happen again I would be grateful.  If it's the second
> one then my patch didn't work and I need to try and figure out whats
> going wrong.  Thanks,
> 
> Josef


Sorry yes, I meant this is how I managed to get the corrupted filesystem.

Ill try to break it again.

Thanks,
