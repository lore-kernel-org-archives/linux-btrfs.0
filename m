From: Chris Ball <cjb@laptop.org>
Subject: Re: Raid1 with 3 drives
Date: Fri, 05 Mar 2010 14:58:32 -0500
Message-ID: <m3iq9av8uv.fsf@pullcord.laptop.org>
References: <013A5A0F-6BB8-4CF0-855F-0A80BEA8B1CC@adtran.com>
	<20100305194047.GA15771@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Grady Neely <grady.neely@adtran.com>, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100305194047.GA15771@localhost.localdomain> (Josef Bacik's
	message of "Fri, 5 Mar 2010 14:40:47 -0500")
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

   > DF with btrfs is a loaded question.  In the RAID1 case you are
   > going to show 3TB of free space, but everytime you use some space
   > you are going to show 3 times the amount used (I think thats
   > right).  There are some patches forthcoming to make the reporting
   > for RAID stuff make more sense, but for the time being just
   > ignore df.

Added to:

http://btrfs.wiki.kernel.org/index.php/FAQ#Why_does_df_show_incorrect_free_space_for_my_RAID_volume.3F

since we're often seeing this question on the list and IRC.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
