Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44342 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933549AbaD3Nbc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Apr 2014 09:31:32 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WfUbi-0004Ii-3H
	for linux-btrfs@vger.kernel.org; Wed, 30 Apr 2014 15:31:30 +0200
Received: from 212.44.20.129.ip.redstone-isp.net ([212.44.20.129])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Apr 2014 15:31:30 +0200
Received: from frank by 212.44.20.129.ip.redstone-isp.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Apr 2014 15:31:30 +0200
To: linux-btrfs@vger.kernel.org
From: Frank Kingswood <frank@kingswood-consulting.co.uk>
Subject: Re: [PATCH 07/14] btrfs-progs: Print more info about device sizes
Date: Wed, 30 Apr 2014 14:31:18 +0100
Message-ID: <5360FB26.9090009@kingswood-consulting.co.uk>
References: <cover.1398786620.git.dsterba@suse.cz> <cfc78e5581e0142caf9a5fe049213c8e5de90efa.1398786620.git.dsterba@suse.cz> <CAMU1PDj3CwYJgiGG27cR+XgZvRFLxY8sAQocRavi8oT9-2Kz+Q@mail.gmail.com> <5360E0EF.8030109@libero.it> <20140430121140.GI5988@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
In-Reply-To: <20140430121140.GI5988@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 30/04/14 13:11, David Sterba wrote:
> On Wed, Apr 30, 2014 at 01:39:27PM +0200, Goffredo Baroncelli wrote:
>>>> Sample:
>>>> /dev/sda7, ID: 3
>>>>     Device size:            10.00GiB
>>>>     FS occuppied:            5.00GiB
>>>
>>> Spelling mistake.  s/occuppied/occupied/.
>>
>> I found a bit unclear the "FS occupied" terms.
>
> We're running out of terms to describe and distinguish the space that
> the filesystem uses.

> 'occupied' seemed like a good choice to me, though it may be not obvious

The space that the filesystem uses in total seems to me is called the 
"size". It has nothing to do with utilization.

/dev/sda6, ID: 2
     Device size:            10.00GiB
     Filesystem size:         5.00GiB

and perhaps only show that "Device size" line if it differs from the 
filesystem size by more than a block.

Frank

