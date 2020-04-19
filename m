Return-Path: <SRS0=/aO0=6D=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C9FC2BA2B
	for <linux-btrfs@archiver.kernel.org>; Sun, 19 Apr 2020 09:07:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E32D62145D
	for <linux-btrfs@archiver.kernel.org>; Sun, 19 Apr 2020 09:07:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=seznam.cz header.i=@seznam.cz header.b="GbIzKccH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgDSJH1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 19 Apr 2020 05:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725446AbgDSJH1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 19 Apr 2020 05:07:27 -0400
X-Greylist: delayed 143 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 19 Apr 2020 02:07:27 PDT
Received: from mxb2.seznam.cz (mxb2.seznam.cz [IPv6:2a02:598:2::89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146F5C061A0C
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2020 02:07:26 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc23a.ng.seznam.cz (email-smtpc23a.ng.seznam.cz [10.23.18.30])
        id 0980743da8493b3408426dab;
        Sun, 19 Apr 2020 11:07:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1587287245; bh=aYfchShwv5SAzrE0Js72j1Hg0UObYDyrqWyfz4kQZ2g=;
        h=Received:From:To:Subject:Date:Message-Id:Mime-Version:X-Mailer:
         Content-Type:Content-Transfer-Encoding;
        b=GbIzKccHlXYpiAbrPLfmd7PbUPYlHwOYY5iiSEaZt7JzQgkbM2BL+fSZ9qAuZLv0s
         xoQrfApCv3SAQWi2KlMUogrf/Xu2cba0h+yAmsEPKV/rfiJ6VALkIQAtPdijKfxAZV
         PM/VlLa/4IbzY8Du2Kteh0VJ3wLR2+b7dBcPQhLw=
Received: from unknown ([::ffff:178.209.138.12])
        by email.seznam.cz (szn-ebox-5.0.8) with HTTP;
        Sun, 19 Apr 2020 11:04:58 +0200 (CEST)
From:   =?utf-8?q?Pavel_Dvo=C5=99=C3=A1k?= <dvorapa@seznam.cz>
To:     <linux-btrfs@vger.kernel.org>
Subject: Wiki account
Date:   Sun, 19 Apr 2020 11:04:58 +0200 (CEST)
Message-Id: <cu.1mbU0.4ObSajS4Jf9.1Ud1Gw@seznam.cz>
Mime-Version: 1.0 (szn-mime-2.0.56)
X-Mailer: szn-ebox-5.0.8
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,
a few days ago I requested an account called Pywikibot-test on btrfs wiki.=
 As no reply arrived yet, I'm writing here (per https://btrfs.wiki.kernel.=
org/index.php/Special:RequestAccount). Has my request been discussed/rejec=
ted/approved?
Best regards,
Pavel Dvorak
