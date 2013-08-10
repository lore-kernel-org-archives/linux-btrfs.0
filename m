Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:4448 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S964808Ab3HJQTc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Aug 2013 12:19:32 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:59682 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1V8Bt6-003HjP-8i
	for linux-btrfs@vger.kernel.org; Sat, 10 Aug 2013 10:19:32 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Question about blocksize, I want to use 16k
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <4060398C-D72E-43D6-B380-8BF642C1C2C1@colorremedies.com>
Date: Sat, 10 Aug 2013 10:19:36 -0600
Message-Id: <367ED89F-FF7D-4E85-99F6-4BB575052CE3@colorremedies.com>
References: <20130810154221.206170@gmx.com> <4060398C-D72E-43D6-B380-8BF642C1C2C1@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 10, 2013, at 10:17 AM, Chris Murphy <lists@colorremedies.com> wrote:

> 
> On Aug 10, 2013, at 9:42 AM, Mike Audia <mikey_a@gmx.com> wrote:
> 
>> -s 16k
> 
> One answer is the drive doesn't expose a 16KB sector. It's basically lying when it reports a 512 byte physical sector, but there isn't anything that can be done about this on the software side. The other answer:
> 
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/20746

And also:
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/19661


Chris Murphy