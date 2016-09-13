Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:36842 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760181AbcIMTjL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Sep 2016 15:39:11 -0400
Received: by mail-oi0-f53.google.com with SMTP id q188so283392818oia.3
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Sep 2016 12:39:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a74b20fd-9640-b543-c31c-d475a51dcc57@gmail.com>
References: <a74b20fd-9640-b543-c31c-d475a51dcc57@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 13 Sep 2016 13:39:09 -0600
Message-ID: <CAJCQCtQOAzx5fgpaDs6_hy1cPED=nPLE87bkji+VgGeoqG2+pw@mail.gmail.com>
Subject: Re: Filesystem forced to readonly after use
To: Cesar Strauss <cestrauss@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just wouldn't use btrfs repair with this version of progs, go back
to v4.6.1 or upgrade to 4.7.2.  You could do an offline check (no
repair) and see if that reveals anything useful for developers. But I
can't tell what's going on from the call trace.



-- 
Chris Murphy
