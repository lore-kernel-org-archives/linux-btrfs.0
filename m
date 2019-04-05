Return-Path: <SRS0=fkam=SH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C65BDC282CE
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 19:20:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9015821738
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 19:20:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mokrynskyi.com header.i=@mokrynskyi.com header.b="jMy4invY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731755AbfDETUJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 15:20:09 -0400
Received: from mx.mokrynskyi.com ([46.4.12.50]:44198 "EHLO mx.mokrynskyi.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731183AbfDETUJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Apr 2019 15:20:09 -0400
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Apr 2019 15:20:07 EDT
Received: from localhost (localhost [127.0.0.1])
        by mx.mokrynskyi.com (Postfix) with ESMTP id 447903A16
        for <linux-btrfs@vger.kernel.org>; Fri,  5 Apr 2019 19:11:58 +0000 (UTC)
Authentication-Results: mx.mokrynskyi.com (amavisd-new);
        dkim=pass (1024-bit key) reason="pass (just generated, assumed good)"
        header.d=mokrynskyi.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mokrynskyi.com;
         h=content-transfer-encoding:content-language:content-type
        :content-type:mime-version:user-agent:date:date:message-id
        :organization:subject:subject:from:from:to; s=dkim; t=
        1554491517; x=1555355518; bh=eyQWptvBXqa0AQ8/Zmy9Lrufvu8tFAwtUOU
        evyu1W70=; b=jMy4invY1zWfhGGzLYnHuBAFLIJzbNNlE8qKSzlTjfMzWi3teFe
        5GQlNbLSqgCsoyTdpPCc1eJ5ypNww0KY152B081j+6Il6pbTvfDXbv1LwT3oIuvp
        ZKJNc6CKy+My7Bu2NB0AqdUSMwPnzJI39B4IvQ4BWrI3RpqFm/+WA0is=
X-Virus-Scanned: Debian amavisd-new at mx.mokrynskyi.com
Received: from mx.mokrynskyi.com ([127.0.0.1])
        by localhost (mx.mokrynskyi.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id DmI2-qBXq_UY for <linux-btrfs@vger.kernel.org>;
        Fri,  5 Apr 2019 19:11:57 +0000 (UTC)
Received: from [192.168.1.2] (bomann.znet.kiev.ua [176.122.88.128])
        by mx.mokrynskyi.com (Postfix) with ESMTPSA id DD399DAC
        for <linux-btrfs@vger.kernel.org>; Fri,  5 Apr 2019 19:11:57 +0000 (UTC)
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
From:   Nazar Mokrynskyi <nazar@mokrynskyi.com>
Subject: corrupt leaf, bad key order on kernel 5.0
Organization: CleverStyle, Ecoisme
Message-ID: <af457d27-16b5-2900-8289-98462b6de770@mokrynskyi.com>
Date:   Fri, 5 Apr 2019 22:11:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:67.0) Gecko/20100101
 Thunderbird/67.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: uk
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

NOTE: I do not need help with recovery, I have fully automated snapshots,=
 backups and restoration mechanisms, the only purpose of this email is to=
 help developers find the reason of yet another filesystem corruption and=
 hopefully fix it.

Yet another corruption of my root BTRFS filesystem happened today.
Didn't bother to run scrub, balance or check, just created disk image for=
 future investigation and restored everything from backup.

Here is what corruption looks like:
[=C2=A0 274.241339] BTRFS info (device dm-0): disk space caching is enabl=
ed
[=C2=A0 274.241344] BTRFS info (device dm-0): has skinny extents
[=C2=A0 274.283238] BTRFS info (device dm-0): enabling ssd optimizations
[=C2=A0 310.436672] BTRFS critical (device dm-0): corrupt leaf: root=3D26=
8 block=3D42044719104 slot=3D123, bad key order, prev (1240717 108 414474=
24) current (1240717 76 41451520)
[=C2=A0 310.449304] BTRFS critical (device dm-0): corrupt leaf: root=3D26=
8 block=3D42044719104 slot=3D123, bad key order, prev (1240717 108 414474=
24) current (1240717 76 41451520)
[=C2=A0 310.449309] BTRFS: error (device dm-0) in btrfs_dropa_snapshot:92=
50: errno=3D-5 IO failure
[=C2=A0 310.449311] BTRFS info (device dm-0): forced readonly
[=C2=A0 311.266789] BTRFS info (device dm-0): delayed_refs has NO entry
[=C2=A0 311.277088] BTRFS error (device dm-0): cleaner transaction attach=
 returned -30

My system just freezed when I was not looking at it and this is the state=
 it is in now.
File system survived from March 8th til April 05, one of the fastest corr=
uptions in my experience.

Looks like this happened during sending incremental snapshot to the other=
 BTRFS filesystem, since last snapshot on that one was not read-only as i=
t should have been otherwise.

I'm on Ubuntu 19.04 with Linux kernel 5.0.5 and btrfs-progs v4.20.2.

My filesystem is on top of LUKS on NVMe SSD (SM961), I have 3 snapshots c=
reated every 15 minutes from 3 subvolumes with rotation of old snapshots =
(can be from tens to hundreds of snapshots at any time).

Mount options: compress=3Dlzo,noatime,ssd

I have full disk image with corrupted filesystem and will create Qcow2 sn=
apshots of it, so if you want me to run any experiments, including potent=
ially destructive, including usage of custom patches to btrfs-progs to fi=
nd out the reason of corruption, would be happy to help as much as I can.

P.S. I'm riding latest stable and rc kernels all the time and during last=
 6 months I've got about as many corruptions of different BTRFS filesyste=
ms as during 3 years before that, really worrying if you ask me.

--=20
Sincerely, Nazar Mokrynskyi
github.com/nazar-pc

