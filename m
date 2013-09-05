Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45796 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab3IECHa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 22:07:30 -0400
Message-ID: <5227E8EE.8090007@oracle.com>
Date: Thu, 05 Sep 2013 10:14:06 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: linux-btrfs@vger.kernel.org, dsterba@suse.cz, sandeen@redhat.com
Subject: Re: [PATCH 00/20] fix magic return value in btrfs-progs
References: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 09/04/2013 11:22 PM, Wang Shilong wrote:
> This patchset tries to fix all the magic return value in btrfs-progs.
> Most commands will have three kinds of return value:
>
> 0 success
> 1 usage of syntax errors
>
> Exceptions come from balance/scrub/replace. For example, replace cancel
> will return 2 if there is no operations in progress.

  Thanks for writing this much needed.
  Its better to have these return error codes defined
  in a header. So that it would guide the future developments.

Anand
