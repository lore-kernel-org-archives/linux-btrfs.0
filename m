Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61858 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbaJOXOp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 19:14:45 -0400
Received: by mail-wi0-f178.google.com with SMTP id h11so3554951wiw.17
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Oct 2014 16:14:44 -0700 (PDT)
From: Zach Brown <zab@zabbo.net>
To: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/4] some btrfs-progs coverity fixes
Date: Wed, 15 Oct 2014 16:14:17 -0700
Message-Id: <1413414861-28097-1-git-send-email-zab@zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi gang,

Here's another set of coverity fixes for btrfs-progs against David's 
integration-20141007 branch.

I got tired of adding error checking after a few so I moved on to the
other warnings.  Maybe we should subscribe linux-btrfs to the reports
that coverity can send out?

- z

