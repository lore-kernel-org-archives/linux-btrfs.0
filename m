Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92B32ECAAD5
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Sep 2022 09:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiILJaR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 12 Sep 2022 05:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiILJaP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2022 05:30:15 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00431274B
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2022 02:30:14 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-1279948d93dso21725578fac.10
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2022 02:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=+qVy9jR729xM0bLj1boh5gQKwr/6ZMFvkx06/gpD9sE=;
        b=ErufAgW11G94Zx/wrBG7q09Llsiwq8RoQ6reQGG0cPq0Z2E58IIAZXnSXnDcG5Q1mQ
         8gxQq1IK6clNizSBWREOchSPyuT/A8tFktaGYmkgnoQbJv3MZbP5lO0MLYmGwlDxbSWV
         cbXb/uQBmrZGT65ZKtgy+MA0gq8g6kJJRR7Lrzx93Ljdk5bLjnPPZ4FUUNGM5gpf8zgt
         ZREepcf3MZpcma0wP3zbnVJE3/ZqE5RevSZlutd75R1r7McjS2CkpDqFD9kFs0Qhqs/l
         BpwWMxmsXhQiue9nQrx81dwPoGk1AYLWTSrHakyWiiZ8GZJF2o6urN+xfimZ0PlMWYMO
         MJIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=+qVy9jR729xM0bLj1boh5gQKwr/6ZMFvkx06/gpD9sE=;
        b=Pi/+xVtqQp02YkltLHdtQWTGpakNd8FQ80YDIm535iRo+0RkYl4iL0wUdSDmoFE71i
         WgfFyPRT1vy83mmxMftbXKd2GSWay9x8MC4b4B3pI0sgZ27sjFUzq0X2RP3EYtC+Ti2E
         FMJA/J56Fjj0vhGOkjYykE3g85B3egx+VTecgPW0O+9kS+n/0nF5VQDnhSoXUxY/2kiG
         qNJ3FxoS2JYf8PzkRwOPUxaU1ubyLaUz7/s68CxVHQoC55ZbQV15agI+m+KJP905ecI/
         VoufWxjwZfdZfX9FUmLeZrCo+gJ4rp5/7RgoCVa65aqBtLlcMi4Xu+LkrAnyh8NtAXQS
         jnxg==
X-Gm-Message-State: ACgBeo1YN0ckDR0CjBS3oWrBLd585sR+f+e8GgGxk5mxIsRuu515AS9m
        ZYqh8ybBj3mdTwjYoTvPFwJSZ7eNQwW4pEa/+84=
X-Google-Smtp-Source: AA6agR5aV0t7NqZG2JVnuPvha46K5+T2KqVi9tycBBhQb/dJQ6V6xvCXA7386fzKKED+XrenQNXppRFanJocGTMXGPk=
X-Received: by 2002:a05:6870:d390:b0:127:7213:37b7 with SMTP id
 k16-20020a056870d39000b00127721337b7mr11900218oag.298.1662975014097; Mon, 12
 Sep 2022 02:30:14 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:e02:0:0:0:0:0 with HTTP; Mon, 12 Sep 2022 02:30:13 -0700 (PDT)
From:   Mukter Khan <mhdmkhan.uk@gmail.com>
Date:   Mon, 12 Sep 2022 10:30:13 +0100
Message-ID: <CAOv06TYWhNxgzn_ECcLdCoxm7Ho=Y1ZO0=pbadtw210m3tvshA@mail.gmail.com>
Subject: Fw: Franz Schrober
To:     TheHavermayer <havermayer@gmail.com>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Jesper Juhl <jj@chaosbits.net>,
        Jean Marc Valin <jmvalin@jmvalin.ca>,
        Jonathan Nieder <jrnieder@gmail.com>, jw <jw@jameswestby.net>,
        kim phillips <kim.phillips@freescale.com>,
        kovarththanan rajaratnam <kovarththanan.rajaratnam@gmail.com>,
        linux btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

https://8bht9.app.link/XNIiYQ04ftb
