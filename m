Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63047 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752053AbaHSO6Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 10:58:16 -0400
Message-ID: <53F36601.5020609@fb.com>
Date: Tue, 19 Aug 2014 10:58:09 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Fengguang Wu <fengguang.wu@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, <lkp@01.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Abhay Sachan <lkp.abhay@gmail.com>
Subject: Re: [btrfs] 8d875f95: xfstests.generic.226.fail
References: <20140816075233.GA26842@localhost> <20140819115820.GA21418@localhost> <20140819142348.GU1553@twin.jikos.cz>
In-Reply-To: <20140819142348.GU1553@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/19/2014 10:23 AM, David Sterba wrote:
> On Tue, Aug 19, 2014 at 07:58:20PM +0800, Fengguang Wu wrote:
>> We noticed an xfstests failure on commit
>>
>> 8d875f95da43c6a8f18f77869f2ef26e9594fecc ("btrfs: disable strict file flushes for renames and truncates")
>>
>> It's 100% reproducible in the 5 test runs.
> 
> Same here, different mkfs configurations.
> 
> generic/226 28s ...    [16:11:52] [16:12:55] - output mismatch (see /root/xfstests/results//generic/226.out.bad)
>     --- tests/generic/226.out   2013-05-29 17:16:03.000000000 +0200
>     +++ /root/xfstests/results//generic/226.out.bad     2014-08-19 16:12:55.000000000 +0200
>     @@ -1,6 +1,8 @@
>      QA output created by 226
>      --> mkfs 256m filesystem
>      --> 16 buffered 64m writes in a loop
>     -1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
>     +1 2 3 4 pwrite64: No space left on device
>     +5 6 7 8 9 10 11 12 pwrite64: No space left on device
>     +13 14 15 16
> 
> enospc on a small filesystem (256M)

I'm calling filemap flush more often, but otherwise everything else is
the same.  I'll take a look.

-chris
