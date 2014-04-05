Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40354 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbaDEBtE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Apr 2014 21:49:04 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: Hard restart required
From: Avi Miller <avi.miller@oracle.com>
In-Reply-To: <533F3732.6090108@benjamindsmith.com>
Date: Sat, 5 Apr 2014 12:48:59 +1100
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <76C074C2-E0F3-4E01-AF95-94164948A52B@oracle.com>
References: <533DFC46.8020704@benjamindsmith.com> <EDB7426B-B4CA-45F7-A8A4-F7CD0C876DC8@oracle.com> <533EDD2E.6090308@benjamindsmith.com> <EE50E6C7-94F9-494A-A930-194FABFC6B68@oracle.com> <533F3732.6090108@benjamindsmith.com>
To: Lists <lists@benjamindsmith.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey,

On 5 Apr 2014, at 9:50 am, Lists <lists@benjamindsmith.com> wrote:

> Oracle Linux 6 with the Unbreakable Enterprise Kernel Release 2 or Release 3 has production-ready btrfs support. You can even convert your existing CentOS6 boxes across to Oracle Linux 6 in-place without reinstalling:

Yeah, that’s fine and supported. Though, it just switches the existing box across without upgrading to the new kernel. We retain the scripts so that users can switch across without reinstalling. Additional steps are required to install the UEK, though, as below:


>>> is had no effect, even after running a yum clean all to ensure that the caches were reset. I'll re-install my test station with a direct download of OL, since the testing now underway is apparently invalid. 

No need for this, just install kernel-uek manually:

# yum install kernel-uek

It has a different name from the default kernel, so both can be installed at the same time. Because this is a switched box, a yum upgrade won’t automatically pull in the UEK because there isn’t an existing one to upgrade.

Sorry for the confusion!

--
Oracle <http://www.oracle.com>
Avi Miller | Product Management Director | +61 (3) 8616 3496
Oracle Linux and Virtualization
417 St Kilda Road, Melbourne, Victoria 3004 Australia

