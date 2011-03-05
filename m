From: Xin Zhong <thierryzhong@hotmail.com>
Subject: RE: [PATCH] btrfs file write debugging patch
Date: Sun, 6 Mar 2011 01:28:24 +0800
Message-ID: <BAY156-w8DC764B20D312A31D886FD2C50@phx.gbl>
References: <BAY156-w43472A651462DCADA1F9FAD2C10@phx.gbl>,<AANLkTi=6G2A1Lb6aWwtFeLgJvV2k_syss4rRfokbFG56@mail.gmail.com>,<1865303E0DED764181A9D882DEF65FB68662CD02C8@shsmsx502.ccr.corp.intel.com>,<1299203447-sup-9359@think>,<20110304023212.GB4558@dhcp231-156.rdu.redhat.com>,<1865303E0DED764181A9D882DEF65FB6866D256DE2@shsmsx502.ccr.corp.intel.com>,<20110304024109.GD4558@dhcp231-156.rdu.redhat.com>,<AANLkTimoLf0rKVZ7aBTt6p-XC9un15drtZf1sKzbL2nC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gb2312"
Cc: <xin.zhong@intel.com>, <chris.mason@oracle.com>,
	<linux-btrfs@vger.kernel.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>, <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimoLf0rKVZ7aBTt6p-XC9un15drtZf1sKzbL2nC@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


I think Josef's patch only address the one-by-one page processing issue. 
But do not address the issue that dirty_pages should be set to 0 when copied is 0. 

----------------------------------------
> Date: Sat, 5 Mar 2011 10:56:52 -0600
> Subject: Re: [PATCH] btrfs file write debugging patch
> From: mitch.harder@sabayonlinux.org
> To: josef@redhat.com
> CC: xin.zhong@intel.com; chris.mason@oracle.com; thierryzhong@hotmail.com; linux-btrfs@vger.kernel.org
>
> On Thu, Mar 3, 2011 at 8:41 PM, Josef Bacik  wrote:
> > On Fri, Mar 04, 2011 at 10:42:46AM +0800, Zhong, Xin wrote:
> >> Where can I find your patch? Thanks!
> >>
> >
> > It's in my btrfs-work git tree, it's based on the latest git pull from linus so
> > you can just pull it onto a linus tree and you should be good to go.  The
> > specific patch is
> >
> > Btrfs: simplify our write path
> >
> > Thanks,
> >
> > Josef
> >
>
> Josef:
>
> I've been testing the kernel from you git tree (as of commit 5555f192
> Btrfs: add a comment explaining what btrfs_cont_expand does).
>
> I am still running into issues when running the portion of Openmotif
> that has been generating the problem with page faults when given an
> unaligned address.
 		 	   		  
