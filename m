Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:35470 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbbHSCqS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Aug 2015 22:46:18 -0400
Received: by igbjg10 with SMTP id jg10so95319821igb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2015 19:46:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55D3DCA5.9070607@cn.fujitsu.com>
References: <CAK7bmU_MnppE5EptmAmqDYfpmC4vP8ydOLb6JROXDZFuasPong@mail.gmail.com>
	<55D3DCA5.9070607@cn.fujitsu.com>
Date: Tue, 18 Aug 2015 22:46:18 -0400
Message-ID: <CAK7bmU_=JcjNT-tqcHmCTQNdFJdGqiCKptypC2c949eG_aAVqA@mail.gmail.com>
Subject: Re: btrfs-image gets stuck, using 100%, looping on bad file descriptor
From: Timothy Normand Miller <theosib@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 18, 2015 at 9:32 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Hi Timothy,
>
> Although I have replied to the bugzilla, IMHO it's more appropriate to
> discuss it in mail list, as it's not a kernel bug.
>

All four devices were online.  The "missing" one was a drive that
died, which was replaced by a new one, but btrfs wouldn't finish the
deletion of the missing device.

-- 
Timothy Normand Miller, PhD
Assistant Professor of Computer Science, Binghamton University
http://www.cs.binghamton.edu/~millerti/
Open Graphics Project
