Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static-108-0-197-17.lsanca.fios.verizon.net ([108.0.197.17]:42901
	"EHLO orca4.orcaware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3BUIIc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 03:08:32 -0500
Message-ID: <5125D5CA.3030301@orcaware.com>
Date: Thu, 21 Feb 2013 00:07:38 -0800
From: Blair Zajac <blair@orcaware.com>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com, jbacik@fusionio.com
Subject: Re: v3.8-rc6: btrfs-transacti Tainted: GF in btrfs_orphan_commit_root
References: <5116A1AC.7040300@orcaware.com> <20130211130803.GO12339@twin.jikos.cz>
In-Reply-To: <20130211130803.GO12339@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/11/2013 05:08 AM, David Sterba wrote:
> On Sat, Feb 09, 2013 at 11:21:16AM -0800, Blair Zajac wrote:
>> Running an Ubuntu Raring VM which was built a week ago that is now running
>> 3.8-rc6, I was booting it last night when it hung.  After a few forced
>> reboots, it came back up and I found the attached in kern.log.
>>
>> Are these reports useful?  Is there any additional information I can provide
>> from the VM?  What happens if it gets hung again, is there additional
>> information I can gather?
>
> Yes they're useful, we can see if it's a known or new issue. I've hit
> the same problem not so long ago and a guy on IRC reported the same
> problem yesterday.
>
> There's a fix from Josef, https://patchwork.kernel.org/patch/2083101/
> and given the increasing number of reports (the warning followed by a
> crash), I think this this a material for a late -rc.
>
> Chris please consider picking this patch for 3.8. I think it qualifies
> as a regression sice we haven't hit earlier than 3.8-rc4.

Looking at the v3.8 tag, it doesn't look like it made it in.

Since I ran into this issue on a week old VM, is it possible for this 
patch to make its way into 3.8.1, so it'll be picked up by Ubuntu 
automatically?

Thanks,
Blair

