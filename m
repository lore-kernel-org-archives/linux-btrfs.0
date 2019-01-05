Return-Path: <SRS0=vb8r=PN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C38C43387
	for <linux-btrfs@archiver.kernel.org>; Sat,  5 Jan 2019 00:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6D5C20874
	for <linux-btrfs@archiver.kernel.org>; Sat,  5 Jan 2019 00:13:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mokrynskyi.com header.i=@mokrynskyi.com header.b="IpcA+WjQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbfAEANv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 4 Jan 2019 19:13:51 -0500
Received: from mx.mokrynskyi.com ([46.4.12.50]:33706 "EHLO mx.mokrynskyi.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbfAEANv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Jan 2019 19:13:51 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.mokrynskyi.com (Postfix) with ESMTP id E06D32A48
        for <linux-btrfs@vger.kernel.org>; Sat,  5 Jan 2019 00:13:48 +0000 (UTC)
Authentication-Results: mx.mokrynskyi.com (amavisd-new);
        dkim=pass (1024-bit key) reason="pass (just generated, assumed good)"
        header.d=mokrynskyi.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mokrynskyi.com;
         h=content-transfer-encoding:content-language:content-type
        :content-type:in-reply-to:mime-version:user-agent:date:date
        :message-id:organization:from:from:references:to:subject
        :subject; s=dkim; t=1546647228; x=1547511229; bh=hZ+M+05D4riq5/t
        6/VosGyCV1maCGlm8u6Tn2YFUj6w=; b=IpcA+WjQXOTJzJZT9UOZujoMR7McQb/
        kj+ql/iINhQQb+T3D93/1nOF94V8x+g2XGPbZMDq3VpEYpXpU5RIH3EfbF7BTSeY
        CCkHHcQKXEdbT1xF+o0UMieqZZIbmw0HdjefzVluL3eA1zTHe9d2f7tUL/suBayM
        ceHzcpaNxYu8=
X-Virus-Scanned: Debian amavisd-new at mx.mokrynskyi.com
Received: from mx.mokrynskyi.com ([127.0.0.1])
        by localhost (mx.mokrynskyi.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ps-c2cZCcD6Q for <linux-btrfs@vger.kernel.org>;
        Sat,  5 Jan 2019 00:13:48 +0000 (UTC)
Received: from [192.168.1.2] (bomann.znet.kiev.ua [176.122.88.128])
        by mx.mokrynskyi.com (Postfix) with ESMTPSA id 50E8498C;
        Sat,  5 Jan 2019 00:13:48 +0000 (UTC)
Subject: Re: Unrecoverable btrfs corruption (backref bytes do not match extent
 backref)
To:     Chris Murphy <lists@colorremedies.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <73e828f0-057c-830e-a6b2-570dccbdf484@mokrynskyi.com>
 <CAJCQCtTJEc8q8hrBG_HRvm1vWQvs5KgcFUKfvXPjxTNZSjd-Sg@mail.gmail.com>
From:   Nazar Mokrynskyi <nazar@mokrynskyi.com>
Organization: CleverStyle, Ecoisme
Message-ID: <b070d4f5-15e5-ea9d-51d6-795957ec972a@mokrynskyi.com>
Date:   Sat, 5 Jan 2019 02:13:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:65.0) Gecko/20100101
 Thunderbird/65.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTJEc8q8hrBG_HRvm1vWQvs5KgcFUKfvXPjxTNZSjd-Sg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: uk
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

04.01.19 03:15, Chris Murphy =D0=BF=D0=B8=D1=88=D0=B5:
> What do you get with 'btrfs check --mode=3Dlowmem' ? This is a differen=
t
> implementation of check, and might reveal some additional information
> useful to developers. It is wickedly slow however.
root@nazarpc-Standard-PC-Q35-ICH9-2009:~# btrfs check --mode=3Dlowmem /de=
v/vdb
warning, bad space info total_bytes 2155872256 used 2155876352
warning, bad space info total_bytes 3229614080 used 3229618176
warning, bad space info total_bytes 4303355904 used 4303360000
warning, bad space info total_bytes 5377097728 used 5377101824
warning, bad space info total_bytes 6450839552 used 6450843648
warning, bad space info total_bytes 7524581376 used 7524585472
warning, bad space info total_bytes 8598323200 used 8598327296
warning, bad space info total_bytes 9672065024 used 9672069120
warning, bad space info total_bytes 10745806848 used 10745810944
warning, bad space info total_bytes 11819548672 used 11819552768
warning, bad space info total_bytes 12893290496 used 12893294592
warning, bad space info total_bytes 13967032320 used 13967036416
warning, bad space info total_bytes 15040774144 used 15040778240
warning, bad space info total_bytes 16114515968 used 16114520064
warning, bad space info total_bytes 17188257792 used 17188261888
warning, bad space info total_bytes 18261999616 used 18262003712
warning, bad space info total_bytes 19335741440 used 19335745536
warning, bad space info total_bytes 20409483264 used 20409487360
warning, bad space info total_bytes 21483225088 used 21483229184
warning, bad space info total_bytes 22556966912 used 22556971008
warning, bad space info total_bytes 23630708736 used 23630712832
warning, bad space info total_bytes 24704450560 used 24704454656
warning, bad space info total_bytes 25778192384 used 25778196480
warning, bad space info total_bytes 26851934208 used 26851938304
warning, bad space info total_bytes 27925676032 used 27925680128
warning, bad space info total_bytes 28999417856 used 28999421952
warning, bad space info total_bytes 30073159680 used 30073163776
warning, bad space info total_bytes 31146901504 used 31146905600
warning, bad space info total_bytes 32220643328 used 32220647424
Checking filesystem on /dev/vdb
UUID: 5170aca4-061a-4c6c-ab00-bd7fc8ae6030
checking extents
checking free space cache
checking fs roots
ERROR: root 304 INODE REF[274921, 256895] name 25da95e3e893bb2fa69a2f0acd=
77bfe725626a1e filetype 1 missing
ERROR: root 304 EXTENT_DATA[910393 4096] gap exists, expected: EXTENT_DAT=
A[910393 25]
ERROR: root 304 EXTENT_DATA[910393 8192] gap exists, expected: EXTENT_DAT=
A[910393 4121]
ERROR: root 304 EXTENT_DATA[910393 16384] gap exists, expected: EXTENT_DA=
TA[910393 12313]
ERROR: root 304 EXTENT_DATA[910400 4096] gap exists, expected: EXTENT_DAT=
A[910400 25]
ERROR: root 304 EXTENT_DATA[910400 8192] gap exists, expected: EXTENT_DAT=
A[910400 4121]
ERROR: root 304 EXTENT_DATA[910400 16384] gap exists, expected: EXTENT_DA=
TA[910400 12313]
ERROR: root 304 EXTENT_DATA[910401 4096] gap exists, expected: EXTENT_DAT=
A[910401 25]
ERROR: root 304 EXTENT_DATA[910401 8192] gap exists, expected: EXTENT_DAT=
A[910401 4121]
ERROR: root 304 EXTENT_DATA[910401 16384] gap exists, expected: EXTENT_DA=
TA[910401 12313]
ERROR: root 101721 INODE REF[274921, 256895] name 25da95e3e893bb2fa69a2f0=
acd77bfe725626a1e filetype 1 missing
ERROR: root 101721 EXTENT_DATA[910393 4096] gap exists, expected: EXTENT_=
DATA[910393 25]
ERROR: root 101721 EXTENT_DATA[910393 8192] gap exists, expected: EXTENT_=
DATA[910393 4121]
ERROR: root 101721 EXTENT_DATA[910393 16384] gap exists, expected: EXTENT=
_DATA[910393 12313]
ERROR: root 101721 EXTENT_DATA[910400 4096] gap exists, expected: EXTENT_=
DATA[910400 25]
ERROR: root 101721 EXTENT_DATA[910400 8192] gap exists, expected: EXTENT_=
DATA[910400 4121]
ERROR: root 101721 EXTENT_DATA[910400 16384] gap exists, expected: EXTENT=
_DATA[910400 12313]
ERROR: root 101721 EXTENT_DATA[910401 4096] gap exists, expected: EXTENT_=
DATA[910401 25]
ERROR: root 101721 EXTENT_DATA[910401 8192] gap exists, expected: EXTENT_=
DATA[910401 4121]
ERROR: root 101721 EXTENT_DATA[910401 16384] gap exists, expected: EXTENT=
_DATA[910401 12313]
ERROR: errors found in fs roots
found 39410126848 bytes used, error(s) found
total csum bytes: 35990412
total tree bytes: 196955471872
total fs tree bytes: 196809785344
total extent tree bytes: 96534528
btree space waste bytes: 33486070155
file data blocks allocated: 1705720172544
=C2=A0referenced 2238568390656

