Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04D10C04AA5
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 15:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE0D52089D
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 15:05:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tM5IguhJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE0D52089D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbeJOWv2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 18:51:28 -0400
Received: from mail-lj1-f179.google.com ([209.85.208.179]:42864 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbeJOWv2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 18:51:28 -0400
Received: by mail-lj1-f179.google.com with SMTP id y71-v6so17805478lje.9
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Oct 2018 08:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=d/JWVEbgV7k6cu9v6STD2gDYhh2WS9k8L/l3JIDBDLA=;
        b=tM5IguhJDDIwEJ+ZOdY5XjdXMYi2f1DcN63MAyzNiMH1pUJQVJTjfseBwgq9lR+jcB
         XOe2zJirfAXLo5xOOJBLJOd1BsVUdeSaYqpB68zvozQ0A8YMWwpKeNXuQ2iV9LxNudiA
         qhvTqoyM15gtPAiyn/gWFtPHVyO34Glmm7reinSmVg0Ja4FKAlyplv4YbMRMFE904/wI
         6tulSG5mZYKLVil4iRSQtsPdcfhWMUB2HydmJgdcktFnO0TBk5zrjXLDx1G2Q2YCq8Jg
         aAsZUFokJaWuYlYk5nWRrQcd1mGRzVx/15iBPpDUWW3KtuuoRn4xP+OdKZpLM/KI936r
         133Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=d/JWVEbgV7k6cu9v6STD2gDYhh2WS9k8L/l3JIDBDLA=;
        b=YluVElowOnfDuswGf+G2VLfaEAhRnvWl8gY3Y0QYkSowsg56qjNCC+875dgrFDPlGz
         TXwwkSAmmkqPKszxpVg+C5csOVxiPfLp/mlD7gcN0kIL+BLf3xPeZF4EbUc4QLC6nRnE
         tc+fSt0OSHDsDLYhr7aa1gMXNBTUoJR+VieC4GEd+paq0BtiipzaEDc+ee8291zYqU3I
         xV8BGRaLGZ444Z5AMlHQb7/JTVTA4o4S/VCzhA+Tg4WLGMZxHNmOoSxzl14R9Cc1qhsZ
         x6ZmfTuCs4SdulHULGS74yU0AbrDb1e55ubk6pcYhZOGs2ny7nuUODNyw1fRMCufGBYB
         dGmQ==
X-Gm-Message-State: ABuFfohFmgZ/6i/o7qujt+D2VUfST053CKqm23yOSTHgwr5pOANBHFUY
        9ggGUMVoQscGCYwuCN1Uas8XwhJt
X-Google-Smtp-Source: ACcGV62OOximGw63ng66gmmMQEi8P/3Eypn+ApFwCRfQ6F2Y3+o+5hBNnQ99deftGJi2PaXKGXFtfA==
X-Received: by 2002:a2e:4502:: with SMTP id s2-v6mr11367924lja.44.1539615947648;
        Mon, 15 Oct 2018 08:05:47 -0700 (PDT)
Received: from erp07.git.ru ([94.79.3.84])
        by smtp.gmail.com with ESMTPSA id p21-v6sm170952lfj.94.2018.10.15.08.05.46
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Mon, 15 Oct 2018 08:05:47 -0700 (PDT)
Date:   Mon, 15 Oct 2018 18:05:46 +0300
From:   Anton Shepelev <anton.txt@gmail.com>
To:     linux-btrfs@vger.kernel.org
Subject: Spurious mount point
Message-Id: <20181015180546.4dd598bf0fe61b61f56e99ce@gmail.com>
X-Mailer: Sylpheed 3.5.0 (GTK+ 2.24.23; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello, all

How can I track down the origin of this mount point:

   /dev/sda2 on /home/hana type btrfs (rw,relatime,space_cache,subvolid=259,subvol=/@/.snapshots/1/snapshot/hana)

if it is not present in /etc/fstab?  I shouldn't like to
find/grep thoughout the whole filesystem.

-- 
()  ascii ribbon campaign - against html e-mail
/\  http://preview.tinyurl.com/qcy6mjc [archived]
