Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hera.mpi-klsb.mpg.de ([139.19.1.49]:51097 "EHLO
	hera.mpi-klsb.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161325Ab3LFOJJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Dec 2013 09:09:09 -0500
Message-ID: <52A1DA80.4000203@mpi-sws.org>
Date: Fri, 06 Dec 2013 15:09:04 +0100
From: Pedro Fonseca <pfonseca@mpi-sws.org>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: Null pointer oops when deleting item in btrfs_find_all_root()
References: <52A1CAA5.8090302@mpi-sws.org> <20131206135836.GD20595@localhost.localdomain>
In-Reply-To: <20131206135836.GD20595@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/06/2013 02:58 PM, Liu Bo wrote:
> On Fri, Dec 06, 2013 at 02:01:25PM +0100, Pedro Fonseca wrote:
>> Hi,
>>
>> I've encountered another null pointer bug in btrfs_find_all_root().
>>
>> It may be releated to a bug I previously reported to the mailing
>> list ("Null pointer dereference bug in btrfs_find_all_root"). But
>> this test ran on kernel version 3.12.2 and the oops was triggered
>> when deleting an item from the list. The actual workload (i.e. FS
>> operations) is similar though.
> Not sure if the following commit[1] has been merged in this 3.12.2,
> any chance to check it?
>
> -liubo
>
>
> [1]:
> commit 48ec47364b6d493f0a9cdc116977bf3f34e5c3ec
> Author: Liu Bo<bo.li.liu@oracle.com>
> Date:   Wed Oct 30 13:25:24 2013 +0800
>
>      Btrfs: fix a crash when running balance and defrag concurrently
>

You're right, that patch didn't make it to 3.12.2.

I'll try to run the tests with the patch.

Pedro
