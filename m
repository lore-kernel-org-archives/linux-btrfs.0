From: Stephan von Krawczynski <skraw@ithnet.com>
Subject: Re: Some very basic questions
Date: Tue, 21 Oct 2008 19:01:36 +0200
Message-ID: <20081021190136.89b2c6af.skraw@ithnet.com>
References: <20081021132322.271ad728.skraw@ithnet.com>
	<48FDD710.5050702@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48FDD710.5050702@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 21 Oct 2008 09:20:16 -0400
jim owens <jowens@hp.com> wrote:

> btrfs has many of the same goals... but they are goals not code
> so when you might see them is indeterminate.

no big issue, my pension is 20 years away, I got time ;-)
 
> I believe these should not be in btrfs:
> 
> Stephan von Krawczynski wrote:
> 
> >     - parallel mounts (very important!)
> 
> as Andi said, you want a cluster or distributed fs.  There
> are layered designs (CRFS or network filesystems) that can do
> the job and trying to do it in btrfs causes too many problems.

question is: if you had such an implementation, are there drawbacks expectable
for the single-mount case? If not I'd vote for it because there are not really
many alternatives "on the market".

> >     - journaling
> 
> I assume you *do not* mean metadata journaling, you mean
> sending all file updates to a single output stream (as in one
> disk, tape, or network link).  I've done that, but would not
> recommend it in btrfs because it limits the total fs bandwidth
> to what the single stream can support.  This is normally done
> today by applications like databases, not in the filesystem.

As far as I know metadata journaling is in, right?
If what you mean is capable of creating live or offline images of the fs you
got me right.
 
> >     - map out dead blocks
> 
> Useless... a waste of time, code, and metadata structures.
> With current device technology, any device reporting bad blocks
> the device can not map out is about to die and needs replaced!

Sure, but what you say only reflects the ideal world. On a file service, you
never have that. In fact you do not even have good control about what is going
on. Lets say you have a setup that creates, reads and deletes files 24h a day
from numerous clients. At two o'clock in the morning some hd decides to
partially die. Files get created on it, fill data up to errors, get
deleted and another bunch of data arrives and yet again fs tries to allocate
the same dead areas. You loose a lot more data only because the fs did not map
out the already known dead blocks. Of course you would replace the dead drive
later on, but in the meantime you have a lot of fun.
In other words: give me a tool to freeze the world right at the time the
errors show up, or map out dead blocks (only because it is a lot easier).

> jim

-- 
Regards,
Stephan
