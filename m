From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: Btrfs balance
Date: Thu, 20 Jan 2011 15:58:26 +0100
Message-ID: <4D384D92.5010207@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

> Here (Kernel 2.6.37, btrfs git Nov. 2010): balancing two disks/
> partitions with 2 and 1.5 TByte needs about 24 hours (CPU 1.5 GHz).
>
> What do you mean with "lots of IO"? the messages in "/var/log/messages"
> and "/var/log/warn"?

Simply disk activity.

See i.e. "iostat -k 1".


-- 
Tomasz Chmielewski
http://wpkg.org
