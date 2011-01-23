From: "Ian! D. Allen" <idallen@idallen.ca>
Subject: Re: v0.19-35-g1b444cd btrfsck says snapshots have errors
Date: Sun, 23 Jan 2011 05:44:34 -0500
Message-ID: <20110123104434.GU22519@idallen.ca>
References: <20110120225256.GA4161@idallen.ca>
 <AANLkTi=7aDgTUtRB3nyLsVvdQzkYHA6iQueN9Dv-4wFm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=7aDgTUtRB3nyLsVvdQzkYHA6iQueN9Dv-4wFm@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 21, 2011 at 09:15:49AM +0800, Yan, Zheng  wrote:
> On Fri, Jan 21, 2011 at 6:52 AM, Ian! D. Allen <idallen@idallen.ca> wrote:
> > Still getting btrfsck errors with this:
> > git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
> > unresolved ref root 256 dir 256 index 2 namelen 5 name snap1 error 600
> > found 49152 bytes used err is 1
> These is caused by a design flaw, you can safely ignore them.

If it isn't an error, shouldn't btrfsck be ignoring it, not me?
At minimum it could say "warning" and not "err is 1".

-- 
| Ian! D. Allen  -  idallen@idallen.ca  -  Ottawa, Ontario, Canada
| Home Page: http://idallen.com/   Contact Improv: http://contactimprov.ca/
| College professor (Free/Libre GNU+Linux) at: http://teaching.idallen.com/
| Defend digital freedom:  http://eff.org/  and have fun:  http://fools.ca/
