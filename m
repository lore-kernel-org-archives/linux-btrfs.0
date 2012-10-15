Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:17113 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab2JOKPp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Oct 2012 06:15:45 -0400
Message-ID: <507BE264.1060500@cn.fujitsu.com>
Date: Mon, 15 Oct 2012 18:16:04 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Stefan Priebe <s.priebe@profihost.ag>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>
Subject: Re: problems with btrfs send / restore
References: <50771F22.3070501@profihost.ag> <20121011194335.GE4405@twin.jikos.cz> <50772408.9040303@profihost.ag>
In-Reply-To: <50772408.9040303@profihost.ag>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	thu, 11 Oct 2012 21:54:48 +0200, Stefan Priebe wrote:
> Am 11.10.2012 21:43, schrieb David Sterba:
>> On Thu, Oct 11, 2012 at 09:33:54PM +0200, Stefan Priebe wrote:
>>> [server: /btrfs/target]# btrfs send -i /btrfs/src/\@snapshot/1
>>> /btrfs/src/\@snapshot/2 | btrfs receive /btrfs/target/\@snapshot/
>>> At subvol /btrfs/src/@snapshot/2
>>> At subvol 2
>>> ERROR: failed to open /btrfs/target/@snapshot/@snapshot/1/test.tar. No such file or directory
>>                                        ^^^^^^^^^^^^^^^^^^^
>>
>> I wonder if this is the ghost snapshot dir entry that Miao fixed. Did
>> somehow get into the 'send' stream and confused the receive side.
>>
>> david
> 
> i missed two facts:
> 1.) vanilla kernel 3.6.1
> 2.) latest btrfs tools git (cloned at 10/10/2012)

Sorry, I can not reproduce this problem, could you send me the detailed steps?

Thanks
Miao

> 
> Stefan
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


