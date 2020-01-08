Return-Path: <SRS0=jJu9=25=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A3CC282DD
	for <linux-btrfs@archiver.kernel.org>; Wed,  8 Jan 2020 17:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8F5C20692
	for <linux-btrfs@archiver.kernel.org>; Wed,  8 Jan 2020 17:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbgAHRrO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 8 Jan 2020 12:47:14 -0500
Received: from pme1.philip-seeger.de ([194.59.205.51]:34788 "EHLO
        pme1.philip-seeger.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbgAHRrN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jan 2020 12:47:13 -0500
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jan 2020 12:47:13 EST
Received: from webmail.philip-seeger.de (pme1.philip-seeger.de [IPv6:2a03:4000:34:141::100])
        by pme1.philip-seeger.de (Postfix) with ESMTPSA id 8BB581FBB92
        for <linux-btrfs@vger.kernel.org>; Wed,  8 Jan 2020 18:41:36 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 08 Jan 2020 18:41:36 +0100
From:   philip@philip-seeger.de
To:     linux-btrfs@vger.kernel.org
Subject: Monitoring not working as "dev stats" returns 0 after read error
 occurred
Message-ID: <3283de40c2750cd62d020ed71430cd35@philip-seeger.de>
X-Sender: philip@philip-seeger.de
User-Agent: Roundcube Webmail/1.3.8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

A bad drive caused i/o errors, but no notifications were sent out 
because "btrfs dev stats" fails to increase the error counter.

When checking dmesg, looking for something completely different, there 
were some error messages indicating that this drive is causing i/o 
errors and may die soon:

BTRFS info (device sda3): read error corrected: ino 194473 off 2170880

But checking the stats (as generally recommended to get notified about 
such errors) claims that no errors have occurred (nothing to see here, 
keep moving):

# btrfs dev stats / | grep sda3 | grep read
[/dev/sda3].read_io_errs 0

Why?
Isn't that the most important feature of a RAID system - to get notified 
about errors, to be able to replace such a drive...?

The fs is mirrored, so those errors didn't cause any data loss.

# uname -sr
Linux 5.2.7-100.fc29.x86_64
# btrfs --version
btrfs-progs v5.1


