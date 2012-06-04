Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56586 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab2FDM0q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jun 2012 08:26:46 -0400
Received: by vcbf11 with SMTP id f11so2384583vcb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jun 2012 05:26:46 -0700 (PDT)
Message-ID: <4FCCA983.50400@gmail.com>
Date: Mon, 04 Jun 2012 08:26:43 -0400
From: Maxim Mikheev <mikhmv@gmail.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Help with recover data
References: <4FC54A5D.8000600@gmail.com> <4FCCA8E3.7080209@giantdisaster.de>
In-Reply-To: <4FCCA8E3.7080209@giantdisaster.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It was a kernel panic from btrfs.
I had around 40 parallel processes of reading/writing.

On 06/04/2012 08:24 AM, Stefan Behrens wrote:
> What have you done? Why do you need to recover data? What happened? A
> power failure? A kernel crash?
>
> On Tue, 29 May 2012 18:14:53 -0400, Maxim Mikheev wrote:
>> I recently decided to use btrfs. It works perfectly for a week even
>> under heavy load. Yesterday I destroyed backups as cannot afford to have
>> ~10TB in backups. I decided to switch on Btrfs because it was announced
>> that it stable already
>> I need to recover ~5TB data, this data is important and I do not have
>> backups....
