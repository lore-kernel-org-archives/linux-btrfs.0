Return-Path: <SRS0=Sb/y=M2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79DEDC7112A
	for <linux-btrfs@archiver.kernel.org>; Sun, 14 Oct 2018 18:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37A372077C
	for <linux-btrfs@archiver.kernel.org>; Sun, 14 Oct 2018 18:10:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="z56k+akY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37A372077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbeJOBv6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 14 Oct 2018 21:51:58 -0400
Received: from mail-lj1-f178.google.com ([209.85.208.178]:33713 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbeJOBv6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Oct 2018 21:51:58 -0400
Received: by mail-lj1-f178.google.com with SMTP id z21-v6so15478053ljz.0
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Oct 2018 11:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=gThCvGTTMZS4xaMFbEXziD/z4m9amSuzcXhT8R0clk8=;
        b=z56k+akY+Zyq5QxjSOT8IqDopx4z8uuh5ROySNcvm6aP0MQKY/3iH3qzG+KPgAKhBz
         1WrEmeCfPBqX5E5OtuEKJP9LUW1OoGJo7zimm/Im4jQTsB/gUYy/5ZP0WUpShqOhhsIF
         9zIrk1TPz7Tf86C6/HOQA8aXiKRErX6C+cgzPyTLwGZZUQoxvRVO1duAQ8MA7kOUJWis
         AfOAC9APmWzla+oxQg/9liuW4NPO1r8RT8KImvFCjjCj3LjVuHiyF7048dAvHC5odNNA
         +BqFpMeYjrY1KU9Y0GACKOwYR7bb9XTgJEOtvS71KhxPRitMjkG2w7+aFyCH4WyA+OWj
         IOaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc;
        bh=gThCvGTTMZS4xaMFbEXziD/z4m9amSuzcXhT8R0clk8=;
        b=MZbKTPSSxA6a/27ta8QH4ziUdWPOpOpHODpeajhULyOYSzspI2BEiJakQ0msAIZLjd
         OmohW2OkNEKN1u6J9LIuD0vdHfwZ7x8rxAk4qDUSrGd6fELlFO/EHXcpa5/B30q4ZYBW
         SFsJYg8qIp37qQss0dcoTsTeW01gsOp0cA1qpRvCouqnuGAW0NeWQGMcR6p/Q2rE2p4V
         6l4b1rDoxXJ4lM0URmMHeAdEGeqJ2TZSBFhawbGweDmIYnUSqcxzT5wqxNTnBYfXaQ3T
         G0dK1u0lunTd3PeHhygWl7Aw4sgtt6nbfZldZj3JKgC/Y8WeyuIamtSRLrM7cVN5G7Zm
         nR4Q==
X-Gm-Message-State: ABuFfojDp0eEH7HbrtWEXeoWEDJVmXk6wCOEXvrxT72Iw1Na+miYot2H
        8o6AiuS44vFpdZd7Is6KQvFYDHiMnH490BntHRVrVA==
X-Google-Smtp-Source: ACcGV60ujpTyrtcpCeQ7aN9Wz8kdnWOyiFOk4Hb9q2nwzOjMJO2sHoSZe+BErJVcRCM2ZfrgPu7y5RIxBNQx0MxiXzA=
X-Received: by 2002:a2e:5645:: with SMTP id k66-v6mr8711502ljb.48.1539540606439;
 Sun, 14 Oct 2018 11:10:06 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:1999:0:0:0:0:0 with HTTP; Sun, 14 Oct 2018 11:10:05
 -0700 (PDT)
X-Originating-IP: [69.7.113.20]
In-Reply-To: <CAN4oSBevO04cV+DyGxXg60nBbYB7UANFZzMcWV1M0S6HpHYc-w@mail.gmail.com>
References: <CAJCQCtTPwQnzwkpk=4ZsZXfWTC7HymYETxp-9xUU_tsvOTW0ZQ@mail.gmail.com>
 <CAJCQCtT2ackbOo1QPkaj5W+LXnJx5VUMvbxbD0VmcenWz_85pg@mail.gmail.com> <CAN4oSBevO04cV+DyGxXg60nBbYB7UANFZzMcWV1M0S6HpHYc-w@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sun, 14 Oct 2018 12:10:05 -0600
X-Google-Sender-Auth: Mbi5zSFSgsYkr6B99c7fDooTI0A
Message-ID: <CAJCQCtQkY0_2J8HHp8HmoT523nhWr7nFwHhjHZ_cfoSXoWoDWg@mail.gmail.com>
Subject: Re: reproducible builds with btrfs seed feature
To:     Cerem Cem ASLAN <ceremcem@ceremcem.net>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Anand Jain <anand.jain@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Oct 14, 2018 at 6:20 AM, Cerem Cem ASLAN <ceremcem@ceremcem.net> wrote:
> I'm not sure I could fully understand the desired achievement but it
> sounds like (or this would be an example of selective perception) it's
> somehow related with "creating reproducible snapshots"
> (https://unix.stackexchange.com/q/462451/65781), no?

No the idea is to be able to consistently reproduce a distro installer
image (like an ISO file) with the same hash. Inside the ISO image, is
typically a root.img or squash.img which itself contains a file system
like ext4 or squashfs, to act as the system root. And that root.img is
the main thing I'm talking about here. There is work to make squashfs
deterministic, as well as ext4. And I'm wondering if there are sane
ways to constrain Btrfs features to make it likewise deterministic.

For example:

fallocate -l 5G btrfsroot.img
losetup /dev/loop0 btrfsroot.img
mkfs.btrfs -m single -d single -rseed --rootdir /tmp/ -T
"20181010T1200" --uuidv $X --uuidc $Y --uuidd $Z ...
shasum btrfsroot.img

And then do it again, and the shasum's should be the same. I realize
today it's not that way. And that inode assignment, extent allocation
(number, size, locality) are all factors in making Btrfs quickly
non-determinstic, and also why I'm assuming this needs to be done in
user space. That would be the point of the -rseed flag: set the seed
flag, possibly set a compat_ro flag, fix generation/transid to 1,
require the use of -T (similar to make_ext4) to set all timestamps to
this value, and configurable uuid's for everything that uses uuids,
and whatever other constraints are necessary.


-- 
Chris Murphy
