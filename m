Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6E45C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 22:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A64F2186A
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 22:21:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="QCo0Ucw0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfCNWU7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 18:20:59 -0400
Received: from mail-lj1-f170.google.com ([209.85.208.170]:36919 "EHLO
        mail-lj1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfCNWU7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 18:20:59 -0400
Received: by mail-lj1-f170.google.com with SMTP id a17so6233338ljd.4
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 15:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=qvnCrmFZOGyV/y/bn+EltdVLSzae7C8lC2cW/sOxh7g=;
        b=QCo0Ucw06/mZ7RmWtym0AXFzZLqSErnnVGHxMOqE1kVq3WXvjtUzXQbZ9/FQDQ46zo
         HBBlxnwiMSHBIhMq1s2bjcUSszKBbz+cqhKSK6q2hRXCJmrMsb0d3cDwMf6Wbx00kSd0
         rt/JBI0LjLASWqO5aCGAttsZTGGiqt8VPkE3j3RUFxs3MtoCtcW3x2F4GeVBt8iEjxjw
         nZBD3iEom1oryXKQGGnGkOW/JulZBZYNQDuWL3/ZIOafepCQ7JEDMD1CGoNrJmD63vLO
         AUXQRpWx6GUs/pVC8nYJlrXDU8uelbT0EcGTaQKYarz9uDlY7iz1AHwvvqwnXLdXCTvj
         eCUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=qvnCrmFZOGyV/y/bn+EltdVLSzae7C8lC2cW/sOxh7g=;
        b=UVmVKaUe1bTpD6eL/LLZFRlUlkQ/7Z4cBKuC3KcLNVcjcPu1JxnONH7whGRnax7sOC
         rr0kYA8n+037tOBX/qVckvsG/jJNsZk8HQbtRA2I0kbyBR+GdCqphqJke0tqRPeoH+Nb
         nJlGBGrX7hYPrLG2ykEHc6JO5Mes4ophfangqQ/YwHPqeklZBNKYbjNQQk6tMT6PucPk
         ++sUuEgddPlCuB1HNdrdtUgSaeOqUSzebWeHd6EUsSGpwVnGc3PqkWpjp3TsRdsJgZcM
         OQ4b3KdPzX76og1Qp3b5JNxZtQfP+yGp2B/rDYcHqaNTN8ScQVpOk19AJZSdcDgXl6NH
         CR/w==
X-Gm-Message-State: APjAAAUeE4K2IFJM5sKWOE/m+hs9qsO199AsG7W/PPA3al4dD4f+Utcc
        B5M0CqlQM4GxCNsttgjfrWBCt/E2uGGQhVUJ/J56ref0fzI=
X-Google-Smtp-Source: APXvYqzMOzwCSdssHt0Fw1rfdCOZoSLnLyM49n2WNiWagJ006sJ4pM2MF+Y1cfTO9PixztCP8udch0RyHds2WR+AIp0=
X-Received: by 2002:a2e:2202:: with SMTP id i2mr244470lji.170.1552602056821;
 Thu, 14 Mar 2019 15:20:56 -0700 (PDT)
MIME-Version: 1.0
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 14 Mar 2019 16:20:45 -0600
Message-ID: <CAJCQCtQYezBhv0FvCineu9eTGs9gisyispwDD4wEe-CURVoTCg@mail.gmail.com>
Subject: psa, wiki needs updating now that Btrfs supports swapfiles in 5.0
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

If you install btrfs-progs 4.20+ you'll see the documentation for
supporting swapfiles on Btrfs, supported in kernel 5.0+. `man 5 btrfs`

Anyone with access to the wiki should update the FAQ
https://btrfs.wiki.kernel.org/index.php/FAQ#Does_btrfs_support_swap_files.3F



-- 
Chris Murphy
