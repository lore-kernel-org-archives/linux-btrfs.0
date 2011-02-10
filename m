From: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: New btrfsck status
Date: Thu, 10 Feb 2011 07:26:25 -0500
Message-ID: <87sjvwqdn2.fsf@gmail.com>
References: <AANLkTinu_29idVYvudG=E6VaxwqQoN2YEi57-RPk3dkF@mail.gmail.com> <1297340143-sup-3602@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1297340143-sup-3602@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 10 Feb 2011 07:17:10 -0500, Chris Mason <chris.mason@oracle.com> wrote:
> Excerpts from Ben Gamari's message of 2011-02-09 21:52:20 -0500:
> > Is there a timeline for getting btrfsck into some sort of usable form?
> 
> Yes, but its still real soon now.  I've been at about 90% done since
> Christmas.  It would have been out last week but I've been chasing a
> debugging a very difficult corruption under load.
> 
> I finally found a race in btrfs causing the corruption and now I'm back
> on fsck full time again.
> 
Glad to hear this. Thank you very much for your update. With respect to
the other thread (re: loose eSATA cable). I can keep the array around in
its current form if it would provide a good test case for btrfsck. That
being said, I'm really looking to recover some of the data from this
array if at all possible.

Cheers,

- Ben

