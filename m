Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:55742 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750770AbdAQKpg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 05:45:36 -0500
Date: Tue, 17 Jan 2017 11:39:06 +0100
In-Reply-To: <5c66c74f-3c6d-b296-32ea-9263848ea16f@cn.fujitsu.com>
References: <1484183243.10253.5.camel@scientia.net> <a7b82ec9-bd8d-d6bb-27e7-3732b466ca06@cn.fujitsu.com> <1484188092.29002.4.camel@scientia.net> <25993bdf-d1fe-30df-7236-b9d5d6e5cfb2@cn.fujitsu.com> <1484499869.17186.1.camel@scientia.net> <4d7e21ed-a8f6-6c75-4a14-ff43201bd27b@cn.fujitsu.com> <1484535383.7577.53.camel@scientia.net> <657ea421-0058-b641-ef31-c7d371fa58ca@cn.fujitsu.com> <1484542415.21166.1.camel@scientia.net> <a0aad88a-e19e-e013-7533-4a5bf0783763@cn.fujitsu.com> <1484604435.7086.22.camel@scientia.net> <5c66c74f-3c6d-b296-32ea-9263848ea16f@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: Re: corruption: yet another one after deleting a ro snapshot
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
From: Christoph Anton Mitterer <calestyo@scientia.net>
Message-ID: <7A13A2CF-9D6F-40D7-9688-2A2460825428@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 17. Januar 2017 09:53:19 MEZ schrieb Qu Wenruo <quwenruo@cn.fujitsu.com>:
>Just lowmem false alert, as extent-tree dump shows complete fine
>result.
>
>I'll CC you and adds your reported-by tag when there is any update on 
>this case.

Fine, just one thing left right more from my side on this issue:
Do you want me to leave the fs untouched until I could verify a lowmem mode fix?
Or is it ok to go on using it (and running backups on it)? 

Cheers,
Chris.
