Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 193A1C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 15:51:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E47F720827
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 15:51:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbfAHPvb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 10:51:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:36728 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728772AbfAHPvb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 10:51:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 851F1B059;
        Tue,  8 Jan 2019 15:51:29 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D2D0DDA7E8; Tue,  8 Jan 2019 16:50:56 +0100 (CET)
Date:   Tue, 8 Jan 2019 16:50:55 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: add a check for sysfs_create_group
Message-ID: <20190108155055.GH23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Kangjie Lu <kjlu@umn.edu>,
        pakki001@umn.edu, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20181226053744.74740-1-kjlu@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181226053744.74740-1-kjlu@umn.edu>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Dec 25, 2018 at 11:37:44PM -0600, Kangjie Lu wrote:
> In case sysfs_create_group fails, let's check its return value and
> issues an error message.

It's in a function that's not currently used and the sysfs code needs to
be reworked. The return code should be passed to the caller, printing
error message in this case may not be desired but I can't say right now.
