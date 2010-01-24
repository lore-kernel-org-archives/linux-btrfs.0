From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs st_nlink for directories
Date: Sat, 23 Jan 2010 19:33:36 -0500
Message-ID: <20100124003336.GP23006@think>
References: <20100123022812.GA16124@arctrix.com>
 <878wbomu24.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Neil Schemenauer <nas@arctrix.com>, linux-btrfs@vger.kernel.org
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <878wbomu24.fsf@linux.vnet.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 24, 2010 at 02:12:59AM +0530, Aneesh Kumar K. V wrote:
> On Fri, 22 Jan 2010 20:28:12 -0600, Neil Schemenauer <nas@arctrix.com> wrote:
> > Hi,
> > 
> > It looks like Btrfs does not follow Unix traditions for st_nlink
> > attribute of directories. It seems to be always one, no matter the
> > number of sub-directories.
> > 
> > Is this intentional? I couldn't find it discussed anywhere. I
> > gather the Mac OS HFS+ doesn't follow traditional st_nlink behavior
> > as well. The 'find' man page has this note:
> 
> I have sent patches with message-id
> 1264279089-14913-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com
> to the list. Let me know if they works for your

Thanks for taking a look at this Aneesh, but in btrfs we always have a
link count of one on directories.

It's a design decision so that we don't end up limited in the total
number of subdirs we can create.  reiser3 did something similar,
switching to 1 when the link count got high.  I think the other
filesystems may have added something along these lines as well by now.

Btrfs just leaves it at one all the time.

-chris

