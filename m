Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:56002 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751027AbcJGCwP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Oct 2016 22:52:15 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 8A288AC00D4
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Oct 2016 11:41:00 +0900 (JST)
Subject: Re: [PATCH] btrfs-progs: image: fix compiler warning
To: dsterba@suse.cz
References: <201610050807.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
 <20161006160045.GK6576@twin.jikos.cz>
Cc: linux-btrfs@vger.kernel.org
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <07aaf0c2-4130-c92a-c17d-29214d56cb31@jp.fujitsu.com>
Date: Fri, 7 Oct 2016 11:40:45 +0900
MIME-Version: 1.0
In-Reply-To: <20161006160045.GK6576@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/10/07 1:00, David Sterba wrote:
> On Wed, Oct 05, 2016 at 05:07:48PM +0900, Tsutomu Itoh wrote:
>> In v4.8-rc1, gcc 5.3.1 gives following warning. Fixed it.
>>
>>     [CC]     btrfs-image.o
>> btrfs-image.c: In function 'flush_pending':
>> btrfs-image.c:708:17: warning: 'start' may be used uninitialized in this function [-Wmaybe-uninitialized]
>>   header->bytenr = cpu_to_le64(start);
>>                  ^
>> btrfs-image.c:927:6: note: 'start' was declared here
>>   u64 start;
>>       ^
> 
> So the patch makes the compiler warning go away, but is the code
> correct? AFAICS, the warning points to the case where flush_pending is
> called with done=1 (from create_metadump) and there's zero
> md->pending_size . Are you sure this is an expected state and that the
> function can proceed with state = 0 ?
> 

I think that this is a case where some errors occurred before calling
flush_pending.
Therefore, create_metadump returns the error to the caller. (creating
the image fails, I think.)

Thanks,
Tsutomu

