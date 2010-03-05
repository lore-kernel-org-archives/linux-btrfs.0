From: Josef Bacik <josef@redhat.com>
Subject: Re: Raid1 with 3 drives
Date: Fri, 5 Mar 2010 14:40:47 -0500
Message-ID: <20100305194047.GA15771@localhost.localdomain>
References: <013A5A0F-6BB8-4CF0-855F-0A80BEA8B1CC@adtran.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Grady Neely <grady.neely@adtran.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <013A5A0F-6BB8-4CF0-855F-0A80BEA8B1CC@adtran.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 05, 2010 at 01:28:00PM -0600, Grady Neely wrote:
> Hello,
> 
> I have a 3 1TB drives that I wanted to make a Raid1 system on.  I issued the following command "mkfs.btrfs -m raid1 -d raid1 /dev/sdb /dev/sdc /dev/sdd" And it seems to have created the fs, with no issue.  When I do an df -h, I see that the available space is 3TB.  Seems like with RAID1 I would only see 1TB available, and the other two drives would mirror the first.  Am I misunderstanding how the RAID1 works under btrfs?  Can you have more than two drives in RAID1 in btrfs, so you can survive multiple drive failures?  Is there a better option with only 3 drives?  I am not wedded to RAID1 if there is a better way.
> 
> 

DF with btrfs is a loaded question.  In the RAID1 case you are going to show 3TB
of free space, but everytime you use some space you are going to show 3 times
the amount used (I think thats right).  There are some patches forthcoming to
make the reporting for RAID stuff make more sense, but for the time being just
ignore df.  Thanks,

Josef
