Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:52113 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754272AbcKBBMW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Nov 2016 21:12:22 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 4B64DAC0109
        for <linux-btrfs@vger.kernel.org>; Wed,  2 Nov 2016 10:12:10 +0900 (JST)
Subject: Re: [PATCH 2/3] btrfs-progs: send: fix handling of multiple snapshots
 (-p option)
To: dsterba@suse.cz
References: <201610190235.AA00002@WIN-5MHF4RKU941.jp.fujitsu.com>
 <20161028151014.GI12522@twin.jikos.cz>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <428f2f2b-39d3-8dc9-705c-a3021a040f06@jp.fujitsu.com>
Date: Wed, 2 Nov 2016 10:11:55 +0900
MIME-Version: 1.0
In-Reply-To: <20161028151014.GI12522@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry for the late reply.

On 2016/10/29 0:10, David Sterba wrote:
> On Wed, Oct 19, 2016 at 11:35:03AM +0900, Tsutomu Itoh wrote:
>> We cannot send multiple snapshots at once by -p option.
> 
> We cannot like that it's broken, or we cannot because it's not supposed
> to work that way. I guess it's the former, but the changelog text is a
> bit confusing.

Sorry, I'm not good at English.

>>
>> [before]
>> # btrfs send -f /tmp/data0 -p Snap0 Snap[12]
>> At subvol Snap1
>> At subvol Snap2
>> ERROR: parent determination failed for 0
>> # 
>>
>> [after]
>> # btrfs send -f /tmp/data0 -p Snap0 Snap[12]
>> At subvol Snap1
>> At subvol Snap2
>> # 
> 
> I'm not sure it's fixed, I wrote a simple test, attached, that triggers
> the bug even with the patch applied.
> 

In the attached script,

   run_check $SUDO_HELPER btrfs send -f "$here"/send.stream -p subv-snap1 subv-snap2 subv-snap3

I think that 'btrfs' is a mistake of '$TOP/btrfs'.

Thanks,
Tsutomu

