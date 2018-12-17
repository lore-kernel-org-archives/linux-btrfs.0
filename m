Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF893C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 14:51:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C953E206A2
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 14:51:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733150AbeLQOvL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 09:51:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:54230 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732267AbeLQOvL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 09:51:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E7867AC90;
        Mon, 17 Dec 2018 14:51:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6F0E7DA781; Mon, 17 Dec 2018 15:50:46 +0100 (CET)
Date:   Mon, 17 Dec 2018 15:50:45 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs: add kernel scrub log messages
Message-ID: <20181217145044.GR23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <1545016512-4336-1-git-send-email-anand.jain@oracle.com>
 <9e245d4b-e198-99d4-95b9-d3b1c3b5e11b@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9e245d4b-e198-99d4-95b9-d3b1c3b5e11b@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 17, 2018 at 08:39:08AM +0200, Nikolay Borisov wrote:
> 
> 
> On 17.12.18 г. 5:15 ч., Anand Jain wrote:
> > scrub kernel messages helps debug and audit, add them to the log.
> > 
> > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> > ---
> >  fs/btrfs/scrub.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> > index 902819d3cf41..d7a92521019e 100644
> > --- a/fs/btrfs/scrub.c
> > +++ b/fs/btrfs/scrub.c
> > @@ -3876,6 +3876,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
> >  	mutex_unlock(&fs_info->scrub_lock);
> >  
> >  	if (!is_dev_replace) {
> > +		btrfs_info(fs_info, "scrub: devid %llu %s", devid, "started");
> 
> Perhahps those messages needs to be with btrfs_debug, since they are
> only really useful when someone is debugging otherwise we will make
> btrfs rather noisy.

I've heared complaints about too noisy and not enough information in the
log. The compromise is to use INFO level as it's the last before DEBUG.

Compare output of 'dmesg' on a system that passed fstests with

  dmesg -l emerg,alert,crit,err,warn

and

  dmesg -l emerg,alert,crit,err,warn,notice,info

In the first one you'll see conditions that are worth user attention
(something's wrong, something needs to be fixed), while in the other
not. If you find something that's not at the right level considering the
visibility, please send a patch.
