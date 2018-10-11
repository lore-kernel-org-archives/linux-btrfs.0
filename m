Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AC3DC43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 02:51:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2C172082B
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 02:51:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="eMuvAqYH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2C172082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbeJKKQJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 06:16:09 -0400
Received: from mail-lj1-f172.google.com ([209.85.208.172]:41299 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbeJKKQJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 06:16:09 -0400
Received: by mail-lj1-f172.google.com with SMTP id u21-v6so6760565lja.8
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Oct 2018 19:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=bFjC+vH/a+M3sEsMPiSfUtHm64cWdO7rKOEDU77G6uk=;
        b=eMuvAqYHTl9Ns/fJ043aO3SXQJ2xc6JZM2pA5Xk2MGS0J7ElV1uh7QO1OGZ0ZovtEe
         Ut2U2OCjGmsFSNuG3zjmhQ5MNN4U/BuLlrKHzP/x5PLDcZMFgPE8khpqlE7GJWkyZqgX
         BA+BFO5I2xL6vfVDhdVi/QRzCqV9bQNobgkGJr5IQsH8gOxxalcaQA0vWPpIjFHJrG00
         fhrzXR9PFuG7uIuJtVXBqcRZ/BNHtB5K1CfmAopORqDgDIIaqtBL2jSdR+8nB2T3s7Lf
         DX3/Mf7TqlG7V/sgIRzEyCNAuPceHDUdMV6blgxf/03ywte7iLejWukrExBKT1hIsh6H
         VHPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc;
        bh=bFjC+vH/a+M3sEsMPiSfUtHm64cWdO7rKOEDU77G6uk=;
        b=JcqiB625kSqwpH02jEoosZUo0Nl1yNHRHh8MKdN8MfdS3xpdVJLxrn+71vvn8uHuU+
         dFWgwAL0A3E7O8PSMdHZ/8zNdnUpO3SkEootKTzmRiG0KH6relTMJdPPwBU4mopH8MeN
         Wvv+ruKkBWJPyTE9PKwzSxQT37+qFBGCLfYKmR5ZjGsf2GHGfcfkQa/l75oEJ8WVS4Lz
         fPuq8y/NYbo+uuw7QYv9+1R7hcnU1pYfLiV929HHbyH2NwaDXvgYLfr/379mt/zavxKy
         t2GAwwWB5Erks6JeBg1VLE9U2wQ4fsewEwO50Wan3R+BDNkIOF3Jn/a+GACDNW3yfsSU
         dGnw==
X-Gm-Message-State: ABuFfoiexM5UF3pdQWbDyhaqCzFfBjo2G4KtOkCYhKlo68KVPWSrTJoQ
        jzTp8xG1j1nJru/PT2ysWSxEs3MfjCL7fA+vIrclzAFOJxs=
X-Google-Smtp-Source: ACcGV615DF1DFLT6w8KsWssCSX01SApTyo27+W2riUat1YH0oz0nx3KJmwTf6exVvDwAh2P/peKnmwMyuDAfQHBmjKM=
X-Received: by 2002:a2e:4408:: with SMTP id r8-v6mr24251222lja.21.1539226262213;
 Wed, 10 Oct 2018 19:51:02 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:1999:0:0:0:0:0 with HTTP; Wed, 10 Oct 2018 19:51:01
 -0700 (PDT)
X-Originating-IP: [69.7.113.20]
In-Reply-To: <9e6b268b-b545-bad1-f33a-b29ea1af7db0@nuclearwinter.com>
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
 <3725e6f2-b1ed-8d3d-aec7-1518dad1cb03@gmx.com> <3bf7c73d-ce25-88ce-271f-ab8c9ae6c01d@nuclearwinter.com>
 <3d82a2b9-41da-26b8-9b74-71d17d8a8a76@gmx.com> <273c99b2-d7e0-bea3-a4a4-7337115beb6f@nuclearwinter.com>
 <0136878c-d4ae-37b0-4903-601367286cf7@nuclearwinter.com> <e84595a6-b1c4-0698-b5d3-251165a11412@gmx.com>
 <CAJCQCtR-j3c99KSpsnUuy5yn5Jx7NAYGXmiDfcrZt4yc8ghCEA@mail.gmail.com>
 <cd4ffeae-0b06-f8ae-1a4e-1165428daee2@gmx.com> <9c7290ea-668d-c10a-9328-91adfac14d5a@nuclearwinter.com>
 <dd08eb00-faf8-cd88-aeb6-e5ed75a2889f@nuclearwinter.com> <4652a690-26ed-fb90-9386-3020ee9e9841@applied-asynchrony.com>
 <CAJCQCtTV3a9rH6ystLCbLUVoh4b1LL5yXWiOBPp6Fa28efZf_w@mail.gmail.com>
 <35ccf3c1-c18d-cce9-23b8-d24a35fe5549@mendix.com> <9e6b268b-b545-bad1-f33a-b29ea1af7db0@nuclearwinter.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 10 Oct 2018 20:51:01 -0600
X-Google-Sender-Auth: ZQMIvcqypThqzEU_TnLS0X35Dw8
Message-ID: <CAJCQCtSbLkpYnwEO05D5R2oXVznJ3KwBxjyfBDnM4PaGwSXUhg@mail.gmail.com>
Subject: Re: Scrub aborts due to corrupt leaf
To:     Larkin Lowrey <llowrey@nuclearwinter.com>
Cc:     Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        Chris Murphy <lists@colorremedies.com>,
        =?UTF-8?Q?Holger_Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 10, 2018 at 8:12 PM, Larkin Lowrey
<llowrey@nuclearwinter.com> wrote:
> On 10/10/2018 7:55 PM, Hans van Kranenburg wrote:
>>
>> On 10/10/2018 07:44 PM, Chris Murphy wrote:
>>>
>>>
>>> I'm pretty sure you have to umount, and then clear the space_cache
>>> with 'btrfs check --clear-space-cache=v1' and then do a one time mount
>>> with -o space_cache=v2.
>>
>> The --clear-space-cache=v1 is optional, but recommended, if you are
>> someone who do not likes to keep accumulated cruft.
>>
>> The v2 mount (rw mount!!!) does not remove the v1 cache. If you just
>> mount with v2, the v1 data keeps being there, doing nothing any more.
>
>
> Theoretically I have the v2 space_cache enabled. After a clean umount...
>
> # mount -onospace_cache /backups
> [  391.243175] BTRFS info (device dm-3): disabling free space tree
> [  391.249213] BTRFS error (device dm-3): cannot disable free space tree
> [  391.255884] BTRFS error (device dm-3): open_ctree failed

"free space tree" is the v2 space cache, and once enabled it cannot be
disabled with nospace_cache mount option. If you want to run with
nospace_cache you'll need to clear it.


>
> # mount -ospace_cache=v1 /backups/
> mount: /backups: wrong fs type, bad option, bad superblock on
> /dev/mapper/Cached-Backups, missing codepage or helper program, or other
> error
> [  983.501874] BTRFS info (device dm-3): enabling disk space caching
> [  983.508052] BTRFS error (device dm-3): cannot disable free space tree
> [  983.514633] BTRFS error (device dm-3): open_ctree failed

You cannot go back and forth between v1 and v2. Once v2 is enabled,
it's always used regardless of any mount option. You'll need to use
btrfs check to clear the v2 cache if you want to use v1 cache.


>
> # btrfs check --clear-space-cache v1 /dev/Cached/Backups
> Opening filesystem to check...
> couldn't open RDWR because of unsupported option features (3).
> ERROR: cannot open file system

You're missing the '=' symbol for the clear option, that's why it fails.




-- 
Chris Murphy
