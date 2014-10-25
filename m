Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:53730 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751220AbaJYUff convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Oct 2014 16:35:35 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49890 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:RC4-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1Xi83i-001FMn-Oy
	for linux-btrfs@vger.kernel.org; Sat, 25 Oct 2014 14:35:34 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Poll: time to switch skinny-metadata on by default?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <64867638-EADF-4258-ACD7-BC33014B3DA9@colorremedies.com>
Date: Sat, 25 Oct 2014 14:35:33 -0600
Message-Id: <CF7BFF69-89E5-44EE-8CC3-E306531B88FE@colorremedies.com>
References: <20141016113337.GC22943@twin.jikos.cz> <20141020163403.GW22943@twin.jikos.cz> <20141025142458.5d96970b@marcec> <64867638-EADF-4258-ACD7-BC33014B3DA9@colorremedies.com>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 25, 2014, at 2:33 PM, Chris Murphy <lists@colorremedies.com> wrote:

> 
> On Oct 25, 2014, at 6:24 AM, Marc Joliet <marcec@gmx.de> wrote:
>> 
>> First of all: does grub2 support booting from a btrfs file system with
>> skinny-metadata, or is it irrelevant?
> 
> Seems plausible if older kernels don't understand skinny-metadata, that GRUB2 won't either. So I just tested it with grub2-2.02-0.8.fc21 and it works. I'm surprised, actually.

I don't understand the nature of the incompatibility with older kernels. Can they not mount a Btrfs volume even as ro? If so then I'd expect GRUB to have a problem, so I'm going to guess that maybe a 3.9 or older kernel could ro mount a Btrfs volume with skinny extents and the incompatibility is writing.

Chris Murphy