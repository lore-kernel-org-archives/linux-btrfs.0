Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1883CC61DD8
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Nov 2020 16:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFD04217A0
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Nov 2020 16:59:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgKMQ71 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 11:59:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:57080 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbgKMQ70 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Nov 2020 11:59:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CC88CAEAE;
        Fri, 13 Nov 2020 16:59:24 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DC9B7DA87A; Fri, 13 Nov 2020 17:57:41 +0100 (CET)
Date:   Fri, 13 Nov 2020 17:57:41 +0100
From:   David Sterba <dsterba@suse.cz>
To:     dsterba@suse.cz, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Anand Jain <anand.jain@oracle.com>,
        "syzbot+582e66e5edf36a22c7b0@syzkaller.appspotmail.com" 
        <syzbot+582e66e5edf36a22c7b0@syzkaller.appspotmail.com>
Subject: Re: [PATCH] btrfs: don't access possibly stale fs_info data for
 printing duplicate device
Message-ID: <20201113165741.GF6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Anand Jain <anand.jain@oracle.com>,
        "syzbot+582e66e5edf36a22c7b0@syzkaller.appspotmail.com" <syzbot+582e66e5edf36a22c7b0@syzkaller.appspotmail.com>
References: <2bb63b693331e27b440768b163a84935fe01edda.1605182240.git.johannes.thumshirn@wdc.com>
 <3454d885-21db-199a-76bf-0da6f9971671@suse.com>
 <SN4PR0401MB35987501AB13F33A9498D85D9BE70@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <20201113165305.GE6756@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113165305.GE6756@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 13, 2020 at 05:53:05PM +0100, David Sterba wrote:
> On Thu, Nov 12, 2020 at 12:09:52PM +0000, Johannes Thumshirn wrote:
> > On 12/11/2020 13:03, Nikolay Borisov wrote:
> > > Would a simple 'if()' here catch the case where fs_info is not
> > > initialized essentially open-coding what Anand has proposed? My idea is
> > > to be able to provide the filesystem id when we can (best effort) and
> > > simply use pr_warn otherwise, but without having to change the internals
> > > of btrfs_printk and instead handle the single problematic call site ?
> > > 
> > 
> > Unfortunately not, I've been trying to do that but the device->fs_info pointer
> > exists and accessing it triggers a KASAN splat.
> > 
> > Actually btrfs_printk() is already checking if fs_info is NULL or not to decide
> > whether to print <unknown> or fs_info->sb->s_id.
> > 
> > Another option would be to do btrfs_warn_in_rcu(NULL but that doesn't buy us a lot
> > more.
> 
> It does, not calling pr_warn and using the helpers that print the
> standard header. I really want to avoid using the raw pr_* functions if
> possible, in this case we can use the NULL parameter.
> 
> Previous discussion:
> https://lore.kernel.org/linux-btrfs/20200110090555.7049-1-anand.jain@oracle.com/t/#u
> 
> We can update btrfs_printk to leave out "(device %s)" completely in
> case there's no fs_info, and then switch everything to the helpers (there
> are still too many pr_* left).

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -240,9 +240,14 @@ void __cold btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, .
        vaf.fmt = fmt;
        vaf.va = &args;
 
-       if (__ratelimit(ratelimit))
-               printk("%sBTRFS %s (device %s): %pV\n", lvl, type,
-                       fs_info ? fs_info->sb->s_id : "<unknown>", &vaf);
+       if (__ratelimit(ratelimit)) {
+               if (fs_info) {
+                       printk("%sBTRFS %s (device %s): %pV\n", lvl, type,
+                                       fs_info->sb->s_id, &vaf);
+               } else {
+                       printk("%sBTRFS %s: %pV\n", lvl, type, &vaf);
+               }
+       }
 
        va_end(args);
 }
---


