Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:27773 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755166Ab3JCT0G convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Oct 2013 15:26:06 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs kernel bug while balancing
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <1380826503.910.2.camel@lapchris>
Date: Thu, 3 Oct 2013 13:26:03 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <B0419E43-76A9-4987-8A23-3EF2E5EB3D3D@colorremedies.com>
References: <20131003203431.35b0b9b98d90c9324c941d11@gmail.com> <5B88DC80-8A9A-458C-9F02-FDD50FB73207@colorremedies.com> <1380826503.910.2.camel@lapchris>
To: =?iso-8859-1?Q?Christopher_Kroo=DF?= <c.krooss@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 3, 2013, at 12:55 PM, Christopher Krooﬂ <c.krooss@gmail.com> wrote:

> On Do, 2013-10-03 at 12:50 -0600, Chris Murphy wrote:
>> On Oct 3, 2013, at 12:34 PM, Christopher Krooﬂ <c.krooss@gmail.com> wrote:
>> 
>>> Hi, I just encountered this kernel bug when I executed "btrfs balance start /". I'm sorry if this is not enough data but I couldn't save the log as my system didn't respond after the dmesg. It said "kernel bug" before the trace.
>>> 
>>> partial log: http://i.imgur.com/ygk3Nid.jpg
>> 
>> If it's kernel 3.11.0 through 3.11.4 it may be a known problem. I don't know if it adversely affects the file system. I'd either look at 3.12.0-rc3, or regress to 3.10.14 if you need to balance sooner than later. Or wait until several balance related fixes end up in 3.11.x (maybe 3.11.5).
>> 
>> If you aren't using a 3.11 kernel, it might be useful to know what version you are using.
>> 
>> Chris Murphy
> 
> 
> Thanks for the info. I'm in fact running 3.11.3 so I'll just wait it
> out. There were some csum errors after I rebooted, but it seems to just
> be /var/log/journal.

Yes, avoid balance until there's a fix, and consider tossing the journals to remove the csum errors. This bug is fixed with this patch headed to stable.

http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg27549.html


Chris Murphy