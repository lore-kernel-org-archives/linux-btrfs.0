Return-Path: <SRS0=YGKe=NF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B79A1C46475
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 11:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EFC22075D
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 11:18:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6EFC22075D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbeJYTul (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Oct 2018 15:50:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:40028 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727041AbeJYTul (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Oct 2018 15:50:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C72B9AEE1
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2018 11:18:19 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D9915DABAA; Thu, 25 Oct 2018 13:18:10 +0200 (CEST)
Date:   Thu, 25 Oct 2018 13:18:10 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: Deprecate unused super block member
 log_root_transid
Message-ID: <20181025111809.GB16290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181012064258.27033-1-wqu@suse.com>
 <20181012064258.27033-2-wqu@suse.com>
 <2b4ff29a-ff9b-8b56-ef13-4b76e72a281f@suse.com>
 <fbb5f43e-8eb0-08c6-a1c9-855efd960d3d@gmx.com>
 <cb6dd0fa-68e9-9e7c-c9cc-6ac609f9d9fc@suse.com>
 <152d099f-b431-b169-f33a-11ff7e88eee6@gmx.com>
 <20181024143015.GT16290@twin.jikos.cz>
 <f382295d-a203-ea33-5a1e-34553d8cb518@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f382295d-a203-ea33-5a1e-34553d8cb518@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 24, 2018 at 03:48:07PM +0100, Nikolay Borisov wrote:
> 
> 
> On 24.10.18 г. 15:30 ч., David Sterba wrote:
> > On Fri, Oct 12, 2018 at 05:57:29PM +0800, Qu Wenruo wrote:
> >>>>>> +	printf("log_root_transid (deprecated)\t%llu\n",
> >>>>>> +	       le64_to_cpu(sb->__unused_log_root_transid));
> >>>>>
> >>>>> This should be entirely removed.
> >>>>
> >>>> It looks OK to me.
> >>>> Just like the old leafsize.
> >>>>
> >>>> And if we try to use this member again, even old progs could show it
> >>>> without problem.
> >>>
> >>> But what is the point of having something which always shows 0 and is
> >>> essentially unused?
> >>
> >> Personally speaking, even it's in fact never used, it is still part of
> >> the specification of btrfs super blocks.
> >>
> >> Even it's a bad decision we made a long time ago, we still need to mark
> >> it as unused, other than converting it back to "reserved".
> >>
> >> To make it short and clear, if some member is specified in early
> >> specification, even it's never used, we still need to mark it unused and
> >> keep part of naming.
> > 
> > Agreed, follows the same patern as the leafsize. The superblock dump is
> > a debugging and bug report tool, the full output is desirable.
> 
> I really don't want to get into the argument but I think we should
> really name unused fields unusedX where X is some number. Looking at the
> code in struct btrfs_root_backup we have 2 unused fields. In the
> superblock we have unused space which is called 'reserved'. In struct
> btrfs_disk_balance_args there is a field called unused, same thing for
> struct btrfs_balance_item.
> 
> In btrfs_inode_item we have 'reserved' field, same thing for
> btrfs_root_item.
> 
> So the code base is yet again highly inconsistent and looking at it
> there is only a single field following the __unused_original_name, so
> it's really the exception rather than the rule.

You're right about the inconsistent namig, for the "reserved for future
use" members. This could be unified to "reserved", and even though it's
in a public header I would not expect any application using the items.

The __unused_original_name is a different kind of "unused", as it became
obsolete at some point and the bytes cannot be reused, unlike the
reserved ones.

It's an exception because it was the first instance, there was no
established rule/pattern to follow just a deliberate choice in the
naming so it captures the original purpose and current status.

> Again, I would argue that once a field is deprecated or in this case it
> has _never_ actually been used then we might as well rename it to
> something cryptic so as not to attach (false) meaning to it. Just my 50
> cents

The log_root_transid is a again different from leafsize. I don't know
what exactly you mean by the cryptic naming here, I'd rather keep the
name selfexplanatory. Using 'reserved' could be misleading and somebody
would want to use it for futher extensions.
