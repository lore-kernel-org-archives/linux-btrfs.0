Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10904C5ACCC
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 14:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8F1A2098A
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 14:23:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sJOjw28I"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C8F1A2098A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbeJRWYu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 18:24:50 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:39599 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727951AbeJRWYu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 18:24:50 -0400
Received: by mail-wm1-f54.google.com with SMTP id y144-v6so493012wmd.4
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2018 07:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=xsxTHjO2BOsV/iwoi1x5roYwD9RijK9xpj/3LzV6omk=;
        b=sJOjw28IGb279eJYNZ4R0vOC64ZMiIu+2U+aCpkdq4LnE1SiTkcnfscKiYNyM1JHCj
         lf5zVGO68NMnSO5ocN3UGwfbehY08SKuo9HbJnVBJ7s1gNF3ZRZ024f0nxn1yqJcNA8l
         2RnYA1Y2gx0NVhT4V04mGirH44HSxKnbiVoEqlUpx4kqUJOs2gjsTahXqI8Nui23Ba87
         Q4mCWnE2YslW5povbX9xwPzeyNxT7YKIJMgokMHYPMWSKLaE1VFpf5WhO4UqlXX5DAea
         EU3Q40m7N1aRI0l/XxFSig5RtrRoMxbOTge71GXxGEiyG+kPSXMDrUqKE1o96LFa2+Aj
         Fi6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=xsxTHjO2BOsV/iwoi1x5roYwD9RijK9xpj/3LzV6omk=;
        b=VjopwbqNf4ejfcxmRYE3LoGc3hHX0rvoUzdTj7Xl1OSARRziUmfLRM635zp9PizFiK
         44j3mAyr6jLpBeImv0Dmp5TVb03ViZ0HI1BSrByGhJjSJRp/vpmBdUrsodXgkWL6h4/F
         bwBhwXKhoQ8F98R4KzVqzCXXcX9Y9sahOinTcFZ60fo0i4DvrjO8WtKWyek1b9669YVD
         zvSHjbkZexddhFZ2B68EXfbWAeF3z3BB8CKg9N/ArJw/nBII7PDd0FVWeGNy5B0Uvvta
         HhCTLoegoglrYa1RCVtkffXjDWI4p6kKUMq6aMIfbb/DkUu15gKyHEBnUDK0b/jSr8jD
         oDnQ==
X-Gm-Message-State: ABuFfojPfmPtLgHoQrP/2YpyC0AEa1D5mAcwzhOYHt5ANjMu/p4ct2E5
        YRQMgttezdX5fEMN8Vb4nHG1kD59
X-Google-Smtp-Source: ACcGV621gQEiaDPsfe42TbVyf4vXJWx29rYs2vbogsnTyioAzfmCKoi13Zz30W04NrVjFebYCjnPPw==
X-Received: by 2002:a1c:f010:: with SMTP id a16-v6mr517747wmb.5.1539872614413;
        Thu, 18 Oct 2018 07:23:34 -0700 (PDT)
Received: from [192.168.88.253] ([78.92.233.200])
        by smtp.gmail.com with ESMTPSA id t198-v6sm494044wmd.9.2018.10.18.07.23.32
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Oct 2018 07:23:33 -0700 (PDT)
To:     linux-btrfs@vger.kernel.org
From:   =?UTF-8?B?SGVneWkgTMOhc3psw7M=?= <laci200270@gmail.com>
Subject: Backref error
Message-ID: <617f3ee8-7f11-4f27-87f1-31957e6bf5de@gmail.com>
Date:   Thu, 18 Oct 2018 16:23:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello guys!

I have a 2TB disk formatted to btrfs.My notebook broke last may, so I 
haven't used it in a long time, only to backup a few files, but from a 
windows pc(using windows btrfs driver), and maybe (i don't remember) put 
a few files to the disk.Then my thinkpadlinux-btrfs@vger.kernel.org 
arrived, and tried to backup from my ssd from the reinstall.Got some 
random error, after a few hours of reading random forum posts I resolved 
it with zero-log.The error occurred a few times, always resolved it with 
zero log.Then yesterday i tried to write to it got a different error( 
https://pastebin.com/ZxNWaFX8 ) tried the usual zero log didn't helped, 
okay forum post reading suggested to do btrfs repair 
--init-extent-tables now that command is running utilizing one of my CPU 
cores 100% and only doing I/O access once in a few minutes(according to 
the HDD caddy indicator).Dev stats didn't say any errors, nor btrfs 
repair only a space cache mismatch https://pastebin.com/eJh4EBx9 any 
ideas? Also shall I cancel the init extent trees or just wait until 
finishes?And how much time shall it take?It spams my console output like 
this https://pastebin.com/6LjjXuin. Thank you for all of your help and 
sorry if my grammar is bad my native language isn't English

