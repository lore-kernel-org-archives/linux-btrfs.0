Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-08v.sys.comcast.net ([96.114.154.167]:33046 "EHLO
	resqmta-po-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751224AbaLLWeC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 17:34:02 -0500
Message-ID: <548B6D58.6080804@pobox.com>
Date: Fri, 12 Dec 2014 14:34:00 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>
CC: Josef Bacik <jbacik@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 3.18.0: kernel BUG at fs/btrfs/relocation.c:242!
References: <e4a8d9ba015981b895919256a2223950@admin.virtall.com> <542EE83D.8050701@fb.com> <999a300ed462a1e1388aee4d6f03a30e@admin.virtall.com> <438e043f73392614d1453892b7fe225c@admin.virtall.com> <0f30c49c7d208903ef84e31a928e4051@admin.virtall.com> <548B5FD6.5080306@pobox.com> <ce7dba343916e4262a92071af863d014@admin.virtall.com>
In-Reply-To: <ce7dba343916e4262a92071af863d014@admin.virtall.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/12/2014 01:46 PM, Tomasz Chmielewski wrote:
> On 2014-12-12 22:36, Robert White wrote:
>
>> In another thread [that was discussing SMART] you talked about
>> replacing a drive and then needing to do some patching-up of the
>> result because of drive failures. Is this the same filesystem where
>> that happened?
>
> Nope, it was on a different server.
>

okay, so how did the btrfsck turn out?


