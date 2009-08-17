From: Chris Ball <cjb@laptop.org>
Subject: Re: Why does stat() return invalid st_dev field for btrfs ??
Date: Mon, 17 Aug 2009 17:52:17 -0400
Message-ID: <m3eirads6m.fsf@pullcord.laptop.org>
References: <4A89C1DA.6040601@rtr.ca> <4A89C86A.1040207@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Mark Lord <lkml@rtr.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A89C86A.1040207@rtr.ca> (Mark Lord's message of "Mon, 17 Aug
	2009 17:15:22 -0400")
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

   > Mmm.. btrfs appears to configure itself as a "pseudo" filesystem,
   > which is why it returns fake device numbers via stat(), similar
   > to procfs or sysfs.

Probably because a single btrfs filesystem can be composed of multiple
devices; one major/minor would not be sufficient.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
