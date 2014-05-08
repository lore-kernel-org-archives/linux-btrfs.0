Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22421 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbaEHCsR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 22:48:17 -0400
Date: Thu, 8 May 2014 10:48:04 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Kenny MacDermid <kenny.macdermid@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs issues in 3.14
Message-ID: <20140508024803.GA3407@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAEVbaUdcCQCWhZ-ZdBr_Dkv-WaMbtBkQ0n8HRfc0p9F0xw1+0A@mail.gmail.com>
 <20140507022245.GA15783@localhost.localdomain>
 <CAEVbaUcV-M9jnwR4ii3zR6RrbfpCtMmYAmhp8O01T4T6jJQN4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAEVbaUcV-M9jnwR4ii3zR6RrbfpCtMmYAmhp8O01T4T6jJQN4A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 07, 2014 at 09:35:06AM -0300, Kenny MacDermid wrote:
> On Tue, May 6, 2014 at 11:22 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> >
> > What does sysrq+w say when the hang happens?
> 
> The whole system isn't hung, I may have explained that wrong. The
> system will hang if I try to shutdown, and the process will hang if I
> try to kill -9 it.
> 
> It looks like the browser is in this state currently so I did an 'echo
> w >/proc/sysrq-trigger' and have attached the full dmesg with the
> browser issues and the output.

Those stacks show the blocked tasks are waiting for a page's writeback, but
they don't show what blocks the endio process of that page.

I'd recommand you to try the lastest 3.15.0-rc4 or btrfs-next, as many fixes
are merged during this period.

thanks,
-liubo
