Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:35434 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbbHTNIJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Aug 2015 09:08:09 -0400
Received: by iodt126 with SMTP id t126so45081342iod.2
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Aug 2015 06:08:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55D5BC4E.9080806@gmail.com>
References: <CAK7bmU_MnppE5EptmAmqDYfpmC4vP8ydOLb6JROXDZFuasPong@mail.gmail.com>
	<55D3DCA5.9070607@cn.fujitsu.com>
	<CAK7bmU_=JcjNT-tqcHmCTQNdFJdGqiCKptypC2c949eG_aAVqA@mail.gmail.com>
	<55D3EE99.2000702@cn.fujitsu.com>
	<CAK7bmU8RK25Zd=sgni1i3M17=mY9xRecFtn+e=Mj03DwjMSBTw@mail.gmail.com>
	<55D5BC4E.9080806@gmail.com>
Date: Thu, 20 Aug 2015 09:08:08 -0400
Message-ID: <CAK7bmU9h0s_cTY+r8b7EbvD6nAvK0NafGVace5+3yTFanT0M1A@mail.gmail.com>
Subject: Re: btrfs-image gets stuck, using 100%, looping on bad file descriptor
From: Timothy Normand Miller <theosib@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 20, 2015 at 7:38 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:

> Just for reference, I've found that it is usually safer to delete the
> missing device first if possible, then add the new one and re-balance. There
> seem to be some edge-cases in the code for deleting missing devices.
>

The problem is that you can't do that if there's not enough space on
the remaining devices to hold all the data.


-- 
Timothy Normand Miller, PhD
Assistant Professor of Computer Science, Binghamton University
http://www.cs.binghamton.edu/~millerti/
Open Graphics Project
