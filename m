Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:37646 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754262AbaBFRNC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Feb 2014 12:13:02 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: device delete missing panic
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52F31726.7000200@gmail.com>
Date: Thu, 6 Feb 2014 10:12:59 -0700
Cc: Anand Jain <Anand.Jain@oracle.com>, linux-btrfs@vger.kernel.org
Message-Id: <0C544B5C-B262-4FEB-8221-4351490E533D@colorremedies.com>
References: <52F30422.8@gmail.com> <52F3112C.3070309@oracle.com> <52F31726.7000200@gmail.com>
To: Thermionix <thermionix@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 5, 2014, at 10:01 PM, Thermionix <thermionix@gmail.com> wrote:

>  CPU: 0 PID: 3005 Comm: btrfs-worker-1 Tainted: G        W    3.11.6-4-pae #1


Something happened even before the kernel messages you posted, as this kernel is already tainted. I would honestly try to get a prebuilt 3.14-rc1 kernel from your distro's dev branch, or build from mainline. There are a large pile of bug fixes from just 3.13, let alone 3.11.6.

And also make sure you're at btrfs-progs 3.12. If the kernel alone isn't able to work around it with a normal mount, or -o recovery, or -o recovery,degraded, then your next step is probably btrfs-zero-log based on the btrfs: failed to read tree root on sdg.

Let's see if others concur.


Chris Murphy

