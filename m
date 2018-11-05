Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03DD0C0044C
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 21:27:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B89162081C
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 21:27:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F5deEllX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B89162081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387600AbeKFGso (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Nov 2018 01:48:44 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35852 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387441AbeKFGso (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Nov 2018 01:48:44 -0500
Received: by mail-qt1-f194.google.com with SMTP id u34-v6so332631qth.3;
        Mon, 05 Nov 2018 13:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to;
        bh=DcC0pFPJZUeRip5hRD3kg2PTYmCGhavKEeGXEMus5o4=;
        b=F5deEllXvSPfhYZiDN3+CbB3Y8uCng/SkYw1W6qt5LMNSMOLaA/xxUAO2Z5GpPf3jg
         VEWO6ulpbcCxkfcFyTF19OoDgqOXtTzMveU1U0zI0QJvwTGS4NNemYOg9ven6NaCc5KX
         JTv2fOh7VEVLlLZZyWNUdnjI37oZlgehfGI9asvqjG7la0l45jTa4HYfZdlGWszUKcQo
         5fwp+ltVVqNIYGRoiGi0mMn09v8AoFUhL9ZJeNP3WsZHTn41CGMDIRZr2zo+D+iY2RPC
         7wjpTy0/IO/isd8oIEUZOZkFpeXMcLd2KgEmngtQmy22RS6d9e4I667WS6BnZYkrvBnw
         eZxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to;
        bh=DcC0pFPJZUeRip5hRD3kg2PTYmCGhavKEeGXEMus5o4=;
        b=cc/YJllda5EUXRgeTOKCYRuNzgCo8L3lH8UO9f20cHu6n15Pailt5BFeCT5iseaSGK
         2yVzwYWWr+Ujd7auZSGwLxcx1kqlqSFrinJ0LiPO+BhkqXBChp6AK4uJP1IJFkFUlykP
         A1CLdGzkzvHRwKkDmpQJFWpY7IpndAav9UgRC5jvL+RJpoxb8OnThOQyswOeFMjBv6M+
         GW9rSv+FYwz/BLSoq7SXVTw76AYGsIJ5n1XOea9gMQz8nZbdKDxGIsX0c5DJ5UE7uvCw
         teStXMQ5L0B1I63F00Vhn0GreWs46VCf0PxGQ0/5r8Y58N4Rr8im9KkoomU4CIuDD3gk
         DBsQ==
X-Gm-Message-State: AGRZ1gKV9SX86Zi4NKe4YpZhKEvrxaI4byKNDZgPvMOALZ1wZ0DXetUP
        4Zie8Ne7rzxZ8oKF3YnvsaZUpBIke5xig1ZN6IU=
X-Google-Smtp-Source: AJdET5evkQbUdcsJFfbYhrNf+M8HKFWaG2DQHY6mouCutNPbRl56iie29hv2Xr44hnUtm1C7o9XoE4lF5Fw6bCtusko=
X-Received: by 2002:ac8:2c34:: with SMTP id d49mr9137840qta.152.1541453223591;
 Mon, 05 Nov 2018 13:27:03 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a0c:9881:0:0:0:0:0 with HTTP; Mon, 5 Nov 2018 13:27:03 -0800 (PST)
In-Reply-To: <20181105165137.GD9136@twin.jikos.cz>
References: <20181103153941.1881966-1-arnd@arndb.de> <87d4e8ce-2142-9d6e-498a-c7e5b83964eb@suse.de>
 <CAK8P3a27sNTiKV--smXd1wUzkGY70uUhS1rif6tgUobE+YYcbw@mail.gmail.com> <20181105165137.GD9136@twin.jikos.cz>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 5 Nov 2018 22:27:03 +0100
X-Google-Sender-Auth: FnefEmTeg2DUO85lXz-xw4VUaIc
Message-ID: <CAK8P3a3QQY3EqcdpogDR0TzPg61=y24aCYRpWWZGLe15GGPvdA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: avoid link error with CONFIG_NO_AUTO_INLINE
To:     dsterba@suse.cz, Arnd Bergmann <arnd@arndb.de>,
        Qu Wenruo <wqu@suse.de>, Chris Mason <clm@fb.com>,
        David Sterba <DSterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Gu Jinxiang <gujx@cn.fujitsu.com>,
        Changbin Du <changbin.du@gmail.com>,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        Anand Jain <anand.jain@oracle.com>,
        Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 11/5/18, David Sterba <dsterba@suse.cz> wrote:
> On Sun, Nov 04, 2018 at 11:32:03PM +0100, Arnd Bergmann wrote:
>> >> Cc: Changbin Du <changbin.du@gmail.com>
>> >> Fixes: 943b8435c3bd ("kernel hacking: add a config option to disable
>> >> compiler auto-inlining")
>> >
>> > I can't find it in the mainline kernel, is the commit hash correct?
>> > If not merged, we should still has a chance to further polish that
>> > patch.
>>
>> It's in linux-next.
>
> I can't find it in current linux-next either, the final reference in
> Fixes: must refer to a commit in Linus' tree.

Ah, right, it got rebased. The commit ID in today's linux-next
is 917fad29febd. Most trees in linux-next don't rebase so this
would not be an issue, but you are right that this one clearly
did, so the line is wrong here.

The commit is now delayed until 4.21 I assume.

> You can take this fix with the patch that introduces the config option
> (ack for that) in case merging through the btrfs tree would be too late
> for it (ie. no common base for the git trees containg the new code and
> fix).
>
> Or I can take it through btrfs tree in 4.20-rc cycle. In both cases the
> Fixes: does not need to be there.

Please take it through the btrfs tree. Let me know if you need me
to extend the changelog to explain that situation better.

      Arnd
