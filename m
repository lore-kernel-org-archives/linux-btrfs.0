Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postfix.iai.uni-bonn.de ([131.220.8.4]:56910 "EHLO
	postfix.iai.uni-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbaGQIAL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jul 2014 04:00:11 -0400
Message-ID: <53C78212.2070204@informatik.uni-bonn.de>
Date: Thu, 17 Jul 2014 09:58:10 +0200
From: Sebastian Ochmann <ochmann@informatik.uni-bonn.de>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>, zhe.zhang.research@gmail.com
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Is it safe to mount subvolumes of already-mounted volumes (even
 with different options)?
References: <53C6FA3D.9010803@informatik.uni-bonn.de> <E49EC0AC-DD96-4D7F-9B36-9E28CEC0CD2A@colorremedies.com>
In-Reply-To: <E49EC0AC-DD96-4D7F-9B36-9E28CEC0CD2A@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I need to clarify, I'm _not_ sharing a drive between multiple computers 
at the _same_ time. It's a portable device which I use at different 
locations with different computers. I just wanted to give a rationale 
for mounting the whole drive to some mountpoint and then also part of 
that drive (a subvolume) to the respective computer's /home mountpoint. 
So it's controlled by the same kernel in the same computer, it's just 
that part of the filesystem is mounted at multiple mountpoints, much 
like a bind-mount, but I'm interested in mounting a subvolume of the 
already-mounted volume to some other mountpoint. Sorry for the confusion.

Best regards
Sebastian


On 17.07.2014 01:18, Chris Murphy wrote:
>
> On Jul 16, 2014, at 4:18 PM, Sebastian Ochmann <ochmann@informatik.uni-bonn.de> wrote:
>
>> Hello,
>>
>> I'm sharing a btrfs-formatted drive between multiple computers and each of the machines has a separate home directory on that drive.
>
> 2+ computers writing to the same block device? I don't see how this is safe. Seems possibly a bug that the 1st mount event isn't setting some metadata so that another kernel instance knows not to allow another mount.
>
>
> Chris Murphy
>
