Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:47310 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389136AbeHPN7O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Aug 2018 09:59:14 -0400
From: David Howells <dhowells@redhat.com>
To: clm@fb.com
cc: dhowells@redhat.com, linux-btrfs@vger.kernel.org
Subject: Are the btrfs mount options inconsistent?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 16 Aug 2018 12:01:25 +0100
Message-ID: <31114.1534417285@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

I'm trying to convert btrfs to use the new mount API stuff and I'm finding it
hard to work out the relationships between some of the arguments, specifically
datacow, datasum and compress*.

What I see is that enabling datasum implies enabling datacow and that
disabling datacow implies disabling datasum - which seems reasonable.

However, selecting compression implies enabling datacow and datasum, and
disabling datacow, as one might expect, disables compression - but disabling
datasum does not.  Is that correct?

David
