From: Grady Neely <grady.neely@adtran.com>
Subject: Re: Raid1 with 3 drives
Date: Fri, 5 Mar 2010 14:29:56 -0600
Message-ID: <EC9156D0-7498-458A-AD9F-0197C933C5FC@adtran.com>
References: <013A5A0F-6BB8-4CF0-855F-0A80BEA8B1CC@adtran.com> <20100305194047.GA15771@localhost.localdomain> <m3iq9av8uv.fsf@pullcord.laptop.org>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3iq9av8uv.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

Thank you!

One more question:

Since I have three devices in a RAID1 pool, can it survive 2 drive failures?


On Mar 5, 2010, at 1:58 PM, Chris Ball wrote:

> Hi,
> 
>> DF with btrfs is a loaded question.  In the RAID1 case you are
>> going to show 3TB of free space, but everytime you use some space
>> you are going to show 3 times the amount used (I think thats
>> right).  There are some patches forthcoming to make the reporting
>> for RAID stuff make more sense, but for the time being just
>> ignore df.
> 
> Added to:
> 
> http://btrfs.wiki.kernel.org/index.php/FAQ#Why_does_df_show_incorrect_free_space_for_my_RAID_volume.3F
> 
> since we're often seeing this question on the list and IRC.
> 
> - Chris.
> -- 
> Chris Ball   <cjb@laptop.org>
> One Laptop Per Child

