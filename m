From: jim owens <jowens@hp.com>
Subject: Re: Some very basic questions
Date: Tue, 21 Oct 2008 09:20:16 -0400
Message-ID: <48FDD710.5050702@hp.com>
References: <20081021132322.271ad728.skraw@ithnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Stephan von Krawczynski <skraw@ithnet.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081021132322.271ad728.skraw@ithnet.com>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs has many of the same goals... but they are goals not code
so when you might see them is indeterminate.

I believe these should not be in btrfs:

Stephan von Krawczynski wrote:

>     - parallel mounts (very important!)

as Andi said, you want a cluster or distributed fs.  There
are layered designs (CRFS or network filesystems) that can do
the job and trying to do it in btrfs causes too many problems.

>     - journaling

I assume you *do not* mean metadata journaling, you mean
sending all file updates to a single output stream (as in one
disk, tape, or network link).  I've done that, but would not
recommend it in btrfs because it limits the total fs bandwidth
to what the single stream can support.  This is normally done
today by applications like databases, not in the filesystem.

>     - map out dead blocks

Useless... a waste of time, code, and metadata structures.
With current device technology, any device reporting bad blocks
the device can not map out is about to die and needs replaced!

jim
