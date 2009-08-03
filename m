From: Chris Mason <chris.mason@oracle.com>
Subject: Re: snapshot-removal - timeline ?
Date: Mon, 3 Aug 2009 12:18:00 -0400
Message-ID: <20090803161800.GB5492@think>
References: <1552F85577A149D68B0BFF2A44E0FF0A@bui.materna.com>
 <20090803130412.GB3570@think>
 <10F3F7E4-276B-49C3-B944-61320D634C93@karlsbakk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Roland <devzero@web.de>, linux-btrfs@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <10F3F7E4-276B-49C3-B944-61320D634C93@karlsbakk.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 03, 2009 at 04:33:13PM +0200, Roy Sigurd Karlsbakk wrote:
> On 3. aug.. 2009, at 15.04, Chris Mason wrote:
> 
> >On Sat, Aug 01, 2009 at 02:03:37PM +0200, Roland wrote:
> >>Hello,
> >>
> >>is there a timeline for snapshot-removal ?
> >>
> >>i did intensively play with btrfs about a year ago and was really
> >>impressed, but i quit due to the lack of snapshot removal.
> >>(i tried btrfs mostly because of the snapshot feature)
> >>
> >>has there been some progress on this or is there a timeline when
> >>this feature will be available ?
> >>
> >>i wonder if it`s just so hard to implement or if it`s  just too low
> >>priority on the todo list..... maybe both ? ;)
> >
> >Its a little of both ;)  The plan is to have this in 2.6.32
> 
> 
> Last I heard, someone was saying .31... Is it being moved?

Yes, it was delayed so we could finalize the other changes in .31.

-chris
