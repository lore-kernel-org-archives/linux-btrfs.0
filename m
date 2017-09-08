Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:36959 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757115AbdIHUyW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Sep 2017 16:54:22 -0400
Received: by mail-wr0-f173.google.com with SMTP id k20so6437874wre.4
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Sep 2017 13:54:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f6cdd705-49a0-5a1a-da24-4b28fa13ac46@gmail.com>
References: <20170908085446.GA7876@rus.uni-stuttgart.de> <20170908131035.GO31874@twin.jikos.cz>
 <CABB28Cz6wb0gvFF3sAUG5fw2JfgiB3KGGKfzOwAW0_2xBRcEFQ@mail.gmail.com>
 <20170908153816.GD23980@carfax.org.uk> <20170908163939.GS31874@twin.jikos.cz>
 <CABB28CzBPffVMr5LW3x6Fhsj854X-=9h3H6uQ_fbVGy+TMh-jg@mail.gmail.com> <f6cdd705-49a0-5a1a-da24-4b28fa13ac46@gmail.com>
From: =?UTF-8?Q?Tomasz_K=C5=82oczko?= <kloczko.tomasz@gmail.com>
Date: Fri, 8 Sep 2017 21:54:20 +0100
Message-ID: <CABB28Cxf42y7DfHQ-WK381qyEZsQ4Coe3g_=WfFeN5MgGYmVaQ@mail.gmail.com>
Subject: Re: test if a subvolume is a snapshot?
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8 September 2017 at 20:06, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
[..]
>> If you don't like awk you can use jq, sed, perl, python, ruby or
>> whatever you have/like/want.
>
> And which command is more readable?  Something like the above, or:
> btrfs device stats --format=json /

How many people you know who are communicating in json or using comma
separated lines of text?
Maybe it is not obvious but such interface is not for the humans.

kloczek
-- 
Tomasz Kłoczko | LinkedIn: http://lnkd.in/FXPWxH
