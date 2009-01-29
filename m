From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] Documentation/Changes: add required versions for new
 filesystems
Date: Wed, 28 Jan 2009 19:45:10 -0800
Message-ID: <49812646.306@oracle.com>
References: <1233158441-5475-1-git-send-email-notting@redhat.com> <20090128160157.GA5598@nostromo.devel.redhat.com> <20090128211347.GG8990@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	phillip@lougher.demon.co.uk, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090128211347.GG8990@mit.edu>
List-ID: <linux-btrfs.vger.kernel.org>

Theodore Tso wrote:
> On Wed, Jan 28, 2009 at 11:01:57AM -0500, Bill Nottingham wrote:
>> Bill Nottingham (notting@redhat.com) said: 
>>> btrfs requires version 0.18 of its tools, and squashfs requires
>>> 4.0.
>> This time, with a typo fix.
> 
> While you're at it, could you also update e2fsprogs to require 1.41.4.
> It's required for ext4, and even for ext3, if the text is going to
> say, "if you're going to report any bugs, please update to the
> versions of these programs".  So the line for e2fsprogs should read:
> 
>  o  e2fsprogs              1.41.4                    # e2fsck -V
> 
> I could push this as a separate patch, but then there could be patch
> conflicts, so it might be nice if you could update e2fsprogs at the
> same time.

I've done that and can add it to my Docs patches queue for Linus.

Thanks,
-- 
~Randy
