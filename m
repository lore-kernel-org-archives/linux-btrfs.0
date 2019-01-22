Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C1AC282C3
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 16:28:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB0782085A
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 16:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729135AbfAVQ2q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Jan 2019 11:28:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:44102 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728580AbfAVQ2q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Jan 2019 11:28:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7B3BBB07F
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2019 16:28:45 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C4906DA84A; Tue, 22 Jan 2019 17:28:10 +0100 (CET)
Date:   Tue, 22 Jan 2019 17:28:08 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
Message-ID: <20190122162807.GL2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190115081604.785-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190115081604.785-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 15, 2019 at 04:15:57PM +0800, Qu Wenruo wrote:
> This patchset can be fetched from github:
> https://github.com/adam900710/linux/tree/qgroup_delayed_subtree
> 
> Which is based on v5.0-rc1.
> 
> This patch address the heavy load subtree scan, but delaying it until
> we're going to modify the swapped tree block.

I'd like to merge this patchset, the overall logic is fine but I've
found lots of coding style issues, too many to fix them just myself.

> v4:
> - Renaming members from "file_*" to "subv_*".
>   Members like "file_bytenr" is pretty confusing, renaming it to
>   "subv_bytenr" avoid the confusion.

The naming change is incomplete, there are many more references to 'file
tree' in comments and changelogs, the naming should be unified
everywhere. Also I'd prefer to use 'subvol' though it's a bit longer
than 'subv', the former seems to be the most common form.

I'll comment the patches with the rest.
