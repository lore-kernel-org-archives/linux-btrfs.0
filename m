Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52269 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751738AbaFCDiz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jun 2014 23:38:55 -0400
Message-ID: <538D4270.4030808@cn.fujitsu.com>
Date: Tue, 3 Jun 2014 11:35:12 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] Btrfs-progs: fsck: only allow partial opening
 under repair mode
References: <1401357597-9494-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <20140602161856.GD22324@twin.jikos.cz>
In-Reply-To: <20140602161856.GD22324@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/03/2014 12:18 AM, David Sterba wrote:
> On Thu, May 29, 2014 at 05:59:56PM +0800, Wang Shilong wrote:
>> The reason that we allow partial opening is that sometimes,
>> we may have some corrupted trees.(for example extent tree), for
>> fsck repair case, the broken tree may be rebuilt later.
>>
>> So if users only want to do check but not repair anything, this
>> patch will make fsck return failure as soon as possible and
>> tell users that some critial roots have been corrupted.
> Ok, that partially answers my question under v1. This would be a
> different mode, eg. a fast check, that would bail out quickly as you
> intend. I'd really want to keep the (full) check and repair to do the
Mm...That is reasonable too..

Acutally, now fsck would bail out if if found some errors. For example
if we fail to check csum tree, it won't check fs root.

I don't have ideas that whether fsck should continue if error happen,
for example, logic error, enomem....

> same sort of checks and verification.
>

