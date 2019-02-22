Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F1BCC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 18:04:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CC582070D
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 18:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727532AbfBVSEh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 13:04:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:37942 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726833AbfBVSEg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 13:04:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ADF40ADE1
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 18:04:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 29B3BDAA56; Fri, 22 Feb 2019 19:05:54 +0100 (CET)
Date:   Fri, 22 Feb 2019 19:05:54 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Johannes Thumshirn <jthumshirn@suse.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 1/6] btrfs: Refactor cow_file_range_async
Message-ID: <20190222180553.GK9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-btrfs@vger.kernel.org
References: <20190221115717.5128-1-nborisov@suse.com>
 <20190221115717.5128-2-nborisov@suse.com>
 <aaaf4399-7acd-1726-c579-19a9285c337f@suse.de>
 <ca7d67fb-8f64-d6c5-97f1-cff2de91f411@suse.com>
 <49f1484a-e4c3-70cf-c443-708e916c4f90@suse.de>
 <f5023c11-9fc2-6470-d04b-828b38880cea@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f5023c11-9fc2-6470-d04b-828b38880cea@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 21, 2019 at 05:09:01PM +0200, Nikolay Borisov wrote:
> On 21.02.19 г. 17:07 ч., Johannes Thumshirn wrote:
> > On 21/02/2019 14:25, Nikolay Borisov wrote:
> >> On 21.02.19 г. 15:15 ч., Johannes Thumshirn wrote:
> >>> On 21/02/2019 12:57, Nikolay Borisov wrote:
> >>>>  
> >>>>  static int cow_file_range_async(struct inode *inode, struct page *locked_page,
> >>>> @@ -1190,45 +1201,68 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
> >>>>  				unsigned int write_flags)
> >>>>  {
> >>>>  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
> >>>> -	struct async_cow *async_cow;
> >>>> +	struct async_cow *ctx;
> >>>> +	struct async_chunk *async_cow;
> >>>
> >>> In case you have to re-send the patch you could maybe rename the
> >>> async_cow variable to async_chunk or sth like that. Would make the
> >>> resulting code a little bit clearer but no strong opinions here.
> >>
> >> The reason I left it like that is to minimize the resulting diff.
> > 
> > Understood, but now we have a 'ctx' of type 'struct async_cow' and a
> > '*async_cow' of type 'struct asyn_chunk'. This is the type of code that
> > will make people go WTF when they read it in 3-4 cycles.
> 
> I also thought of that but then sometimes David has strange tastes re.
> code cleanups that add noise. If he is fine with doing the rename in
> this patch then I'm happy to do it and resend.

You must be joking, the naming you chose is quite confusing exactly as
Johannes points out.

I'm not sure what noise patches or changes you mean. There are commits
that just rename something for better readability or free the
type/variable name for another purpose, similar what you do.

Your concern about diff size is ok, though it should result in a
separate patch doing just the rename and another patch using the new
async_cow.
