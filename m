Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:36653 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752203AbcJNWRu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Oct 2016 18:17:50 -0400
Received: by mail-oi0-f50.google.com with SMTP id m72so152887075oik.3
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Oct 2016 15:17:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AM3PR08MB06421C9E387257BB6945837C92DF0@AM3PR08MB0642.eurprd08.prod.outlook.com>
References: <AM3PR08MB06423820D86D1E408FFD766492DC0@AM3PR08MB0642.eurprd08.prod.outlook.com>
 <905eb030-f8d8-b7cc-dd27-2f55e0d812c5@gmail.com> <AM3PR08MB06421C9E387257BB6945837C92DF0@AM3PR08MB0642.eurprd08.prod.outlook.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 14 Oct 2016 16:17:39 -0600
Message-ID: <CAJCQCtTnoHrY3ZwkDY1HN6wavfduFKxKa94F6iVQtaKtR2aJ-w@mail.gmail.com>
Subject: Re: Copy BTRFS volume to another BTRFS volume including subvolumes
 and snapshots
To: Alberto Bursi <alberto.bursi@outlook.it>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It should be -e can accept a listing of all the subvolumes you want to
send at once. And possibly an -r flag, if it existed, could
automatically populate -e. But the last time I tested -e I just got
errors.

https://bugzilla.kernel.org/show_bug.cgi?id=111221


-- 
Chris Murphy
