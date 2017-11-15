Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zimbra.karlsbakk.net ([82.211.30.250]:48642 "EHLO
        zimbra.karlsbakk.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758173AbdKOOKT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 09:10:19 -0500
Date: Wed, 15 Nov 2017 15:10:08 +0100 (CET)
From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: waxhead@dirtcellar.net, linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <916739346.627.1510755008650.JavaMail.zimbra@karlsbakk.net>
In-Reply-To: <45d19817-ebf8-65ae-693f-2324ba637a67@gmail.com>
References: <2093578773.146320.1510707691482.JavaMail.zimbra@karlsbakk.net> <08cbefb3-43eb-8d76-1dd6-191e2709bdc7@dirtcellar.net> <45d19817-ebf8-65ae-693f-2324ba637a67@gmail.com>
Subject: Re: Tiered storage?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> As for dedupe there is (to my knowledge) nothing fully automatic yet.
>> You have to run a program to scan your filesystem but all the
>> deduplication is done in the kernel.
>> duperemove works apparently quite well when I tested it, but there may
>> be some performance implications.
> Correct, there is nothing automatic (and there are pretty significant
> arguments against doing automatic deduplication in most cases), but the
> off-line options (via the EXTENT_SAME ioctl) are reasonably reliable.
> Duperemove in particular does a good job, though it may take a long time
> for large data sets.
> 
> As far as performance, it's no worse than large numbers of snapshots.
> The issues arise from using very large numbers of reflinks.

What is this "large" number of snapshots? Not that it's directly comparible, but I've worked with ZFS a while, and haven't seen those issues there.

Vennlig hilsen

roy
--
Roy Sigurd Karlsbakk
(+47) 98013356
http://blogg.karlsbakk.net/
GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
--
Hið góða skaltu í stein höggva, hið illa í snjó rita.
