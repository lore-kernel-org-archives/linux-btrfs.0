Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zimbra.karlsbakk.net ([82.211.30.250]:40736 "EHLO
        zimbra.karlsbakk.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754488AbdKOBGf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 20:06:35 -0500
Received: from localhost (localhost [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id ACE8AADE23A3
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Nov 2017 02:01:33 +0100 (CET)
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id 35R1WtqzZYW1 for <linux-btrfs@vger.kernel.org>;
        Wed, 15 Nov 2017 02:01:32 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 0F7B8ADE32D9
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Nov 2017 02:01:32 +0100 (CET)
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id 8QtezPjXR6ry for <linux-btrfs@vger.kernel.org>;
        Wed, 15 Nov 2017 02:01:31 +0100 (CET)
Received: from zimbra.karlsbakk.net (zimbra.karlsbakk.net [82.211.30.250])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id D4852ADE32D8
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Nov 2017 02:01:31 +0100 (CET)
Date: Wed, 15 Nov 2017 02:01:31 +0100 (CET)
From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To: linux-btrfs@vger.kernel.org
Message-ID: <2093578773.146320.1510707691482.JavaMail.zimbra@karlsbakk.net>
Subject: Tiered storage?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all

I've been following this project on and off for quite a few years, and I wonder if anyone has looked into tiered storage on it. With tiered storage, I mean hot data lying on fast storage and cold data on slow storage. I'm not talking about cashing (where you just keep a copy of the hot data on the fast storage).

And btw, how far is raid[56] and block-level dedup from something useful in production?

Vennlig hilsen

roy
--
Roy Sigurd Karlsbakk
(+47) 98013356
http://blogg.karlsbakk.net/
GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
--
Hið góða skaltu í stein höggva, hið illa í snjó rita.
