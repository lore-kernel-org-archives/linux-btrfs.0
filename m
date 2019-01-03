Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E73F2C43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 23:22:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD035208E3
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 23:22:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfACXWq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 18:22:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:41856 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725931AbfACXWq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Jan 2019 18:22:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7DBFEB020
        for <linux-btrfs@vger.kernel.org>; Thu,  3 Jan 2019 23:22:45 +0000 (UTC)
From:   David Disseldorp <ddiss@suse.de>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/1] btrfs-progs: btrfstune: print seeding status
Date:   Fri,  4 Jan 2019 00:22:38 +0100
Message-Id: <20190103232239.11931-1-ddiss@suse.de>
X-Mailer: git-send-email 2.13.7
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

AFAICT there's currently no way to easily determine whether or not
seeding is enabled for a given device. The following patch adds new
"btrfstune -s" functionality to perform this.

An xfstests test case will follow if/when the interface is deemed
acceptable.

Cheers, David

