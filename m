Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:33179 "EHLO
	mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbbHOBj7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 21:39:59 -0400
Received: by vkbg64 with SMTP id g64so23302679vkb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2015 18:39:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55CE87B9.2050502@oracle.com>
References: <CAK7bmU8hWWVn0KxyKLPsmar2EzSKO_V5fYm5gDor=QycqzrfPQ@mail.gmail.com>
	<55CE7E94.7090102@oracle.com>
	<CAK7bmU8EXeYV=ESwzbgtb120Fs1dRgUcO_W0T-GQS8rQRnwmZw@mail.gmail.com>
	<55CE87B9.2050502@oracle.com>
Date: Fri, 14 Aug 2015 19:39:58 -0600
Message-ID: <CAJCQCtQT4dQWVnQuRm1hxYbcE850JD3r6iEcagf+viXTFU1toQ@mail.gmail.com>
Subject: Re: Can't mount degraded. How to remove/add drives OFFLINE?
From: Chris Murphy <lists@colorremedies.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: Timothy Normand Miller <theosib@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I thought for a second that maybe the problem is due to the "phantom"
single chunk(s) created at mkfs time. I redid the test, and did a
balance to get rid of the single chunk. I did this right after
populating volume with some data. But the problem still happens.

---
Chris Murphy
