Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postler.lichtfels.com ([78.46.92.195]:33533 "EHLO
	postler.lichtfels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbaIWNHD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Sep 2014 09:07:03 -0400
Received: from localhost (localhost [127.0.0.1])
	by postler.lichtfels.com (Postfix) with ESMTP id 44746123C8
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Sep 2014 15:07:01 +0200 (CEST)
Received: from postler.lichtfels.com ([127.0.0.1])
 by localhost (postler.lichtfels.com [127.0.0.1]) (amavisd-maia, port 10024)
 with LMTP id 23957-05 for <linux-btrfs@vger.kernel.org>;
 Tue, 23 Sep 2014 15:06:57 +0200 (CEST)
Received: from hiro.oops.intern (mail.oops.co.at [213.129.238.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by postler.lichtfels.com (Postfix) with ESMTPSA id 1829B123D2
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Sep 2014 15:06:56 +0200 (CEST)
Message-ID: <5421706F.6070301@xunil.at>
Date: Tue, 23 Sep 2014 15:06:55 +0200
From: "Stefan G. Weichinger" <lists@xunil.at>
Reply-To: lists@xunil.at
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: general thoughts and questions + general and RAID5/6 stability?
References: <8D1A2626CC69D79-11FC-A2C3@webmail-va141.sysops.aol.com> <pan$5a87e$97e2e260$54942ad0$cefe56f1@cox.net> <54208BBC.1000700@xunil.at> <542162A8.2010700@gmail.com>
In-Reply-To: <542162A8.2010700@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 23.09.2014 um 14:08 schrieb Austin S Hemmelgarn:
> On 2014-09-22 16:51, Stefan G. Weichinger wrote:
>> Is re-creating btrfs-filesystems *recommended* in any way?
>>
>> Does that actually make a difference in the fs-structure?
>>
> I would recommend it, there are some newer features that you can only
> set at mkfs time.  Quite often, when a new feature is implemented, it is
> some time before things are such that it can be enabled online, and even
> then that doesn't convert anything until it is rewritten.

What features for example?

I created my main btrfs a few months ago and would like to avoid
recreating it as this would mean restoring my root-fs on my main
workstation.

Although I would do it if it is "worth it" ;-)

I assume I could read some kind of version number out of the superblock
or so?

btrfs-show-super ?

S



