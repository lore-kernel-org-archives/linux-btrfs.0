Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 206-248-167-68.dsl.teksavvy.com ([206.248.167.68]:40693 "EHLO
	mail.isoar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbcGGVsq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jul 2016 17:48:46 -0400
Message-ID: <577EC57C.8060607@isoar.ca>
Date: Thu, 07 Jul 2016 17:11:24 -0400
From: "Andrew E. Mileski" <andrewm@isoar.ca>
MIME-Version: 1.0
To: Francesco Turco <fturco@fastmail.fm>, linux-btrfs@vger.kernel.org
Subject: Re: Frequent btrfs corruption on a USB flash drive
References: <0120508a-b9e7-b9e7-4f27-79f982ee07fe@fastmail.fm>
In-Reply-To: <0120508a-b9e7-b9e7-4f27-79f982ee07fe@fastmail.fm>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-07 09:49, Francesco Turco wrote:
> I have a USB flash drive with an encrypted Btrfs filesystem where I
> store daily backups. My problem is that this btrfs filesystem gets
> corrupted very often, after a few days of usage. Usually I just reformat
> it and move along, but this time I'd like to understand the root cause
> of the problem and fix it.

How large is this USB flash device?

I've had issues with btrfs and small devices, where a 1 GB data chunk is 
relatively large.

~~
Andrew E. Mileski
