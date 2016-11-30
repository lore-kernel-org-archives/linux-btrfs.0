Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:57626 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752526AbcK3Gmv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 01:42:51 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id C4AC7AC00C7
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Nov 2016 15:42:46 +0900 (JST)
Subject: Re: [bug] btrfs-progs-v4.8.4: test of 'btrfs receive' in xfstests
 fails
To: dsterba@suse.cz
References: <79c9366a-913f-375f-8fa6-729947b74901@jp.fujitsu.com>
 <20161129153408.GH12522@twin.jikos.cz>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <fa1c56be-bcb5-85b0-f6c9-b55e0aa851cb@jp.fujitsu.com>
Date: Wed, 30 Nov 2016 15:42:36 +0900
MIME-Version: 1.0
In-Reply-To: <20161129153408.GH12522@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

On 2016/11/30 0:34, David Sterba wrote:
> On Mon, Nov 28, 2016 at 04:27:06PM +0900, Tsutomu Itoh wrote:
>> Many test of xfstests such as btrfs/007, btrfs/008 and btrfs/016 failed
>> with the following patch.
>>
>>   fefbab75  btrfs-progs: send-stream: check number of read bytes from stream
>>
>> This is because cmds-receive.c:do_receive() make a judgement of the end
>> of stream by returning 1 from send-stream.c:read_buf().
>> So, when applying this patch, 'btrfs receive' will always output the
>> following message at the end of stream.
>>
>>   ERROR: short read from stream: expected 17 read 0
> 
> Thanks for the report, should be fixed in devel, I'm also adding more
> tests.

I tried devel branch, btrfs/007 works fine. Thanks for your work.
But I found another problem in current devel branch.

btrfs/008, btrfs/016 etc. fail due to the following patch, probably.

   btrfs-progs: rework option parser to use getopt for global options

Thanks,
Tsutomu

