Return-Path: <SRS0=DsAV=2V=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 807A2C2D0C2
	for <linux-btrfs@archiver.kernel.org>; Tue, 31 Dec 2019 09:04:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45C7220409
	for <linux-btrfs@archiver.kernel.org>; Tue, 31 Dec 2019 09:04:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PtNQv4Yn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfLaJEp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 04:04:45 -0500
Received: from mail-wr1-f45.google.com ([209.85.221.45]:44427 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfLaJEp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Dec 2019 04:04:45 -0500
Received: by mail-wr1-f45.google.com with SMTP id q10so34667833wrm.11
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Dec 2019 01:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:subject:from:to:mime-version
         :content-transfer-encoding;
        bh=7B/6iRSbJor5yQ4JqhGJbLaqGtqbeiCapzfhfRuMKmk=;
        b=PtNQv4YnLtrOA9luGAmiFBYypa4btHrciFCNKnTKUHq95Gbsml+Pm9RQu6AicnY0os
         Ij4PhLUQU2e7j+p4+OD0pzuinY1ztqF6ELXtEXKqcVtPbGj1dZ+ojcfDa8IDFORC4a1/
         2HaIhWOkCEeMRWnV7Jx9rwxxIuF8snBrCfGav6hqJ21QsQqT6cGjlO8cDJkh4DtyRsJ1
         J2UlmRJ5sgAca66C0SxApvX3dBDHe6taZz4zkI47mE12u0bFsn2cM6ghwAKi1Kvqy8A3
         mgqfELMRkN2hQKh6XXWIRtI2WdL8W+68BnDexfQMzIpZkDhWG1Ys2FQlqWxAStFIQIWf
         yhdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:subject:from:to:mime-version
         :content-transfer-encoding;
        bh=7B/6iRSbJor5yQ4JqhGJbLaqGtqbeiCapzfhfRuMKmk=;
        b=oJ/peB5DtwGcPb/9yPZ1R/qQvm+PW5jzxmtnGLLpxELrzW99ozYtc/uwGgBmLAe4qt
         WJL3hFBHLHxnZ36T6VwzUw/AFjeRn81oQ3SYVhaqzhTI8TDsvc2NzITDFrYdRI6zUy1j
         JtStnQW5DYrum7lcyITayB/d1TzVRt+BjsW4Mk1Tsoobou0oCrL4q2i2XOSXizkvDgA1
         lZf2+QuX9O7QynceM9otkrYzxzubusKxAxFZrAAMM8NEcYiJgXpZqgoBXfDholVaH3FL
         9Yx73bFpZ0nhMLGur24ujbOtWg5+VzpR4oh3fizXHF6rDza7f01W4ovuC01CG1FnKgtY
         I8kQ==
X-Gm-Message-State: APjAAAWSCh32oX5PZGKfPzQ+zPfp7HEzMhXIiTAZFf9mOwvHU6yLWesD
        GZhDterE7s+/vWUJVtMxR6nm/Vet
X-Google-Smtp-Source: APXvYqx00sf7wPK4D1/7BIm/5f6CiLTHjzo5nBJxqZGsjunxaIrA1VIP48+rmVfJVcc8bPdK4ndGvg==
X-Received: by 2002:adf:e70d:: with SMTP id c13mr71306500wrm.248.1577783082849;
        Tue, 31 Dec 2019 01:04:42 -0800 (PST)
Received: from [127.0.0.1] (178.165.130.248.wireless.dyn.drei.com. [178.165.130.248])
        by smtp.gmail.com with ESMTPSA id b15sm1947566wmj.13.2019.12.31.01.04.41
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Dec 2019 01:04:42 -0800 (PST)
Message-ID: <146bbade48ad7ff8234ab7574e387536@swift.generated>
Date:   Tue, 31 Dec 2019 10:03:52 +0100
Subject: Domain net-doc.de
From:   Hans Weis <whans5002@gmail.com>
To:     "" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Sehr geehrte Damen und Herren,

Ich dachte mir, ob Sie vielleicht an me=
iner net-doc.de interessiert sind.
Ich freue mich auf Ihre R=C3=BCckmeldu=
ng

Es gr=C3=BC=C3=9Ft Sie herzlich

Hans Weis


............=
.......................
