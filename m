Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:49700 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726679AbeHURGo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 13:06:44 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <31114.1534417285@warthog.procyon.org.uk>
References: <31114.1534417285@warthog.procyon.org.uk>
To: linux-btrfs@vger.kernel.org
Cc: dhowells@redhat.com, clm@fb.com
Subject: Do btrfs compression option changes need to be atomic?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 21 Aug 2018 14:46:30 +0100
Message-ID: <476.1534859190@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Should changes to the compression options on a btrfs mount be atomic, the
problem being that they're split across three variables?

Further to that, how much of an issue is it if the configuration is split out
into its own struct that is accessed from struct btrfs_fs_info using RCU?

David
