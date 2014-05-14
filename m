Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from queue01b.mail.zen.net.uk ([212.23.3.242]:39352 "EHLO
	queue01b.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688AbaENNeO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 09:34:14 -0400
Received: from [212.23.1.1] (helo=smarthost01a.mail.zen.net.uk)
	by queue01b.mail.zen.net.uk with esmtp (Exim 4.72)
	(envelope-from <david@chrestomanci.org>)
	id 1WkZK1-0002xZ-28
	for linux-btrfs@vger.kernel.org; Wed, 14 May 2014 13:34:13 +0000
Received: from [82.70.68.182] (helo=www.chrestomanci.org)
	by smarthost01a.mail.zen.net.uk with esmtps (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <david@chrestomanci.org>)
	id 1WkZJz-000AI4-JZ
	for linux-btrfs@vger.kernel.org; Wed, 14 May 2014 14:34:11 +0100
Message-ID: <537370C8.8010606@chrestomanci.org>
Date: Wed, 14 May 2014 14:34:00 +0100
From: David Pottage <david@chrestomanci.org>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>, jshubin@redhat.com
Subject: Re: [PATCH] mkfs.btrfs: allow UUID specification at mkfs time
References: <5372C457.3000706@redhat.com> <53731BE3.5010604@cn.fujitsu.com>
In-Reply-To: <53731BE3.5010604@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 14/05/14 08:31, Wang Shilong wrote:
> On 05/14/2014 09:18 AM, Eric Sandeen wrote:
>> Allow the specification of the filesystem UUID at mkfs time.
>>
>> (Implemented only for mkfs.btrfs, not btrfs-convert).
> Just out of curiosity, this option is used for what kind of use case?
> I notice Ext4 also has this option.:-)
I have used it a few times when replacing the hard disc of a Linux 
system, while trying to leave everything else untouched.

Many distros, including Debian and Ubuntu write the /etc/fstab to 
specify volumes by UUID instead of by label or device path.

I have also had the misfortune to use an embedded system where the boot 
volume UUID was configured into the flash in a non obvious way, so the 
easiest fix was to set-up the boot and root volumes on the replacement 
hard disc to have the same UUID.

Of course in either case I could have just taken a bit for bit copy of 
the source volume using dd, but that had it'd own problems because the 
destination was smaller. I also wanted to defrag the fs while copying it.

-- 
David Pottage



