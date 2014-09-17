Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:55991 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756013AbaIQStr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 14:49:47 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:56405 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XUKIU-003iEf-C5
	for linux-btrfs@vger.kernel.org; Wed, 17 Sep 2014 12:49:46 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Problem with a filesystem
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <54194F07.2080203@bordeaux.inra.fr>
Date: Wed, 17 Sep 2014 12:49:48 -0600
Message-Id: <800A0C28-B668-4510-850E-DC92E67AD878@colorremedies.com>
References: <54185D48.5060701@bordeaux.inra.fr> <4F2E9AE1-4B33-42BB-8B75-C5A66118A7CB@colorremedies.com> <5418995C.2000708@bordeaux.inra.fr> <82857E4F-9FF6-4110-993F-35830A44BC04@colorremedies.com> <54194F07.2080203@bordeaux.inra.fr>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 17, 2014, at 3:06 AM, Tovo Rabemanantsoa <tovo.rabemanantsoa@bordeaux.inra.fr> wrote:
> 
> Sep 17 11:05:55 sdeeph1 kernel: [85381.548215] parent transid verify
> failed on 24562568384512 wanted 255444 found 255446
> Sep 17 11:05:55 sdeeph1 kernel: [85381.548229] parent transid verify
> failed on 24562568384512 wanted 255444 found 255446
> Sep 17 11:05:55 sdeeph1 kernel: [85381.548237] parent transid verify
> failed on 24562568384512 wanted 255444 found 255446
> Sep 17 11:05:55 sdeeph1 kernel: [85381.548243] parent transid verify
> failed on 24562568384512 wanted 255444 found 255446
> Sep 17 11:05:55 sdeeph1 kernel: [85381.548249] parent transid verify
> failed on 24562568384512 wanted 255444 found 255446
> Sep 17 11:05:55 sdeeph1 kernel: [85381.670344] btrfs: open_ctree failed
> 
> /var/log/syslog adds this line :
> Sep 17 11:05:55 sdeeph1 kernel: [85381.548255] Failed to read block
> groups: -5

This isn't what I expect as a candidate for btrfs-zero-log, I don't know what the last message means. You could run a 
btrfs check <btrfsdev>
and then ask about both the failure to read block groups -5 and also the btrfs check (without --repair) results

Or take a leap of faith, take an image of the file system first as it might make recovery more difficult. If there are things you really need off this file system first you should look at https://btrfs.wiki.kernel.org/index.php/Restore before zeroing the log.

btrfs-image -c 9 -t 8 <btrfsdev> /path/to/file
btrfs-zero-log <btrfsdev>


Chris Murphy