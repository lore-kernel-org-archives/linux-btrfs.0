From: Josef Bacik <josef@redhat.com>
Subject: Re: Raid1 with 3 drives
Date: Fri, 5 Mar 2010 15:31:48 -0500
Message-ID: <20100305203148.GB15771@localhost.localdomain>
References: <013A5A0F-6BB8-4CF0-855F-0A80BEA8B1CC@adtran.com> <20100305194047.GA15771@localhost.localdomain> <m3iq9av8uv.fsf@pullcord.laptop.org> <EC9156D0-7498-458A-AD9F-0197C933C5FC@adtran.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Ball <cjb@laptop.org>, Josef Bacik <josef@redhat.com>,
	linux-btrfs@vger.kernel.org
To: Grady Neely <grady.neely@adtran.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <EC9156D0-7498-458A-AD9F-0197C933C5FC@adtran.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 05, 2010 at 02:29:56PM -0600, Grady Neely wrote:
> Thank you!
> 
> One more question:
> 
> Since I have three devices in a RAID1 pool, can it survive 2 drive failures?
> 

Yes, tho you won't be able to remove more than 1 at a time (since it wants you
to keep at least two disks around).  Thanks,

Josef
