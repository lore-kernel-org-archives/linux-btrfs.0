Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38375 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbeIGOgb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Sep 2018 10:36:31 -0400
Received: by mail-wr1-f65.google.com with SMTP id w11-v6so14350724wrc.5
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Sep 2018 02:56:21 -0700 (PDT)
Received: from t-5.eu (p57AB9DBE.dip0.t-ipconnect.de. [87.171.157.190])
        by smtp.gmail.com with ESMTPSA id 1-v6sm11923881wmf.47.2018.09.07.02.56.19
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 07 Sep 2018 02:56:19 -0700 (PDT)
Received: from t-5.eu (localhost [127.0.0.1])
        by t-5.eu (Postfix) with ESMTP id 4EDF6119140
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2018 11:56:18 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 07 Sep 2018 11:56:18 +0200
From: =?UTF-8?Q?J=C3=BCrgen_Herrmann?= <t-5@t-5.eu>
To: linux-btrfs@vger.kernel.org
Subject: compiling btrfs-progs 4.17.1 gives error "reiserfs/misc.h: No such
 file or directory"
Message-ID: <e822c3d52bfef3e0f2cc4617b21f5518@t-5.eu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

I'm having a problem with btrfs send which stops after several seconds.
The process hangs with 100% cpu time on one cpu. The system is still
responsive to input but no io is happening anymore so the system
basically becomes unuseable.

I'm on linux mint 19, freshly installed on a new laptop about 6 weeks
ago. So i wanted to compile latest btrfs-progs and latest stable kernel
first before reporting that here, BUT: I cannot compile btrfs-progs 
4.17.1
because of the following error:

     [CC]     convert/source-reiserfs.o
In file included from convert/source-reiserfs.c:30:0:
./convert/source-reiserfs.h:23:10: fatal error: reiserfs/misc.h: No such 
file or directory
  #include <reiserfs/misc.h>
           ^~~~~~~~~~~~~~~~~
compilation terminated.
Makefile:309: recipe for target 'convert/source-reiserfs.o' failed
make: *** [convert/source-reiserfs.o] Error 1

A google search did not turn up any help nor does apt know of any
reiserfs related libs that i could install.

Best regards,
Jürgen

-- 
Jürgen Herrmann
https://t-5.eu
ALbertstraße 2
94327 Bogen
