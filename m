Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51392 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbaD0QBL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Apr 2014 12:01:11 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WeRVu-0000Da-0v
	for linux-btrfs@vger.kernel.org; Sun, 27 Apr 2014 18:01:10 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Apr 2014 18:01:10 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Apr 2014 18:01:10 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or
 newer? - RESOLVED
Date: Sun, 27 Apr 2014 17:00:58 +0100
Message-ID: <ljj9jr$jmn$1@ger.gmane.org>
References: <001501cf6210$4142a840$c3c7f8c0$@petrovi.no-ip.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <001501cf6210$4142a840$c3c7f8c0$@petrovi.no-ip.info>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 27/04/14 13:00, Пламен Петров wrote:
> The problem reported in this thread has been RESOLVED.
> 
> It's not BTRFS's fault.
> 
> Debugging on my part led to the actual problem in do_mounts.c - some
> filesystems mount routines return error codes other than 0, EACCES
> and EINVAL and such return codes result in the kernel panicking
> without trying to mount root with all of the available filesystems.
> 
> Patch is available as attachment to bug 74901 -
> https://bugzilla.kernel.org/show_bug.cgi?id=74901 . The bugentry
> documents how I managed to find the problem.

Well deduced and that looks to be a good natural clean fix.

My only question is: What was the original intent to deliberately fail
if something other than EACCES or EINVAL were reported?


> Also, the patch has been sent to the linux kernel mailing list - see
> http://news.gmane.org/find-root.php?group=gmane.linux.kernel&article=1691881
> Hopefully, it will find its way into the kernel, and later on - in
> stable releases.

That all looks very good and very thorough.


> Thanks to you all! ------------------------------ Plamen Petrov

Thanks to you for chasing it through!

AND for posting the "Resolved" to let everyone know. :-)


Regards,
Martin




