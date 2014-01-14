Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50747 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaANLeZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 06:34:25 -0500
Message-ID: <52D522E2.40503@oracle.com>
Date: Tue, 14 Jan 2014 19:43:30 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [bug] its messy when missing device reappears after its been
 replaced in RAID1
References: <52CAE033.3020604@oracle.com> <52D3BA54.6010601@cn.fujitsu.com>
In-Reply-To: <52D3BA54.6010601@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Wang,


> I agree we use transid to find most proper device, but this check is not
> right.
> Here @found_transid is the most biggest generation, so a right candidate
> device's
> transid should be @found_tranid -1 (power off for example)or same as
> @found_transid.
>
> Anyway, i think the right way should be to check two same id device, and
> we only replace
> existed one if new found one's transid > previous one.
>
> Please correct me if i miss something here.^_^

  Thanks for the review comments ! I am writing the fix.

Anand
