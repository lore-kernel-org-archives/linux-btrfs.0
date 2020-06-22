Return-Path: <SRS0=j8o/=AD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92A46C433E0
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Jun 2020 00:32:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64BCD23770
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Jun 2020 00:32:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="Fk+kkOVk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgFVAcB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 21 Jun 2020 20:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726407AbgFVAcA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Jun 2020 20:32:00 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B80C061794
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Jun 2020 17:31:59 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id g18so5841102wrm.2
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Jun 2020 17:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=2NsC826+tfEHLZSXMOTxre9glMUPf9FysRaXWKMATqk=;
        b=Fk+kkOVkOiKGBlMdW2GZchcSItZJXr9osM0eez7p56P53SQt27aFMjuOJSqVWJxt/1
         Co/FSd/IQ/oPL3djWjsjlM2z158J1h3+/WSXam2AhB6ONhKgSmvNNuHwj4JlXxKrKe2W
         zkChO+aPwpfUtjo/ZceKZEUeLY8p4seTlgDOde6XX3eeokKmH8fuWdxYZVEsFKWyKnpQ
         2OQt3EXLfpkenqpxMlqYLRMq/3GuxNwzrlLrxuhWJEMVycRGiEBVj0ZHHJdp/Y9rew9d
         fd8h6FpHzvBjcDq5n7flR1rwHAbRXNYCM9kdhi5Jf3C+wyuvwA24ZbNAajzeDA/5vHHd
         rPNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=2NsC826+tfEHLZSXMOTxre9glMUPf9FysRaXWKMATqk=;
        b=Om9oTM4dFIHDs74Jn8FOrIkKu9nmm/UcnMApnQNpT0FvYeMp0LtwOEfXHtoQ99UC9n
         XVhCF90MTKtf6By8ljunTeDKEai8DTLZLribglXxV5ie9RefevfaE1SqrjUP2Aykev9n
         vgseSkhyOSWQ+b+QR9pjbYYNa97gUvpAHakGhHpYJY0Le5Pk+ZeUfNigRte9yn+2frwi
         4LKwQjEK8MgkBeYdNAeX+znPQUEH0PPAJw/5JdRkLwylkPhC59zIrdTEGffowzvWOLej
         CFZ5wRWCmo3e8kpfHffG40fpLFC23T5DrqXCrFGnq/VTGCuOxhZeY8GRPHrlmYFXAvy+
         e1Jw==
X-Gm-Message-State: AOAM532Yz9rl1x9nusxvrcgjNXSmgsEMV5EJT0WxipiJdPyJx8NAg5jx
        IvK9Jf84u5xMm+5+/dhEqHRkKBOYClNJ6pAt6umzHPgAQ0uS5g==
X-Google-Smtp-Source: ABdhPJzNkfig8QGyOPAFonDVKj9jMNl68HNe8OoRSALzktJR00EjP2LsHDrmbxxNs5PZOvaj8GJQWkV+thv1ZnzaMQg=
X-Received: by 2002:adf:9d8e:: with SMTP id p14mr15870203wre.236.1592785916574;
 Sun, 21 Jun 2020 17:31:56 -0700 (PDT)
MIME-Version: 1.0
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sun, 21 Jun 2020 18:31:40 -0600
Message-ID: <CAJCQCtSf+Q2yUZs-A_CxunfzNubvMUyKzfdkWK9iMYuPUwO1zg@mail.gmail.com>
Subject: btrfs-progs scripts 'btrfs-debugfs' 'show-blocks' need python3 updating
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I'm not sure if these are still useful for btrfs developers. If not,
maybe deprecate them. If so, hopefully someone in the community is
interested in updating them so they work.

pythons2->python3 update needed for btrfs-debugfs show-blocks #261
https://github.com/kdave/btrfs-progs/issues/261



-- 
Chris Murphy
