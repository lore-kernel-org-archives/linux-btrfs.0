Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp11.hushmail.com ([65.39.178.133]:37206 "EHLO
	smtp11.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab2E1GGz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 May 2012 02:06:55 -0400
Received: from smtp11.hushmail.com (localhost.localdomain [127.0.0.1])
	by smtp11.hushmail.com (Postfix) with SMTP id 737FE1CC0E0
	for <linux-btrfs@vger.kernel.org>; Mon, 28 May 2012 06:06:54 +0000 (UTC)
MIME-Version: 1.0
Date: Sun, 27 May 2012 22:06:53 -0800
To: "Liu Bo" <liubo2009@cn.fujitsu.com>
Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Decrease Metadata Fragment By Using a Caterpillar Band Method(intro modified)
From: "WeiFeng Liu" <weifeng.liu@hushmail.com>
Content-Type: text/plain; charset="UTF-8"
Message-Id: <20120528060653.8ABFCE6739@smtp.hushmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday, May 27, 2012 at 5:44 PM, Liu Bo <liubo2009@cn.fujitsu.com> wrote:
>

>Hi,
>
>Thanks for working on this.
>
>Do you have any performance number?
>
>The idea is an interesting one, but I have no idea if it really 
>works, because blocks are
>still fragments:
>
>|   16k     |     16k   |    16k    |
>|----|A|----|----|B|----|----|C|----|
>
>
>Or am I missing something?
>
>thanks,
>liubo
>

Hi, Liu Bo

I noticed your graphic and what you said, "still fragments" 
thanks you.

According my patch's logic, any COWs for tree block A will be limited in it's
16k caterpillar band in the example, at least theoretically, and so tree block
B, like the following:

|<-- A circulated in 16k -->|   |<-- B circulated in 16k -->|
|--a-->|--b-->|--c-->|--d-->|   |--a-->|--b-->|--c-->|--d-->|
|                           |   |                           |
|-------------<-------------|   |-------------<-------------|

	Liu Bo, are the fragments you mentioned referenced to the ones in a caterpillar
or ones out of a caterpillar? if they are in a caterpillar, nothing would be
worried, because they are supposed to stay there forever, and that efficiency
is just what I want. 

	To a certain degree, using a caterpillar for a tree block is somewhat 
similar with the way superblock runs, a superblock circularly updated in a 
cluster of DISCONTINUOUS blocks within a large range, and I use a caterpillar
band to force a tree block updated circularly in a continuous blocks within a
compact area.

Sorry, I haven't yet take performance test for my patch now, a bit more times
are still needed for me to check the possible bugs in code's routes before
tests, and any comments are welcome.

Thanks all you.

WeiFeng Liu
523f28f9b3d9c710cacc31dbba644efb1678cf62

