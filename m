Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34704 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaA1JQ2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 04:16:28 -0500
Message-ID: <52E777B4.6090906@oracle.com>
Date: Tue, 28 Jan 2014 17:26:12 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: update INSTALL file
References: <1390371577-1789-1-git-send-email-anand.jain@oracle.com> <20140127182729.GE6498@twin.jikos.cz>
In-Reply-To: <20140127182729.GE6498@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




  Yep. I had the same opinion as well but was hesitant
  to make wide changes unless understand the backaground.
  Now would try to re-write as a whole and review will help.

Thanks, Anand

On 01/28/2014 02:27 AM, David Sterba wrote:
> On Wed, Jan 22, 2014 at 02:19:37PM +0800, Anand Jain wrote:
>> --- a/INSTALL
>> +++ b/INSTALL
>> @@ -12,7 +12,8 @@ complete:
>>   modprobe libcrc32c
>>   insmod btrfs.ko
>>
>> -The Btrfs utility programs require libuuid to build.  This can be found
>> +The Btrfs utility programs (btrfs-progs) require libattr zlib libacl
>> +e2fsprogs libblkid lzo2 to build.  This can be found
>
> The following sentence does not make sense in the context of the
> extended list, also I think that the dependencies should be listed one
> per-line so it's more clear.
>
>>   in the e2fsprogs sources, and is usually available as libuuid or
>>   e2fsprogs-devel from various distros.
>
> The whole file looks very obsolete, mentions kernel module dependencies
> as well. Not a priority, but I wouldn't mind trimming the unrelated
> information and keep just what's related to userspace, eg. how to build,
> run local tests, where to find git sources.
>
