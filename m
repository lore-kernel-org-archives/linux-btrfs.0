From: Josef Bacik <josef@redhat.com>
Subject: Re: [RFC PATCH 0/5] apply rwlock for extent state
Date: Thu, 22 Mar 2012 09:09:33 -0400
Message-ID: <20120322130932.GA2118@dhcp231-144.rdu.redhat.com>
References: <1331802737-29454-1-git-send-email-liubo2009@cn.fujitsu.com>
 <4F694262.6050409@cn.fujitsu.com>
 <CAK-xaQZGnkwQGq7TXy50vJwNMRXnM3WR6jqCnSXSf7-6yFRJ5A@mail.gmail.com>
 <4F6A7A8D.7060508@csamuel.org>
 <4F6A7DAA.6050203@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrea Gelmini <andrea.gelmini@gmail.com>,
	Chris Samuel <chris@csamuel.org>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>, Arne Jansen <sensille@gmx.net>,
	David Sterba <dsterba@suse.cz>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F6A7DAA.6050203@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 22, 2012 at 09:17:30AM +0800, Liu Bo wrote:
> On 03/22/2012 09:04 AM, Chris Samuel wrote:
> > On 21/03/12 23:34, Andrea Gelmini wrote:
> > 
> >> No comment, but I'm using this patches without problem since you
> >> published it (compressed /home with hourly snapshot delete/creation).
> > 
> > Well worth sending a Tested-By: tag then, it's useful information.
> > 
> > cheers,
> > Chris
> 
> 
> Besides a Tested-By: tag, I'll appreciate a lot if anyone can provide
> improvement/regression on performance with this patchset ;)
>

I've started reviewing some of it Liu and I'll try to get to the rest of it
today.  Thanks,

Josef 
