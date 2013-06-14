Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46600 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169Ab3FNIvd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Jun 2013 04:51:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UnPjI-0007oo-8b
	for linux-btrfs@vger.kernel.org; Fri, 14 Jun 2013 10:51:32 +0200
Received: from artipc9.vub.ac.be ([134.184.26.59])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Jun 2013 10:51:32 +0200
Received: from fhimpe by artipc9.vub.ac.be with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Jun 2013 10:51:32 +0200
To: linux-btrfs@vger.kernel.org
From: Frederik Himpe <fhimpe@vub.ac.be>
Subject: Re: Kernel bug at fs/btrfs/inode.c:906
Date: Fri, 14 Jun 2013 08:51:16 +0000 (UTC)
Message-ID: <kpeli3$6dr$1@ger.gmane.org>
References: <kp9nbo$tdh$1@ger.gmane.org>
	<20130613141946.GE658@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 13 Jun 2013 10:19:46 -0400, Josef Bacik wrote:

> On Wed, Jun 12, 2013 at 05:51:20AM -0600, Frederik Himpe wrote:
>> I just encoutered this btrfs bug. When this happened, I was  compiling
>> stuff in a qemu/kvm virtual machine running as guest on this host, so
>> this might be related. The guest hard disk image is a qcow2 file which
>> has the NO_COW attribute set.
>> 
>> After this happened, I was unable to unlock my X session, and running
>> reboot in a console did not have any effect, so I had to do a hard
>> reset.
>> 
>> Let me know if you need more info.
> 
> Could you pull down my btrfs-progs, run make and then do
> 
> ./btrfsck /dev/whatever
> 
> and see if it says anything?  Please file a bugzilla at
> bugzilla.kernel.org with the compoenent set to btrfs so I can make sure
> I don't lose track of this? Thanks,

OK, I have filed https://bugzilla.kernel.org/show_bug.cgi?id=59711
with the btrfsck output included.

Regards,
-- 
Frederik Himpe

