Return-Path: <SRS0=zIgm=QV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AEB1C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 11:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B6AE2082F
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 11:37:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sheepa.org header.i=admin@sheepa.org header.b="hViQRnTG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436505AbfBNLhU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Feb 2019 06:37:20 -0500
Received: from sender-of-o52.zoho.eu ([185.20.209.248]:21350 "EHLO
        sender-of-o52.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388002AbfBNLhU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Feb 2019 06:37:20 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1550144237; cv=none; 
        d=zoho.eu; s=zohoarc; 
        b=fVDY6VbNViQ3UIYtqUteaSBq7EFZCZEPdBDQnGM3s1FC0cuk+TotL09Zu781kEkUqjRNWzhrAIuuFAsK6tlkwHWBiYpgCI2CYuFxfhWEYCPKZv9r0gKR0v5TYVVOaoDMERcyhqVMFb1bXnfAS2mrY81dHsG3o2Q5qkEADbOCt/k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.eu; s=zohoarc; 
        t=1550144237; h=Content-Type:Content-Transfer-Encoding:Date:From:MIME-Version:Message-ID:Subject:To:ARC-Authentication-Results; 
        bh=e6GliWTvmOWxy3ObRnC+itb1HIu6BrQgIWuHqj1soc0=; 
        b=SXSDgESFDkq/7VsL4Hz8xos6XycZ/sePuuJzlXSPlHTQVls7uPXd2gk10xUP3glBWv7MDWhBjjFWtRqp6W27yPUNO3FZ4wkGiS+Q5kdyjIxJjpeYQr5wVBF1zhzgWSgzMyzuMfPbo0rMcfvL0egp+OBbJSwl0qOduTZscns2OXI=
ARC-Authentication-Results: i=1; mx.zoho.eu;
        dkim=pass  header.i=sheepa.org;
        spf=pass  smtp.mailfrom=admin@sheepa.org;
        dmarc=pass header.from=<admin@sheepa.org> header.from=<admin@sheepa.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1550144237;
        s=mail; d=sheepa.org; i=admin@sheepa.org;
        h=To:From:Subject:Message-ID:Date:MIME-Version:Content-Type:Content-Transfer-Encoding;
        l=1461; bh=e6GliWTvmOWxy3ObRnC+itb1HIu6BrQgIWuHqj1soc0=;
        b=hViQRnTGYJaJNFH6yY+jVtfwhQHzixhAY4dCiq00pY0x/FppuWaQkhvhhCCmOkLh
        J6hzI++nXI3y4YxDQ3F8UWFX8omY2w6Qk/a/MbxPra61DMuAxizjI6ZJbsDRmOP0lx1
        Well7sPTSZRl1jlWs+Fqm1aMR0JNeNmdzgR9nKJQ=
Received: from [10.0.0.20] (195-198-161-213-no22.tbcn.telia.com [195.198.161.213]) by mx.zoho.eu
        with SMTPS id 1550144235087425.7095296113439; Thu, 14 Feb 2019 12:37:15 +0100 (CET)
To:     linux-btrfs@vger.kernel.org
From:   =?UTF-8?Q?Andr=c3=a9_Malm?= <admin@sheepa.org>
Subject: Btrfs send with parent different size depending on source of files.
Message-ID: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
Date:   Thu, 14 Feb 2019 12:37:16 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ZohoMailClient: External
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,

I'm not sure this is the right forum to ask on but I'll try and if its 
not I do apologize. I have also created a stack overflow question 
without success ( 
https://stackoverflow.com/questions/54634703/btrfs-send-with-parent-different-size-depending-on-source-of-files 
) but ill paste the question here too. Thank you.

What i'm trying to achieve is sending only the diff of the parent with 
btrfs send -p

Running this will produce a file 'out' with size 639 bytes, i.e only 
diff sent.

====================================================

btrfs subvolume create A
btrfs subvolume create B
mkdir A/dir

dd if=/dev/urandom of=A/dir/server.jar bs=1024 count=40K
cp --reflink=always A/dir/server.jar B/server.jar

btrfs subvolume snapshot -r A a
btrfs subvolume snapshot -r B b
btrfs send -p a b > out

====================================================

However if I change the dd command to wget like this:

====================================================

btrfs subvolume create A
btrfs subvolume create B
mkdir A/dir

wget -O A/dir/server.jar 
https://launcher.mojang.com/v1/objects/20c069d373e77265aaeeedb733f7051e294325a3/server.jar
cp --reflink=always A/dir/server.jar B/server.jar

btrfs subvolume snapshot -r A a
btrfs subvolume snapshot -r B b
btrfs send -p a b > out

====================================================


The 'out' file is 34M, which is the full size.

What causes this?


