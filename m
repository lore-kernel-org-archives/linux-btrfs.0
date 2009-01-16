From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: simplify iteration codes
Date: Fri, 16 Jan 2009 10:23:24 -0500
Message-ID: <1232119404.21473.27.camel@think.oraclecorp.com>
References: <49703687.044e6e0a.04fa.257b@mx.google.com>
	 <1232116274.21473.15.camel@think.oraclecorp.com>
	 <9bd6b5360901160720w3a2950eemaf2cd3e35caec788@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Qinghuang Feng <qhfeng.kernel@gmail.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: sniper <s3c24xx@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <9bd6b5360901160720w3a2950eemaf2cd3e35caec788@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2009-01-16 at 23:20 +0800, sniper wrote:
> On Fri, Jan 16, 2009 at 10:31 PM, Chris Mason <chris.mason@oracle.com> wrote:
> > On Fri, 2009-01-16 at 15:25 +0800, Qinghuang Feng wrote:
> >> merge list_for_each and list_entry to list_for_each_entry.
> >>
> >
> > Thanks, I've queued this up.
> >
> Good, but....
> 
> Now I have made a new patch for cleanupping all the similar codes in btrfs.
> This patch has been tested in VM, it seems ok.
> 
> Now should I  rebuild another patch which based the previous patch,
> or could you be able to reverse the previous patch then I just post
> this new patch including all stuff?
> 
> Sorry I am not much familiar with the posting flow, and I am not sure
> the meaning of "queued".

It means this one looks right and I've put it into my internal testing
tree.  It should be in my next pull request.

But, I'll hold off on this one if there is a larger set of fixes coming
that contain it.

-chris


