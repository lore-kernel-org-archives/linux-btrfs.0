Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18237 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752173AbdG1O5m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Jul 2017 10:57:42 -0400
Subject: Re: [PATCH v3] Btrfs: add skeleton code for compression heuristic
To: dsterba@suse.cz, Adam Borowski <kilobyte@angband.pl>,
        Roman Mamedov <rm@romanrm.net>,
        Timofey Titovets <nefelim4ag@gmail.com>, linux-btrfs@vger.kernel.org
References: <20170717135258.15865-1-nefelim4ag@gmail.com>
 <20170717183035.GR2866@twin.jikos.cz>
 <f85d6fa7-4d1e-bfb8-7e64-ef02c468e42d@oracle.com>
 <20170721233749.5175d611@natsu> <20170721210027.3qoexc63zcbbnqxl@angband.pl>
 <20170724145356.GX2866@twin.jikos.cz>
 <950a249d-9fb2-103a-0101-d37e6609ba8f@oracle.com>
 <20170727153653.GO2866@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <597B445B.9070107@oracle.com>
Date: Fri, 28 Jul 2017 23:04:11 +0900
MIME-Version: 1.0
In-Reply-To: <20170727153653.GO2866@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 28/07/2017 00:36, David Sterba wrote:
> On Mon, Jul 24, 2017 at 11:40:17PM +0800, Anand Jain wrote:
>>
>>> Eg. files that are already compressed would increase the cpu consumption
>>> with compress-force, while they'd be hopefully detected as
>>> incompressible with 'compress' and clever heuristics. So the NOCOMPRESS
>>> bit would better reflect the status of the file.

  I thought 'compress' in above, is the compress option. Ah you mean
  to say compression algo .. got it. Right compress-force for
  incompressible-data is very expensive.

  And its also true that compress option for incompressible data is
  not at all expensive and its only one time.

>>    current NOCOMPRESS is based on trial and error method and is more
>>    accurate than heuristic also loss of cpu power is only one time ?


> Curreently, force-compress beats everything, so even a file with
> NOCOMPRESS will be compressed, all new writes will be passed to the
> compression and stored uncompressed eventually.

  It makes sense to me when you replace NOCOMPRESS with
  incompressible-data in the above statement. As in my understanding..

  You will never have a file with NOCOMPRESS flag if compress-force
  option is used.


> Each time they
> compression code will run and fail, so it's not one time.
>
> Although you can say it's more 'accurate', it's also more expensive.

   yes. Expensive only in compress-force.

>>    May be the only opportunity that heuristic can facilitate is at the
>>    logic to monitor and reset the NOCOMPRESS, as of now there is no
>>    such a logic.
>
> The heurictic can be made adaptive, and examine data even for NOCOMPRESS
> files, but that's a few steps ahead of where we are now.

   Nice.

Thanks, Anand

