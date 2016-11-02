Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50106 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754146AbcKBAju (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Nov 2016 20:39:50 -0400
Subject: Re: [PATCH 3/3] btrfs-progs: Add command to check if balance op is
 req
To: dsterba@suse.cz, Graham Cobb <g.btrfs@cobb.uk.net>,
        linux-btrfs@vger.kernel.org
References: <1476750915-3105-1-git-send-email-divya.indi@oracle.com>
 <1476750915-3105-2-git-send-email-divya.indi@oracle.com>
 <1476750915-3105-3-git-send-email-divya.indi@oracle.com>
 <1476750915-3105-4-git-send-email-divya.indi@oracle.com>
 <c451366c-089c-5fe0-bfdb-ba3941f79d9d@cn.fujitsu.com>
 <84b80642-1c56-127c-ce1c-e38fd3bf0043@oracle.com>
 <20161028152005.GJ12522@twin.jikos.cz>
 <e0d9106a-3aa4-15df-dc97-81be7b4b687c@cobb.uk.net>
 <20161031163342.GP12522@twin.jikos.cz>
From: divya.indi@oracle.com
Message-ID: <d4965a6b-b3a8-7d12-aa63-5e7c6fc66a57@oracle.com>
Date: Tue, 1 Nov 2016 17:39:39 -0700
MIME-Version: 1.0
In-Reply-To: <20161031163342.GP12522@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/31/2016 09:33 AM, David Sterba wrote:
> On Fri, Oct 28, 2016 at 05:29:45PM +0100, Graham Cobb wrote:
>> On 28/10/16 16:20, David Sterba wrote:
>>> I tend to agree with this approach. The usecase, with some random sample
>>> balance options:
>>>
>>>   $ btrfs balance start --analyze -dusage=10 -musage=5 /path
>> Wouldn't a "balance analyze" command be better than "balance start
>> --analyze"? I would have guessed the latter started the balance but
>> printed some analysis as well (before or, probably more usefully,
>> afterwards).
> Right, separate command seems better.
What about btrfs inspect-internal bg_analysis (new name: 
show-block-groups)? It can still be a subcommand for inspect-internal?
So, wel have 2 new sub commands:
1) btrfs balance analyze
2) btrfs inspect-internal show-block-groups
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

