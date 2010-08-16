From: Chris Ball <cjb@laptop.org>
Subject: Re: 2.6.36-rc1 btrfs still unstable
Date: Mon, 16 Aug 2010 11:45:29 -0400
Message-ID: <m3iq3a4l46.fsf@pullcord.laptop.org>
References: <1281948382.1888.7.camel@chotu> <20100816121658.GT3315@think>
	<7222A6B8ACA37D4AA1AC37810C43E8A80F5FC5BC@mail.corp.imt-systems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	"linux-btrfs\@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: "Morten P.D. Stevens" <mstevens@imt-systems.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <7222A6B8ACA37D4AA1AC37810C43E8A80F5FC5BC@mail.corp.imt-systems.com>
	(Morten P. D. Stevens's message of "Mon, 16 Aug 2010 16:17:54 +0200")
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

   > the other big question is:
   > 
   > Is btrfs with 2.6.36 really rockstable and ready to use in
   > productive environments?

No, certainly not until there's a working fsck tool -- at the moment
it's rather easy to kill a btrfs by just losing power.

I just added a paragraph to the main page of the wiki about this,
since we've had a few people on IRC express surprise that their
filesystem aren't fixable after power loss.  Feel free to reword:

   Note that Btrfs does not yet have a fsck tool that can fix errors.
   While Btrfs is stable on a stable machine, it is currently possible
   to corrupt a filesystem irrecoverably if your machine crashes or
   loses power.  This will be fixed when the fsck tool is ready.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
