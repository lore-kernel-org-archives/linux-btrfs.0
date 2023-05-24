Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B79C77B7C
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 May 2023 19:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjEXTlI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 May 2023 15:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjEXTlH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 May 2023 15:41:07 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515B012F
        for <linux-btrfs@vger.kernel.org>; Wed, 24 May 2023 12:41:02 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1afbc02c602so1541555ad.1
        for <linux-btrfs@vger.kernel.org>; Wed, 24 May 2023 12:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684957262; x=1687549262;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=b9q0xJYKnbjCtsYVm5R+zuCBKF3I524vT1yTL4pBX60=;
        b=YyYYGaBUDB0SwGay8IrSbJKFEgDp/QMTy8694cPki98MtwbEl7p0FfZwMPnCqLHoNl
         /CJG/7nocF80vonrYVsb02J94oRQURlW5aWJVvqzfcLebgi5l2fmgpNi2LPF0CrLygJ/
         Yv49j0KC4l7JogWav3KyEu6/0WHAPRpvnYLiytpjTPGNgyw1sMXSRQNEXrhtU1mW5+mZ
         btayc6z5SlZrQLbXoi5Ux86BdMy3tBwoZleykYdG9uvcZ5puHYFzVexSjUP5n9bYjcZ9
         KX0PvCIuPAvehIFzZAHAXFIYoLMqqH7qdhgIwU8ktLGGAsXwM1TZvXbLat+34MWPOeJG
         SsCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684957262; x=1687549262;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b9q0xJYKnbjCtsYVm5R+zuCBKF3I524vT1yTL4pBX60=;
        b=eGarbJ/wMHp9mzX/LgmD+XIaveEYXgyY/kU8gz85GlX5f0ak9EBkOany5DDoaSTu5C
         jWsXa0P6+ydnxbFMyRB6yEIUgTzO6cjF5ZvU1soJBZsVDM85QZ+g+MiCWrCs7juzWttY
         fc2sPOJ3fQapoc9rMfjYcHJHce/x9sBQ48xDN+801jWXX+xbm8rPF5tzocKkyeSwb+cU
         mOabMwlJH3DgsvBllTiL8gSle8WFRAq3ytbqoTdO9+d5UFKogEQHr2jn8S+BprGXqEn0
         mIqPQZoK4II6v7wY+pHRyDJuTgflnziwNsXuu56cYmUHKz/AWUTmnKgVswwcD7bNMO/X
         +E1w==
X-Gm-Message-State: AC+VfDyqDAkPa5z+6hQHvrNzdvIquAizrPTYUwTZ4n2HIME0NfQyGiGB
        XwbvXNVQ1h5JsA5k/rk0RUI7GDUBuFpOSemXEww=
X-Google-Smtp-Source: ACHHUZ7F1pWghhKPn29tc+N3g6a6Im2oPkOWB06SKFXG0qYIQJ89/cAaU3RU+Jbhk7i8OV/ycKbdoOv2qpX14rN31yQ=
X-Received: by 2002:a17:902:f813:b0:1af:e116:4b42 with SMTP id
 ix19-20020a170902f81300b001afe1164b42mr275576plb.34.1684957261582; Wed, 24
 May 2023 12:41:01 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a11:627:b0:4b8:cbf7:c718 with HTTP; Wed, 24 May 2023
 12:41:01 -0700 (PDT)
From:   "'Katja Dabelstein'" <lulupipirere@gmail.com>
Date:   Wed, 24 May 2023 19:41:01 +0000
Message-ID: <CACkTDfYBV9F50G2oFT8JGQt1aWOmGuOSwaNXgD=8QArcxnppfQ@mail.gmail.com>
Subject: Franz Schrober
To:     Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Jesper Juhl <jj@chaosbits.net>,
        Jean Marc Valin <jmvalin@jmvalin.ca>,
        Jonathan Nieder <jrnieder@gmail.com>, jw <jw@jameswestby.net>,
        kim phillips <kim.phillips@freescale.com>,
        kovarththanan rajaratnam <kovarththanan.rajaratnam@gmail.com>,
        linux btrfs <linux-btrfs@vger.kernel.org>,
        Lars Wirzenius <liw@liw.fi>, lool <lool@debian.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

https://1drv.ms/b/s!AhZh44f9Qh0sb9V5CJGp6nQAkLM
