Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49105 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753239AbcGGSlR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jul 2016 14:41:17 -0400
Subject: Re: Frequent btrfs corruption on a USB flash drive
To: Chris Murphy <lists@colorremedies.com>
References: <0120508a-b9e7-b9e7-4f27-79f982ee07fe@fastmail.fm>
 <87efcca5-6871-2dde-e2df-40602f1a24c2@gmail.com>
 <eefaeb0f-9eb0-bd2c-3ce5-5eb28bb43c68@fastmail.fm>
 <CAJCQCtS5wFT1q5Wrsg1ARQ0qOcmFfqG1=BdqJZ=GoZ1L+UO2AA@mail.gmail.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Francesco Turco <fturco@fastmail.fm>
Message-ID: <b9ae0021-baf1-454e-b87c-197726cee229@fastmail.fm>
Date: Thu, 7 Jul 2016 20:41:14 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS5wFT1q5Wrsg1ARQ0qOcmFfqG1=BdqJZ=GoZ1L+UO2AA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-07 20:25, Chris Murphy wrote:
> On Thu, Jul 7, 2016 at 8:55 AM, Francesco Turco <fturco@fastmail.fm> wrote:
>> Perhaps I
>> should try to rule out an hardware problem by filling my USB flash drive
>> with a large random file and then checking if its SHA-1 checksum
>> corresponds to the original copy on the hard disk. But first I probably
>> should backup the current Btrfs filesystem with the dd command. Can I
>> proceed?
> 
> https://btrfs.wiki.kernel.org/index.php/Gotchas

Thank you for the link, I didn't know that using LVM snapshots or
mounting dd copies can create problems! That could explain the reason
for some of the problems I had in the past.

-- 
Website: http://www.fturco.net/
GPG key: 6712 2364 B2FE 30E1 4791 EB82 7BB1 1F53 29DE CD34
