Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:46617 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbeIEROG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Sep 2018 13:14:06 -0400
Subject: Re: fsck lowmem mode only: ERROR: errors found in fs roots
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Su Yue <suy.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <8d8c90d3edfcc9e73428d3730496d48b1160b39b.camel@scientia.net>
 <a141cad2-0a08-555e-eb05-da2dceb54025@cn.fujitsu.com>
 <7146cafcc48d46ad123388d492807cbba08e101c.camel@scientia.net>
 <94750beb-c339-756a-11ec-f2bcc72b98e3@cn.fujitsu.com>
 <37c6a0bd07091b71ead2650bc8e82a02dfffd5b3.camel@scientia.net>
From: Su Yue <Damenly_Su@gmx.com>
Message-ID: <0bd068c3-ecbe-65ce-fd97-7b5063da4632@gmx.com>
Date: Wed, 5 Sep 2018 20:43:46 +0800
MIME-Version: 1.0
In-Reply-To: <37c6a0bd07091b71ead2650bc8e82a02dfffd5b3.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/9/5 8:33 PM, Christoph Anton Mitterer wrote:
> On Wed, 2018-09-05 at 15:04 +0800, Su Yue wrote:
>> Agreed with Qu, btrfs-check shall not try to do any write.
> 
> Well.. it could have been just some coincidence :-)
> 
> 
>> I found the errors should blame to something about inode_extref check
>> in lowmem mode.
> 
> So you mean errors in btrfs-check... and it was a false positive?
> 
Not so perfect original and lowmem mode of btrfs-check are.
I need to figure out what is on the actual FS, may a false alert or 
actual error.

> 
>> I have writeen three patches to detect and report errors about
>> inode_extref. For your convenience, it's based on v4.17:
>> https://github.com/Damenly/btrfs-progs/tree/ext_ref_v4.17
> 
> I hope I can test them soon.... could take a bit longer as I'm about to
> head off into vacation.
> 
Fine, of course. Enjoy it :)

Thanks,
Su
> 
> Cheers,
> Chris.
> 
