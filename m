Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 206-248-167-68.dsl.teksavvy.com ([206.248.167.68]:56174 "EHLO
	mail.isoar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbaGEOSk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Jul 2014 10:18:40 -0400
Received: from [172.16.0.130]
	by mail.isoar.ca with esmtpsa (TLSv1:DHE-RSA-AES128-SHA:128)
	(Exim 4.80.1 #2)
	id 1X3QJF-0003vC-BB
	for linux-btrfs@vger.kernel.org; Sat, 05 Jul 2014 09:47:21 -0400
Message-ID: <53B801DD.5040704@isoar.ca>
Date: Sat, 05 Jul 2014 09:47:09 -0400
From: "Andrew E. Mileski" <andrewm@isoar.ca>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Is btrfs related to OOM death problems on my 8GB server with
 both 3.15.1 and 3.14?
References: <20140704011938.GO11539@merlins.org>
In-Reply-To: <20140704011938.GO11539@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-07-03 9:19 PM, Marc MERLIN wrote:
> I upgraded my server from 3.14 to 3.15.1 last week, and since then it's been
> running out of memory and deadlocking (panic= doesn't even work).
> I downgraded back to 3.14, but I already had the problem once since then.

I didn't see any mention of the btrfs utility version in this thread (I 
may be blind though).

My server was suffering from frequent panics upon scrub / defrag / 
balance, until I updated the btrfs utility.  That resolved all my issues.

My server has two filesystems of ~25 TiB, and 4 GB of RAM (15% used).  A 
hardware upgrade is imminent, just waiting for the backup to complete.

~~
Andrew E. Mileski

