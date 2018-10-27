Return-Path: <SRS0=3TJ0=NH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7438DECDE44
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Oct 2018 22:58:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BB7B20848
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Oct 2018 22:58:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nTx4AAIx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3BB7B20848
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbeJ1Hks (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 28 Oct 2018 03:40:48 -0400
Received: from mail-oi1-f179.google.com ([209.85.167.179]:42107 "EHLO
        mail-oi1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728810AbeJ1Hks (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Oct 2018 03:40:48 -0400
Received: by mail-oi1-f179.google.com with SMTP id h23-v6so4018659oih.9
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Oct 2018 15:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=uyyhuJOsvxh4Ik26Eu4JCdyyZY2KRnk1aZQd9dRw4qk=;
        b=nTx4AAIxx81nPOEhqg4H9Z5UpAUQXbtwlgR3zpAMDYjkIHsFFlVaAoTA6zBQk+/Nkr
         ZFfu/SXM/Nz+a3QyHY2u4w+PUojEWA413m2rgTEtMD4bXy2458qlYChFoGrOGKkT015s
         O+U7z/T/lqOo8nOBNfoRq+pcTW0Oq1Y3W+1gaWi2RYr0dP8iY0UsiaKuryMucpYFRCQH
         F/USlXEIC6YIWLSKvtDHoslCU8413wpbp63alIkOKOhfQUKa+gohYkQYrXAqcKfYnyns
         6VyrbLD3Lt5WFNhyYyLNRbBwVuPzVTWRmEtmc5m4CgRSSqyB3ZzggVwd2LKuC7/rSFyu
         Lu0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=uyyhuJOsvxh4Ik26Eu4JCdyyZY2KRnk1aZQd9dRw4qk=;
        b=g2BpBXsgf1l8A7wKgGRoms3WakqdafoiHWQmAUaNZXOUT9CFKlM8+lPw7ZXfP6hKya
         rc3WFbAUyrsbOJfMcLR1wihS9gTENMKi4AP8mb8DRo4znWhSpObzSS6ZwQ/jv6y8SDR6
         f6yERlrqcU1+lcZD0+gEcol9DlW3az6QaacPSkMIomC5laF94ms5UKAyaaBgGGklkBGa
         eu8prpwFLPAOZKmv9UoYAIbEowgxiIuxO2S+bus86UKHDYM8XfUhpPmX9xQ6OZUA2Tfp
         BEfAWnmBdzyUhmFeCYSeAUkrZauJDUn27bzUEqRtXLITEy2oSXZ5Rpziiek0TffgpC1f
         qCTg==
X-Gm-Message-State: AGRZ1gJduDHQhn4SAMAZX8I2T+zqLaAtpn9LWZduw7PNqFKl8BZmSPLm
        llUGNArTTJm2GU0edY8Ix+g6h2uVhKpsfGabLA6+JOE2
X-Google-Smtp-Source: AJdET5fn1ObiS8TGnC/ElB3q0d+TOYLVVqqwFnk5AxgsdES5WM56xInPVcWxovtd02hjSM6SYp8lZcl7iEgD/f9DZ8g=
X-Received: by 2002:aca:a9b:: with SMTP id k27-v6mr5144049oiy.78.1540681096232;
 Sat, 27 Oct 2018 15:58:16 -0700 (PDT)
MIME-Version: 1.0
From:   Dave <davestechshop@gmail.com>
Date:   Sat, 27 Oct 2018 18:58:03 -0400
Message-ID: <CAH=dxU7OXpWYRVkhoPtcfPj3r6Sh5Mkmz4nc6jOy_W8osX5zOQ@mail.gmail.com>
Subject: btrfs-qgroup-rescan using 100% CPU
To:     Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I'm using btrfs and snapper on a system with an SSD. On this system
when I run `snapper -c root ls` (where `root` is the snapper config
for /), the process takes a very long time and top shows the following
process using 100% of the CPU:

    kworker/u8:6+btrfs-qgroup-rescan

I have multiple computers (also with SSD's) set up the same way with
snapper and btrfs. On the other computers, `snapper -c root ls`
completes almost instantly, even on systems with many more snapshots.
This system has 20 total snapshots on `/`.

System info:

    4.18.16-arch1-1-ARCH (Arch Linux)
    btrfs-progs v4.17.1
    scrub started at Sat Oct 27 18:37:21 2018 and finished after 00:04:02
    total bytes scrubbed: 75.97GiB with 0 errors

    Filesystem           Size  Used Avail Use% Mounted on
    /dev/mapper/cryptdv  116G   77G   38G  67% /

    Data, single: total=72.01GiB, used=71.38GiB
    System, DUP: total=32.00MiB, used=16.00KiB
    Metadata, DUP: total=3.50GiB, used=2.22GiB

What other info would be helpful? What troubleshooting steps should I try?
