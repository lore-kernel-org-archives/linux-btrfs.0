Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CF5EC433EF
	for <linux-btrfs@archiver.kernel.org>; Sat, 30 Oct 2021 08:18:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EACD660E8B
	for <linux-btrfs@archiver.kernel.org>; Sat, 30 Oct 2021 08:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbhJ3IUu convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 30 Oct 2021 04:20:50 -0400
Received: from ste-pvt-msa1.bahnhof.se ([213.80.101.70]:21034 "EHLO
        ste-pvt-msa1.bahnhof.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhJ3IUu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Oct 2021 04:20:50 -0400
Received: from localhost (localhost [127.0.0.1])
        by ste-pvt-msa1.bahnhof.se (Postfix) with ESMTP id 520013F6EE;
        Sat, 30 Oct 2021 10:18:19 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at bahnhof.se
Received: from ste-pvt-msa1.bahnhof.se ([127.0.0.1])
        by localhost (ste-pvt-msa1.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Yx7VJscd3cYj; Sat, 30 Oct 2021 10:18:18 +0200 (CEST)
Received: by ste-pvt-msa1.bahnhof.se (Postfix) with ESMTPA id A1C4D3F6E9;
        Sat, 30 Oct 2021 10:18:18 +0200 (CEST)
Received: from [192.168.0.126] (port=45612)
        by tnonline.net with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <forza@tnonline.net>)
        id 1mgjZC-000GC1-5s; Sat, 30 Oct 2021 10:18:18 +0200
Date:   Sat, 30 Oct 2021 10:18:17 +0200 (GMT+02:00)
From:   Forza <forza@tnonline.net>
To:     Adam Borowski <kilobyte@angband.pl>,
        David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Message-ID: <4ec3373.df69821b.17cd047293f@tnonline.net>
In-Reply-To: <YXwgRuMiS2OFYP8+@angband.pl>
References: <20211029155346.19985-1-dsterba@suse.com> <YXwgRuMiS2OFYP8+@angband.pl>
Subject: Re: Btrfs progs pre-release 5.15-rc1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Mailer: R2Mail2
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



---- From: Adam Borowski <kilobyte@angband.pl> -- Sent: 2021-10-29 - 18:24 ----

> On Fri, Oct 29, 2021 at 05:53:46PM +0200, David Sterba wrote:
>> The noticeable changes are in the mkfs defaults:
>> 
>>   * no-holes
>>   * free-space-tree
>       ^^^^^^^^^^^^^^^
>>   * DUP for metadata unconditionally
> 
> \o/ !!!
> 

I'd like to say that the new docs format over at readthedocs is really nice too! 

Well done! 

> -- 
> ⢀⣴⠾⠻⢶⣦⠀
> ⣾⠁⢠⠒⠀⣿⡁
> ⢿⡄⠘⠷⠚⠋⠀ An imaginary friend squared is a real enemy.
> ⠈⠳⣄⠀⠀⠀⠀


