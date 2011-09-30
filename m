From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [BUG, integration-test] fs/btrfs/inode.c:835
Date: Fri, 30 Sep 2011 16:10:40 -0400
Message-ID: <1317413433-sup-5145@shiny>
References: <20110929220513.GH22205@twin.jikos.cz> <4E85081A.9030900@jp.fujitsu.com> <20110930105200.GI22205@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Cc: Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: David Sterba <dave@jikos.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110930105200.GI22205@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from David Sterba's message of 2011-09-30 06:52:00 -0400:
> On Fri, Sep 30, 2011 at 09:06:50AM +0900, Tsutomu Itoh wrote:
> > The problem might be solved by the following patch.
> > 
> >  http://marc.info/?l=linux-btrfs&m=131556023601191&w=2
> 
> Thanks! It's the same BUG_ON line. I rerun the test yesterday for the
> scond time and it triggered again. Now I'm testing integration with
> Miao's fix and so far no crash after a few rounds.

Nice, thanks guys.

-chris
