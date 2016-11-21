Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:15309 "EHLO
        mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752262AbcKUAjy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 20 Nov 2016 19:39:54 -0500
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 9D5B5AC00E8
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Nov 2016 09:39:49 +0900 (JST)
Subject: Re: [PATCH 2/3] btrfs-progs: test: expand size of test device of
 fsck-tests 013
To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <201611180544.AA00017@WIN-5MHF4RKU941.jp.fujitsu.com>
 <201611180547.AA00018@WIN-5MHF4RKU941.jp.fujitsu.com>
 <965496ad-0b2c-31af-2de5-e47bd3c7d586@gmx.com>
 <20161118182829.GE12522@twin.jikos.cz>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <d16c8e9f-677b-5f06-c4f9-ce3dd283bf06@jp.fujitsu.com>
Date: Mon, 21 Nov 2016 09:39:34 +0900
MIME-Version: 1.0
In-Reply-To: <20161118182829.GE12522@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Qu and David,

On 2016/11/19 3:28, David Sterba wrote:
> On Fri, Nov 18, 2016 at 02:36:28PM +0800, Qu Wenruo wrote:
>>
>>
>> On 11/18/2016 01:47 PM, Tsutomu Itoh wrote:
>>> In my test environment, size of /lib/modules/`uname -r`/* is
>>> larger than 1GB, so test data can not copy to testdev.
>>> Therefore we need expand the size of testdev.
>>
>> IMHO the correct fix is to enhance populate_fs() to fill the fs into a 
>> given size, other than using the unreliable copy.
> 
> Yeah that would be better, the contents of the modules dir could be
> anything, but was enough to use for initial testing.

Thanks for your comments. I'll post v2 patch.

Thanks,
Tsutomu

