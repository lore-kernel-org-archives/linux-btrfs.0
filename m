From: Alex <alex@bpmit.com>
Subject: Re: "not enough space" with "data raid0"
Date: Wed, 28 Mar 2012 22:11:01 +0000 (UTC)
Message-ID: <loom.20120329T000904-903@post.gmane.org>
References: <C52pxfli1uB@helmut.hullen.de> <20120317121909.GB3172@carfax.org.uk> <4F735AB8.40301@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Phillip Susi <psusi <at> ubuntu.com> writes:

> 
> So currently btrfs's concept of raid0 is "stripe across as many disks as 
> possible, with a minimum of 2 disks".  Is there any reason for that 
> minimum?  I don't see why it can't allow only one if that's the best it 
> can manage.
> 
That's called "Single". http://btrfs.ipv5.de/index.php?title=Mkfs.btrfs



