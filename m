Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57364 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755899AbeASSWj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Jan 2018 13:22:39 -0500
Subject: Re: [PATCH v2 09/10] Btrfs: add tracepoint for em's EEXIST case
To: dsterba@suse.cz, Liu Bo <bo.li.liu@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <20180105195117.5131-1-bo.li.liu@oracle.com>
 <20180105195117.5131-10-bo.li.liu@oracle.com>
 <20180119181539.GA15713@twin.jikos.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <f263a361-1e58-0bb0-9be4-c6c362f78e73@suse.com>
Date: Fri, 19 Jan 2018 20:22:36 +0200
MIME-Version: 1.0
In-Reply-To: <20180119181539.GA15713@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.01.2018 20:15, David Sterba wrote:
> On Fri, Jan 05, 2018 at 12:51:16PM -0700, Liu Bo wrote:
>> This is adding a tracepoint 'btrfs_handle_em_exist' to help debug the
>> subtle bugs around merge_extent_mapping.
>>
>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> 
> Nikolay has some concernas about adding the tracepoint, so I'll leave
> this patch out of the series for now as we should decide how to proceed.
> 
> Thacepoints are considered an ABI by some and not ABI by others. I think
> it's a good addition to the debugging aids that also may turn out to be
> useful for evaluating performance later.
> 
> At minimum we could add some prefix/suffix to the debugging tracepoint
> name, so we can let developers add what they need right away.
> 


My concern specifically has to do with the fact that if tracepoints are
considere ABI then whatever decision we make now will be cast in stone
and if we juggle the code around we will still have to retain the format
of the tracepoint. If, OTOH we are able to remove and change the
tracepoint as we see fit - then it's okay. Otherwise we risk polluting
the code
