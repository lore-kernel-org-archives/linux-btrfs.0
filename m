Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from caibbdcaabie.dreamhost.com ([208.113.200.184]:39227 "EHLO
	homiemail-a52.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751770AbaBJPed (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 10:34:33 -0500
Received: from homiemail-a52.g.dreamhost.com (localhost [127.0.0.1])
	by homiemail-a52.g.dreamhost.com (Postfix) with ESMTP id B0D026B82F6
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 07:34:32 -0800 (PST)
Received: from [192.168.1.9] (unknown [50.46.251.200])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: john@navitsky.org)
	by homiemail-a52.g.dreamhost.com (Postfix) with ESMTPSA id 94A3A6B82F3
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 07:34:32 -0800 (PST)
Message-ID: <52F8F1C4.5070701@navitsky.org>
Date: Mon, 10 Feb 2014 07:35:32 -0800
From: John Navitsky <john@navitsky.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: system stuck with flush-btrfs-4 at 100% after filesystem resize
References: <52F67926.7060209@navitsky.org>
In-Reply-To: <52F67926.7060209@navitsky.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As a follow-up, at some point over the weekend things did finish on 
their own:

romulus:/vms/johnn-sles11sp3 # df -h /vms
Filesystem      Size  Used Avail Use% Mounted on
/dev/dm-4       2.6T  1.6T  1.1T  60% /vms
romulus:/vms/johnn-sles11sp3 #

I'd still be interested in any comments about what was going on or 
suggestions.

Thanks,

-john

On 2/8/2014 10:36 AM, John Navitsky wrote:
> Hello,
>
> I have a large file system that has been growing.  We've resized it a
> couple of times with the following approach:
>
>    lvextend -L +800G /dev/raid/virtual_machines
>    btrfs filesystem resize +800G /vms
>
> I think the FS started out at 200G, we increased it by 200GB a time or
> two, then by 800GB and everything worked fine.
>
> The filesystem hosts a number of virtual machines so the file system is
> in use, although the VMs individually tend not to be overly active.
>
> VMs tend to be in subvolumes, and some of those subvolumes have snapshots.
>
> This time, I increased it by another 800GB, and it it has hung for many
> hours (over night) with flush-btrfs-4 near 100% cpu all that time.
>
> I'm not clear at this point that it will finish or where to go from here.
>
> Any pointers would be much appreciated.
>
> Thanks,
>
> -john (newbie to BTRFS)

