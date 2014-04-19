Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:55657 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbaDTVOR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Apr 2014 17:14:17 -0400
Received: from [192.168.0.102] ([176.198.126.29]) by mail.gmx.com (mrgmx101)
 with ESMTPSA (Nemesis) id 0MUUWN-1WU2z62FLX-00RJjf for
 <linux-btrfs@vger.kernel.org>; Sun, 20 Apr 2014 23:14:15 +0200
Message-ID: <5352D26A.70601@gmx.net>
Date: Sat, 19 Apr 2014 21:45:46 +0200
From: Marcel Partap <mpartap@gmx.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: How to view transaction log chronologically, human-readable?
References: <53113626.3060706@gmx.net> <5322E39C.3030802@gmx.net>
In-Reply-To: <5322E39C.3030802@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the BTRFS development list, right? Someone here should know how
to achieve this I hope?
#Regards

> On 01/03/14 02:21, Marcel Partap wrote:
>> Dear BTFRS devs,
>> I have a 1TB btrfs volume mounted read-only since two years because I
>> deleted a bunch of files and didn't want to give up on them.
>> Now with latest btrfs-find-root and btrfs restore --dry-run -t in a
>> loop, I generated the full list of files contained in the last several
>> hundred root trees. However, diffing these, I find the current one being
>> the same until 94 root trees back, and the ones before contain earlier
>> changes. Maybe by my own fault that is..whatever.
>>
>> Is there a way to just view the transaction history in a human-readable way?
>>
>> #Regards
>>
