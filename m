Return-Path: <SRS0=ouMu=VA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C936C5B578
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Jul 2019 23:38:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 510842187F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Jul 2019 23:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfGCXiX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Jul 2019 19:38:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:47006 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726562AbfGCXiX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Jul 2019 19:38:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 34B4AAF58;
        Wed,  3 Jul 2019 23:38:22 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 917A1DA861; Thu,  4 Jul 2019 01:39:05 +0200 (CEST)
Date:   Thu, 4 Jul 2019 01:39:05 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v7 RESEND Rebased] btrfs-progs: dump-tree: add noscan
 option
Message-ID: <20190703233905.GX20977@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <20190626083017.1833-1-anand.jain@oracle.com>
 <20190703160907.GW20977@twin.jikos.cz>
 <EFB71435-3B86-46A8-90A1-9DCA2BEFF934@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <EFB71435-3B86-46A8-90A1-9DCA2BEFF934@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jul 04, 2019 at 06:16:54AM +0800, Anand Jain wrote:
> 
> 
> > On 4 Jul 2019, at 12:09 AM, David Sterba <dsterba@suse.cz> wrote:
> > 
> > On Wed, Jun 26, 2019 at 01:30:17AM -0700, Anand Jain wrote:
> >> From: Anand Jain <Anand.Jain@oracle.com>
> >> 
> >> The cli 'btrfs inspect dump-tree <dev>' will scan for the partner devices
> >> if any by default.
> >> 
> >> So as of now you can not inspect each mirrored device independently.
> >> 
> >> This patch adds noscan option, which when used won't scan the system for
> >> the partner devices, instead it just uses the devices provided in the
> >> argument.
> >> 
> >> For example:
> >>  btrfs inspect dump-tree --noscan <dev> [<dev>..]
> >> 
> >> This helps to debug degraded raid1 and raid10.
> >> 
> >> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> > 
> > This makes misc-test/021-image-multi-devices fail
> > 
> > ====== RUN CHECK root_helper mount /dev/loop2 .../btrfs-progs/tests//mnt
> > ====== RUN CHECK md5sum .../btrfs-progs/tests//mnt/foobar
> > md5sum: .../btrfs-progs/tests//mnt/foobar: Input/output error
> > failed: md5sum .../btrfs-progs/tests//mnt/foobar
> > ====== RUN CHECK root_helper umount .../btrfs-progs/tests//mnt
> > ====== RUN CHECK root_helper losetup -d /dev/loop2
> > ====== RUN CHECK root_helper losetup -d /dev/loop3
> > 
> > note the md5sum error, that does not happen otherwise
> 
> 
> I am on devel. It runs fine. Test-misc/021 doesn’t use dump-tree at all.
> Its strange that mnt/foobar fails to read in your case.

Sorry, I replied to the wrong patch, it's the other one "btrfs-progs:
dump-tree: add noscan option".
