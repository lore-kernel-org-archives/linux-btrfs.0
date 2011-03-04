From: "Zhong, Xin" <xin.zhong@intel.com>
Subject: RE: [PATCH] btrfs file write debugging patch
Date: Fri, 4 Mar 2011 16:41:46 +0800
Message-ID: <1865303E0DED764181A9D882DEF65FB6866D25713B@shsmsx502.ccr.corp.intel.com>
References: <BAY156-w43472A651462DCADA1F9FAD2C10@phx.gbl>
 <AANLkTi=6G2A1Lb6aWwtFeLgJvV2k_syss4rRfokbFG56@mail.gmail.com>
 <1865303E0DED764181A9D882DEF65FB68662CD02C8@shsmsx502.ccr.corp.intel.com>
 <1299203447-sup-9359@think>
 <20110304023212.GB4558@dhcp231-156.rdu.redhat.com>
 <1865303E0DED764181A9D882DEF65FB6866D256DE2@shsmsx502.ccr.corp.intel.com>
 <20110304024109.GD4558@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Chris Mason <chris.mason@oracle.com>,
	Mitch Harder <mitch.harder@sabayonlinux.org>,
	Xin Zhong <thierryzhong@hotmail.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110304024109.GD4558@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Looks good to me. Thanks! 

Another mysterious thing is that this problem can only be recreated on x86 32bit system. I can not recreate it on x86_64 system using my test case. Any one have any idea about it?

-----Original Message-----
From: Josef Bacik [mailto:josef@redhat.com] 
Sent: Friday, March 04, 2011 10:41 AM
To: Zhong, Xin
Cc: Josef Bacik; Chris Mason; Mitch Harder; Xin Zhong; linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs file write debugging patch

On Fri, Mar 04, 2011 at 10:42:46AM +0800, Zhong, Xin wrote:
> Where can I find your patch? Thanks!
>

It's in my btrfs-work git tree, it's based on the latest git pull from linus so
you can just pull it onto a linus tree and you should be good to go.  The
specific patch is

Btrfs: simplify our write path

Thanks,

Josef
