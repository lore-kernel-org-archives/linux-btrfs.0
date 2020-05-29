Return-Path: <SRS0=XB0s=7L=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7FD3C433E0
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 May 2020 15:55:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88D4A2072D
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 May 2020 15:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgE2PzD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 May 2020 11:55:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:52584 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbgE2PzD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 May 2020 11:55:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 45E54ACFE;
        Fri, 29 May 2020 15:55:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 54675DA7BD; Fri, 29 May 2020 17:55:01 +0200 (CEST)
Date:   Fri, 29 May 2020 17:55:00 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Damian Stevenson <stevensondam@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: Warn to terminal that subvolume is default on deletion intent
Message-ID: <20200529155500.GS18421@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Damian Stevenson <stevensondam@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CADAn_AF=p2mQ2p3KsRes-CCFHS+VPHZsVg1L7S=wtFMF4ZOzqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADAn_AF=p2mQ2p3KsRes-CCFHS+VPHZsVg1L7S=wtFMF4ZOzqw@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, May 29, 2020 at 05:14:20PM +0200, Damian Stevenson wrote:
> # Error description
> Trying to delete subvolume which is set as default, not allowed.
> States reason to dmesg but not to terminal.
> 
> # Request:
> Output to terminal as well, the reason why can't delete subvolume. In
> example: because subvolume is set as default on deletion intent. As
> user I didn't knew I had to follow dmesg, read it just out of luck.

Thanks for the detailed report. You're right, this should be printed as
an error message.

> # On deletion intent
> sudo btrfs subvolume delete /drive/newvol/
> Delete subvolume (no-commit): '/drive/newvol'
> ERROR: Could not destroy subvolume/snapshot: Operation not permitted

This is easy to fix, if anybody wants to take it, if the subvolume
deletion returns -1 and EPERM, then check if the subvolume is default
(btrfs_util_get_default_subvolume_fd) and then print the message.

Additionally, if there's EPERM and the subvolume is not default, it's
either race (the subvolume lost the default status meanwhie), or there's
send in progress. As this could be also confusing, fixing both would be
welcome.

> https://bugzilla.kernel.org/show_bug.cgi?id=207975

I've cross-referenced in github/btrfs-progs issue.
