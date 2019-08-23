Return-Path: <SRS0=V1nM=WT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06E87C3A5A2
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Aug 2019 19:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC8BC21874
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Aug 2019 19:46:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="V0gn6/m3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391450AbfHWTqR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Aug 2019 15:46:17 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:44027 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732627AbfHWTqR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Aug 2019 15:46:17 -0400
Received: by mail-wr1-f44.google.com with SMTP id y8so9607761wrn.10
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2019 12:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=UFuI1oQv+O9tlHp9c9rjNNsyUV6lVoCA/7WWSllLQ5Y=;
        b=V0gn6/m3eqUkVM8/AjXPf3PES0IT7GA0fQrOA3E0sxc+1k/Utvc9q9QDMz22jTTDGh
         EK5soNgPI1HrzXnTHUVBjIphVbmzVjaUPnihxcuGFKDq4KiGy9+C9Y8koMg+H/9zRpRA
         HsCFuhbV5Vv75X9D8SncDYLjHrVWt/D1Cd0Fl95bkTtPeW8k2SEbmY4um8+0A8A5vjIp
         wuP+4rtXiGL7N9ySEkWRTySl9PM5bYnuO8fxSqpFFqV8NLgBQN/e838TiJCltkvCDAwi
         cllCd5RIqpTQExkwg+aod8BbCHuAV74+nogqh4ivYlbvYeLoa5sf/00MwUr0y4fFDhBE
         FzDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=UFuI1oQv+O9tlHp9c9rjNNsyUV6lVoCA/7WWSllLQ5Y=;
        b=E9CkVKcepTBBhrA5R+d6QNQKfUmYRcrkYZBXOYZt4iSZPDTRnwTg0BIPdioHMFcilR
         wu7CAU+J0mT0fwjSgpdTFXPtMfqD3TwPyF7h2pYfDHQ5EmGwsoED635cv8MCOHM5q/Sg
         RFt87IVQDvfLoGGzepHfx3KUMzDpW/9cwl4KjD4MQdTreGx/rIIgg+AVSbpHWjEclRsG
         lqqsLK2gOrb7u+Hr5b7SS3Pj3PS4LefHdDQ2K9ep/AuPtGXM8rv3x6HVQcu1rAMGCQTB
         hlg/8h2LGNUKLCldQEZiAMWEsnl1w5J60ifRRvG/2GvbmTnx4yezipqFBOqoudVEbtIg
         +dSA==
X-Gm-Message-State: APjAAAUru/jakvz0+soMeNbNrWxCpRYCDYKF0RfoS5qD+nVi2XDqpDwu
        0rJTNGHCk+EH3BO3jJuH79sG3qZc7SMKE3Skryh3ED5XvJmdmw==
X-Google-Smtp-Source: APXvYqwjddlP0YHYgPXc1mc2Utr6FCBFM/oZ6am6RFuQwVrj370+dskEL0drstZhjOxaT0bcquX2Ge0IVojRDFeXiLM=
X-Received: by 2002:a5d:4403:: with SMTP id z3mr7405659wrq.29.1566589575342;
 Fri, 23 Aug 2019 12:46:15 -0700 (PDT)
MIME-Version: 1.0
From:   Chris Murphy <lists@colorremedies.com>
Date:   Fri, 23 Aug 2019 13:46:04 -0600
Message-ID: <CAJCQCtR6_1cbOMOgKzBLMyL2EQMLqRP+eGfETfT40MTxoyG7pA@mail.gmail.com>
Subject: swap and hibernation files
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc:     Omar Sandoval <osandov@osandov.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Found this:
https://github.com/systemd/systemd/issues/11939#issuecomment-471684411

Is it possible to support hibernation with swapfiles with this new
interface? My understanding is that's only a feature of uswsusp, near
as I can tell.

Advantage is it can mean the space reservation for hibernation and
swap files can be made dynamically as needed rather than making a
large 1:1 RAM to swap partition that maybe isn't needed or desired
based on the use case and workload. Instead of making these decisions
in advance at installation time, make them on demand. Plus, people
sometimes add memory and a previously created hibernation partition
will now be sized incorrectly.

Mostly I'm just curious if it's possible as part of already planned work.

-- 
Chris Murphy
