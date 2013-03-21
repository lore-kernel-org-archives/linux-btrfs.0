Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16891 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab3CUVqz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 17:46:55 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: Problems with compiling btrfs
From: Avi Miller <avi.miller@oracle.com>
In-Reply-To: <CAGR7nwePCTCF0nz7rNqqS9x=UqLugtPL2wp7rA1SgU81R0mDcA@mail.gmail.com>
Date: Fri, 22 Mar 2013 08:46:46 +1100
Cc: linux-btrfs@vger.kernel.org
Message-Id: <F4BFA0F1-C466-48E6-941E-5B4879C99D74@oracle.com>
References: <CAGR7nwePCTCF0nz7rNqqS9x=UqLugtPL2wp7rA1SgU81R0mDcA@mail.gmail.com>
To: Joseph Moore <japlha@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 22/03/2013, at 8:11 AM, Joseph Moore <japlha@gmail.com> wrote:

> [root@ol6 btrfs-progs]# uname -a
> Linux ol6.localdomain 2.6.39-400.17.2.el6uek.x86_64 #1 SMP Wed Mar 13
> 12:31:05 PDT 2013 x86_64 x86_64 x86_64 GNU/Linux


This is the currently shipping Oracle Linux 6 UEK and as such, doesn't support a newer btrfs-progs. If you want to run a newer btrfs, you should install the 3.8 kernel from our playground channel on public-yum.oracle.com and then you can compile a newer btrfs-progs to match.

I've also asked the playground build team to build a newer btrfs-progs RPM for the playground channel, but I'm not sure what the timeframes on that would be.

--
Oracle <http://www.oracle.com>
Avi Miller | Principal Program Manager | +61 (412) 229 687
Oracle Linux and Virtualization
417 St Kilda Road, Melbourne, Victoria 3004 Australia

