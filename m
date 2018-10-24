Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D86F8C004D3
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 15:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 336A72075D
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 15:03:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mail.ru header.i=@mail.ru header.b="P658LhRY";
	dkim=pass (1024-bit key) header.d=mail.ru header.i=@mail.ru header.b="P658LhRY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 336A72075D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=mail.ru
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbeJXXb7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 19:31:59 -0400
Received: from fallback20.mail.ru ([185.5.136.252]:56706 "EHLO
        fallback20.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbeJXXb7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 19:31:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru; s=mail2;
        h=Message-ID:References:In-Reply-To:Subject:To:From:Date:Content-Transfer-Encoding:Content-Type:MIME-Version; bh=kXz7vOh7FFEpDy0l57WJ6IEa7AsNCd1VsMRxaYPfH3M=;
        b=P658LhRY0Wu+OvZ5gn2DsVnPsvzliyyXPpTGrs59TusozMVw2qTOiaSU8RTcZCEPY2R2ArZ3BbSPZpoPiso2+1K+14E0SaGQ/knCUEqAPA3VK+B3eiupFcbhhkPwrwq2+kZ0MthGfVuo5i9RgyJXvovEkYlIfJYeXFhUVcJVowo=;
Received: from [10.161.8.33] (port=50362 helo=smtp14.mail.ru)
        by fallback20.m.smailru.net with esmtp (envelope-from <dma_k@mail.ru>)
        id 1gFKh0-0004Wh-08
        for linux-btrfs@vger.kernel.org; Wed, 24 Oct 2018 18:03:30 +0300
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru; s=mail2;
        h=Message-ID:References:In-Reply-To:Subject:To:From:Date:Content-Transfer-Encoding:Content-Type:MIME-Version; bh=kXz7vOh7FFEpDy0l57WJ6IEa7AsNCd1VsMRxaYPfH3M=;
        b=P658LhRY0Wu+OvZ5gn2DsVnPsvzliyyXPpTGrs59TusozMVw2qTOiaSU8RTcZCEPY2R2ArZ3BbSPZpoPiso2+1K+14E0SaGQ/knCUEqAPA3VK+B3eiupFcbhhkPwrwq2+kZ0MthGfVuo5i9RgyJXvovEkYlIfJYeXFhUVcJVowo=;
Received: by smtp14.mail.ru with esmtpa (envelope-from <dma_k@mail.ru>)
        id 1gFKgy-0003jv-48
        for linux-btrfs@vger.kernel.org; Wed, 24 Oct 2018 18:03:28 +0300
Received: from www.centurion.link (localhost [IPv6:::1])
        by centurion.home (Postfix) with ESMTP id DED19F23A99
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2018 17:03:26 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 24 Oct 2018 17:03:26 +0200
From:   Dmitry Katsubo <dma_k@mail.ru>
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Failover for unattached USB device
In-Reply-To: <dac5a4c5-e40d-a332-420f-f5517730a5f4@mail.ru>
References: <dac5a4c5-e40d-a332-420f-f5517730a5f4@mail.ru>
Message-ID: <3051750f58524cceed2a69fcf43bae31@mail.ru>
X-Sender: dma_k@mail.ru
User-Agent: Roundcube Webmail/1.2.3
X-77F55803: LRrXVehmsVRb9YmrEZN1K1Hbu3ZriRqctp4ZJCkgvf7G3QwvoolO6g==
X-7FA49CB5: 0D63561A33F958A5FA37D73298C3588AE210F425B66F0FD236A2807E4187C3608941B15DA834481FA18204E546F3947CEDCF5861DED71B2F389733CBF5DBD5E9C8A9BA7A39EFB7666BA297DBC24807EA117882F44604297287769387670735209ECD01F8117BC8BEA471835C12D1D977C4224003CC8364767815B9869FA544D8090A508E0FED6299176DF2183F8FC7C097A342136F30543A2E03817F3C3E88BC8594870E79453796B1593CA6EC85F86DAD7EC71F1DB88427E0C89D67371282C4CF19DD082D7633A0E7DDDDC251EA7DABD81D268191BDAD3D4E70A05D1297E1BB35872C767BF85DA227C277FBC8AE2E8BDA9D247E9FFFF00AFF69BA5D7DBC07CB35872C767BF85DA2F004C906525384306FED454B719173D6462275124DF8B9C9DE2850DD75B2526BE5BFE6E7EFDEDCD789D4C264860C145E
X-Mailru-Sender: 6DAAA20F2058E07D134D6D8D77B89E7F4B81FA0D7FAF572CE1AFB479B13BE71E9EF95AA7B19AEE03501E7C294F69090ED50E20E2BC48EF5AE609D43F356B221EEAB4BC95F72C04283CDA0F3B3F5B9367
X-Mras: OK
X-77F55803: 6Ns2ePE+8+ADfjlgolKFsH1Tlr7GOl1sDQiy/OfkAjDjMdHjzCcsTw==
X-7FA49CB5: 0D63561A33F958A58622913454648A369564D4B1DD6AF16EDEC8C2C8BCD2534D8941B15DA834481FA18204E546F3947CEDCF5861DED71B2F389733CBF5DBD5E9C8A9BA7A39EFB7666BA297DBC24807EA117882F44604297287769387670735209ECD01F8117BC8BEA471835C12D1D977C4224003CC836476C0CAF46E325F83A50BF2EBBBDD9D6B0F05F538519369F3743B503F486389A921A5CC5B56E945C8DA
X-Mailru-Sender: A5480F10D64C9005D917D4885F602B38AF1EFF4F77CD088C21DB3BD6CE55EA482841AB8488F6860D3BDEC02E5C93C5DB1C2ED716FDD6C8E1F935CE35D19D7009B4A721A3011E896F
X-Mras: OK
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2018-10-17 00:14, Dmitry Katsubo wrote:
> As a workaround I can monitor dmesg output but:
> 
> 1. It would be nice if I could tell btrfs that I would like to mount 
> read-only
> after a certain error rate per minute is reached.
> 2. It would be nice if btrfs could detect that both drives are not 
> available and
> unmount (as mount read-only won't help much) the filesystem.
> 
> Kernel log for Linux v4.14.2 is attached.

I wonder if somebody could further advise the workaround. I understand 
that running
btrfs volume over USB devices is not good, but I think btrfs could play 
some role
as well.

In particular I wonder if btrfs could detect that all devices in RAID1 
volume became
inaccessible and instead of reporting increasing "write error" counter 
to kernel log simply
render the volume as read-only. "inaccessible" could be that if the same 
block cannot be
written back to minimum number of devices in RAID volume, so btrfs gives 
up.

Maybe someone can advise some sophisticated way of quick checking that 
filesystems is
healthy? Right now the only way I see is to make a tiny write (like 
create a file and
instantly remove it) to make it die faster... Checking for write IO 
errors in "btrfs
dev stats /mnt/backups" output could be an option provided that delta is 
computed for
some period of time and write errors counter increase for both devices 
in the volume
(as apparently I am not interested in one failing block which btrfs 
tries to write
again and again increasing the write errors counter).

Thanks for any feedback.

-- 
With best regards,
Dmitry
