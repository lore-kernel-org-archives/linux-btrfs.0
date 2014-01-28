Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41774 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755412AbaA1Sj5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 13:39:57 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W8DZk-0004sR-3U
	for linux-btrfs@vger.kernel.org; Tue, 28 Jan 2014 19:39:56 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jan 2014 19:39:56 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jan 2014 19:39:56 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Snapshots =?windows-1252?Q?=96_noob_questions?=
Date: Tue, 28 Jan 2014 18:39:45 +0000
Message-ID: <lc8th4$8um$1@ger.gmane.org>
References: <52E664E0.5070909@gmail.com> <3022B1A5-391E-431C-B5F9-2BE9206B8578@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
In-Reply-To: <3022B1A5-391E-431C-B5F9-2BE9206B8578@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 27/01/14 18:44, Chris Murphy wrote:
> 
> On Jan 27, 2014, at 6:53 AM, KC <impactoria@googlemail.com> wrote:
>>
>> 3. If I make a snapshot of / and there are some separate partitions mounted under /mnt/ or /home/, will snapshot skip them?
> 
> A snapshot of a subvolume only snapshots that subvolume, not other subvolumes contained in it or other partitions/file systems.

Thanks. That's a critical detail to know.


A few follow-on questions... Are taking snapshots:


"atomic"?

Do they hold up or lock out other disk activity?

Is there an overhead to keeping many snapshots other than the storage
any changed files take?

Can we now consider making and deleting snapshots a "debugged stable
feature"?


Thanks,
Martin

