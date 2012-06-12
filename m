Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.parallels.com ([64.131.90.16]:46631 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab2FLBIV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jun 2012 21:08:21 -0400
Received: from [199.115.105.252] (helo=mail.parallels.com)
	by mx2.parallels.com with esmtps (TLSv1:AES128-SHA:128)
	(Exim 4.77)
	(envelope-from <dolenin@parallels.com>)
	id 1SeFam-0001vM-VE
	for linux-btrfs@vger.kernel.org; Mon, 11 Jun 2012 21:08:21 -0400
Message-ID: <4FD69681.4000404@parallels.com>
Date: Tue, 12 Jun 2012 10:08:17 +0900
From: dima <dolenin@parallels.com>
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>
Subject: Re: KVM on top of BTRFS
References: <1339456922.32583.YahooMailNeo@web160802.mail.bf1.yahoo.com> <loom.20120612T013031-188@post.gmane.org>
In-Reply-To: <loom.20120612T013031-188@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/12/2012 08:53 AM, Alex wrote:
> Matthew Hawn <steamraven <at> yahoo.com> writes:
>> What are the recommendations for running KVM images on BTRFS systems using
> kernel 3.4?  I saw older
>> posts on the web complaining about poor performance, but I know a lot of work
> has gone into btrfs since then.
>>   There also seemed to be the nocow option, but I didn't find anything that
> said it actualy helped.

I don't think it is about the kernel version, but rather about choosing 
the right option for KVM.
I am running KVM via libvirt on btrfs with lzo compression, autodefrag, 
inode and space cache for quite some time. Yes, I did set nocow for the 
directory with images. I have no proof that it actually helps with disk 
images, but being set for the build directory my build time is down 5 
minutes.
I used raw virtio images with no caching. I guess this is the key if we 
talk about disk I/O. The performance looks fine, though I only use it 
for testing.
The last time I tried to install WinXP on KVM it was a disaster. But I 
guess I did not choose the right options, nor did I install virtio 
drivers inside the guest.
VirtualBox still outperforms KVM on btrfs in my view.

best
