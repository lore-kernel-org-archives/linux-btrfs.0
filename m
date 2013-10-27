Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:42175 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754649Ab3J0X1y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Oct 2013 19:27:54 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:49685 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VaZkQ-003DKZ-8O
	for linux-btrfs@vger.kernel.org; Sun, 27 Oct 2013 17:27:54 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: No space left on device, problem
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <F8C57341-B55A-49DF-BE61-AB62D9D1A869@colorremedies.com>
Date: Sun, 27 Oct 2013 17:27:53 -0600
Message-Id: <3458CB22-ED71-45F4-B688-09C0CB6F5330@colorremedies.com>
References: <20131027100022.4c76e1e7@virtall.com> <CAEezp7u4-iYN01oXcoodzqsy8_nJPYWL-i0rjFsOc=3C0eSz-g@mail.gmail.com> <CAEezp7txuxchURr1DFhFWeFjCG6_07SX78vZCeDz3sxrgz6SVw@mail.gmail.com> <F8C57341-B55A-49DF-BE61-AB62D9D1A869@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 27, 2013, at 4:46 PM, Chris Murphy <lists@colorremedies.com> wrote:

> 
> On Oct 27, 2013, at 3:53 PM, Igor M <igork20@gmail.com> wrote:
> 
>> I made some more tests. Disk is 3TB, first cca 225GB is copied without errors.
>> Then errors 'No space left on device' begins.
> 
> Post the full entire dmesg somewhere please. pastebin.com is one option.


And on list or pasted, the output for the disk from:

smartctl -x /dev/sdX


Chris Murphy