Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:48378 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752317AbcFBO4i convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jun 2016 10:56:38 -0400
From: Nikolaus Rath <Nikolaus@rath.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: How to map extents to files
References: <87eg8g5lwt.fsf@vostro.rath.org>
	<06ef9ac3-ed15-9621-9629-4c8965618db6@cn.fujitsu.com>
Date: Thu, 02 Jun 2016 07:56:35 -0700
In-Reply-To: <06ef9ac3-ed15-9621-9629-4c8965618db6@cn.fujitsu.com> (Qu
	Wenruo's message of "Thu, 2 Jun 2016 12:01:55 +0800")
Message-ID: <87zir3skpo.fsf@thinkpad.rath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Jun 02 2016, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> At 06/02/2016 11:06 AM, Nikolaus Rath wrote:
>> Hello,
>>
>> For one of my btrfs volumes, btrfsck reports a lot of the following
>> warnings:
>>
>> [...]
>> checking extents
>> bad extent [138477568, 138510336), type mismatch with chunk
>> bad extent [140091392, 140148736), type mismatch with chunk
>> bad extent [140148736, 140201984), type mismatch with chunk
>> bad extent [140836864, 140865536), type mismatch with chunk
>> [...]
>>
>> Is there a way to discover which files are affected by this (in
>> particular so that I can take a look at them before and after a btrfsck
>> --repair)?
>
> Which version is the progs? If the fs is not converted from ext2/3/4,
> it may be a false alert.

Version is 4.4.1. The fs may very well have been converted from ext4,
but I can't tell for sure.


Best,
-Nikolaus

-- 
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             »Time flies like an arrow, fruit flies like a Banana.«
