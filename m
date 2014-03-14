Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:58698 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbaCNLKY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 07:10:24 -0400
Received: from [192.168.0.102] ([130.180.1.21]) by mail.gmx.com (mrgmx002)
 with ESMTPSA (Nemesis) id 0M86PB-1XJhPw3M2L-00vfoQ for
 <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 12:10:22 +0100
Message-ID: <5322E39C.3030802@gmx.net>
Date: Fri, 14 Mar 2014 12:10:20 +0100
From: Marcel Partap <mpartap@gmx.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: How to view transaction log chronologically, human-readable?
References: <53113626.3060706@gmx.net>
In-Reply-To: <53113626.3060706@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[...]
Theoretically, there should be someone on this mailing list capable of
answering this question, no?
Please feel invited to share your insights ;)
#Regards



On 01/03/14 02:21, Marcel Partap wrote:
> Dear BTFRS devs,
> I have a 1TB btrfs volume mounted read-only since two years because I
> deleted a bunch of files and didn't want to give up on them.
> Now with latest btrfs-find-root and btrfs restore --dry-run -t in a
> loop, I generated the full list of files contained in the last several
> hundred root trees. However, diffing these, I find the current one being
> the same until 94 root trees back, and the ones before contain earlier
> changes. Maybe by my own fault that is..whatever.
> 
> Is there a way to just view the transaction history in a human-readable way?
> 
> #Regards
> 
