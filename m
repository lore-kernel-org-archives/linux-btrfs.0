Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CA84C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 19:12:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 242A82133D
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 19:12:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=lesimple.fr header.i=@lesimple.fr header.b="3UW/dwKC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbfCRTMM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 15:12:12 -0400
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:37796 "EHLO
        mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726780AbfCRTMM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 15:12:12 -0400
Received: from rc.speed47.net (nginx [192.168.80.2])
        by box.speed47.net (Postfix) with ESMTP id 5BAF8C79;
        Mon, 18 Mar 2019 20:12:10 +0100 (CET)
Authentication-Results: box.speed47.net; dmarc=fail (p=none dis=none) header.from=lesimple.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lesimple.fr;
        s=mail01; t=1552936330;
        bh=LfOqFWqWHAzYK2lqgkjb1DApZVc2mJzbeqTe2gE0dCs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=3UW/dwKCkv2s2JAMk7kWSTWfDHK3Dzuoq3ioKmSCpVE3hpkzD4W7Z8mq3DapKu5Yc
         glha/6hpjGBt/RBVc0o2ZexgFHKWGUTy29B8eqp4/Yw/HZrsaGpOguai+hcCILhTOQ
         yzBl3gkjRxH4GPaYd7wWPqiuF2nwZK+txuwag0zo=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 18 Mar 2019 20:12:10 +0100
From:   =?UTF-8?Q?St=C3=A9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
To:     kreijack@inwind.it
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs-progs: fi usage: implement raid56
In-Reply-To: <8679eb74-8c98-d54d-f69e-821a6eba1cd9@libero.it>
References: <20190317125150.26265-1-stephane_btrfs@lesimple.fr>
 <20190317125150.26265-2-stephane_btrfs@lesimple.fr>
 <8679eb74-8c98-d54d-f69e-821a6eba1cd9@libero.it>
Message-ID: <26c40d46f4278edeb2604e26fda957ee@lesimple.fr>
X-Sender: stephane_btrfs@lesimple.fr
User-Agent: Roundcube Webmail/1.2.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Le 2019-03-17 19:41, Goffredo Baroncelli a écrit :
> On 17/03/2019 13.51, stephane_btrfs@lesimple.fr wrote:
> [...]
>> -		if (!ratio)
>> -			warning("RAID56 detected, not implemented");
>> -
> 
> IIRC one of the problem which lead to this code was that the not root
> user cannot
> access to chunkinfo. So the (regular) user should be warned about
> that: the printed info may be not correct.


I think you may be referencing this other warning:

         ret = load_chunk_info(fd, chunkinfo, chunkcount);
         if (ret == -EPERM) {
                 warning("cannot read detailed chunk info, per-device 
usage will not be shown, run as root");

This one is still present, and matches exactly what you say:
it fires when btrfs fi usage is run under a non-root user.

The "RAID56 detected, not implemented" warning, on the other hand,
is displayed even under the root user, and indicates that it's normal
that most of the counters of "filesystem usage" are at zero, because
the code to compute these properly under raid5/raid6 isn't there yet,
and it's actually precisely this missing feature that my patch tries to 
add!

Thanks,

Stéphane.
