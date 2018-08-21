Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:30634 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbeHUKV7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 06:21:59 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 8524AAC0050
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Aug 2018 16:03:00 +0900 (JST)
Subject: Re: [PATCH v2 00/20] btrfs-progs: Rework of "subvolume list/show" and
 relax the root privileges of them
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        Omar Sandoval <osandov@fb.com>
References: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
 <20180815181211.GQ24025@twin.jikos.cz>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <749fa2f5-757b-e60f-b6fc-ea75ccf50c6d@jp.fujitsu.com>
Date: Tue, 21 Aug 2018 16:02:39 +0900
MIME-Version: 1.0
In-Reply-To: <20180815181211.GQ24025@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/08/16 3:12, David Sterba wrote:
> Hi,
> 
> so I've merged the first bath to devel. There was quite some whitespace
> damage and style issues, but I fixed that as I went through the pathes.

Thanks for taking this.

> 
> I've left out all patches that introduce new options, this is the hard
> part and single letter options cannot be added just randomly. That's
> what led to the current state.

Ok, but could you consider to add -f (11th path, or --follow instead of
short option) which is useful when btrfs is used for root fs
(or please remove cli-tests/010 for the moment from devel branch).

> 
> The semantics of current options is preserved, with the slight exception
> to the option -a.

Devel branch also excludes 13th patch and behavior of -a is not changed,
is it intended? Without the patch, there is no way to get the same result
of current "btrfs subvol list" when mount point is not FS_TREE.

> 
>> * Future todo:
>> If this approach is ok, I'd like to update the output of "sub list" more like:
>>   - Remove obsolete field (i.e. top-level) from output
> 
> Yeah the top-level field can be removed from the user output. Current
> idea of the fields printed by default is: id, generation, type, path.
> The type is a representation of eg. read-write status,
> subvolume/snapshot, and maybe received, or if it is default.
> 
> The remaining fields are on-demand by other options and the future proof
> solution is to provide the single option to specify which columns to
> print.
> 
> The inline format, ie. the current one, is not very comprehensive so the
> table layout should be the default for user.
> 
> The path format needs to be selected by a more concise way than just -A
> and possibly more added options. Eg. --path
> 
> * absolute (shorthand abs)
> * realative to the current path (pwd)
> * toplevel relative (toplevel)
> 
> In order to make it possible to distinguish in the output without prior
> knowledge of which one was selected, I propose this formatting:
> 
> * absolute path always starts with / and is really absolute to the /
> * relative path to the current directory starts with ./
> * toplevel does not start with ./ nor /
> 
> There are patches touching the libbtrfsutil code, so I'd like to hear
> from Omar what he thinks.

Also, I want to get acknowledgement about 7th patch
(as I wrote in cover letter, I'm ok with original version too).

> 
> What's now in devel should not change and provide base for further
> patches, so please use it if you're going to implement something from
> the above
Understood. I will consider them if current patches in devel has been settled.

Regards,
Misono
