Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp73.iad3a.emailsrvr.com ([173.203.187.73]:42374 "EHLO
        smtp73.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932514AbdEKO4l (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 May 2017 10:56:41 -0400
Received: from smtp26.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp26.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 24DC75642
        for <linux-btrfs@vger.kernel.org>; Thu, 11 May 2017 10:56:41 -0400 (EDT)
Received: by smtp26.relay.iad3a.emailsrvr.com (Authenticated sender: intranet-AT-rqc.ru) with ESMTPSA id CD61554DF
        for <linux-btrfs@vger.kernel.org>; Thu, 11 May 2017 10:56:40 -0400 (EDT)
Received: from CM01.administration.intranet.rqc.ru (unknown [10.101.2.94])
        by postfix.thinky.servers.rqc.ru (Postfix) with ESMTPS id CA93E87BC
        for <linux-btrfs@vger.kernel.org>; Thu, 11 May 2017 14:56:38 +0000 (UTC)
To: linux-btrfs@vger.kernel.org
From: Marat Khalili <mkh@rqc.ru>
Subject: Backing up BTRFS metadata
Message-ID: <2b29db76-9199-0759-3477-58f0a67a3570@rqc.ru>
Date: Thu, 11 May 2017 17:56:38 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry if question sounds unorthodox, Is there some simple way to read 
(and backup) all BTRFS metadata from volume?

Motivation of course is possibility to quickly recover from catastrophic 
filesystem failures on a logical level. Some small amount of actual data 
that this metadata references may be overwritten between backup and 
restore moments, but due to checksumming it can easily be caught (and 
either individually restored from backup or discarded).

--

With Best Regards,
Marat Khalili
