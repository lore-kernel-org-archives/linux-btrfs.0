Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D64C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 15:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 592FC20865
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 15:01:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NiHFJzLt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 592FC20865
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbeK0B4G (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 26 Nov 2018 20:56:06 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41274 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbeK0B4G (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Nov 2018 20:56:06 -0500
Received: by mail-ed1-f68.google.com with SMTP id z28so16087654edi.8
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 07:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding:user-agent;
        bh=gf18HhMxdT+FROsh2UneG755TVessAjLPkoZxQaTp2c=;
        b=NiHFJzLtguCDiTwHlj+iQDqjMIBSgO90wLXEDFZgUEzp3jKW3h1xs87CcM+pS+vJGl
         nou0lfyF1RZy6uBXdrYjiNRXbDowdJu9kU6JgkGSNoesk7HP/6BDbsg2VEaDTiTKY73z
         2kyOMC0w6cec4Dyhqc2IiBW5UnKWg+d5u7GjKa5UHqZzvc5KHI5afr4jjGXiQyri0MDm
         HXengmetWKwXR+h9jaTCPhX0MmwJQ8htci/pFQ+CjoJO5pdKiUDfpQ7UEGWg/sg9p2FV
         /V353GlywLA2uX5kGqpeA3l9i2uqbt5y57dyPIGT3GystPANffCYZOHlElP7DRLT0C0a
         CJHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:subject:message-id
         :mime-version:content-disposition:content-transfer-encoding
         :user-agent;
        bh=gf18HhMxdT+FROsh2UneG755TVessAjLPkoZxQaTp2c=;
        b=CouX+uEgiVTiMWDLTtLhsM0YR0kxvdl46JOMzftBl0NnKWfifsTt+bAesJDqbXI/a7
         MAH22VY+eaf5vd44Y8+H8CWyy4HhB9IFdX5qNMQqUuE11sCvv1dOb5KAbBNOJh9jvyGu
         ACfO+K0ZM9OVoxDrG2nmiKIgJ5fbctfVEXlWqIQCNbTXooiiGOsTXCZMrcjt40aAaFzD
         niFo/I/mXU6QA1sZVM2KU0FO2mKKa6gcFGouqRnb6td0FplE9Od2z1sq9S4axkOWjhdT
         yXrl6WeAAtQ8w4tinjUUnfRecmz+YJAfwRzarX2UsrU3Mv4EA+KyDwRNizHqwIAxW005
         H38A==
X-Gm-Message-State: AA+aEWYY5iZceCEenm7zGOLVY/pPKOKFjie0/XqgjuYu63Ut19Rj6tS/
        h2XtDGVnMiEZVXMji2fSguv21ko5AO4=
X-Google-Smtp-Source: AFSGD/WHZ3pAnNHkrLuPj/1R7l1ivN5+ttQHjLH0ZPRuzi9zugGDpxL+6HJJQyJnoebK49ccRlduzw==
X-Received: by 2002:a50:bdc8:: with SMTP id z8mr16861574edh.46.1543244501948;
        Mon, 26 Nov 2018 07:01:41 -0800 (PST)
Received: from glet (anon-38-203.vpn.ipredator.se. [46.246.38.203])
        by smtp.gmail.com with ESMTPSA id v20-v6sm135922ejr.46.2018.11.26.07.01.40
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 26 Nov 2018 07:01:41 -0800 (PST)
Date:   Mon, 26 Nov 2018 16:01:37 +0100
From:   Andrea Gelmini <andrea.gelmini@linux.it>
To:     linux-btrfs@vger.kernel.org
Subject: Linux-next regression?
Message-ID: <20181126150137.GA16029@glet>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi everybody,
   and thanks a lot for your work.

   I'm using BTRFS over LVM over cryptsetup, over Samsung SSD 860 EVO (latest git of btrfs-progs).
   Usually I run kernel in development, because I know BTRFS is young and there are still lots of bugs and corner case to fix.

   Anyway, I just want to submit to you a - maybe - useful info.

   Yesterday I compiled and booted latest linux-next,¹ and I've got this:

-----------
nov 26 01:18:22 glet kernel: Btrfs loaded, crc32c=crc32c-intel
nov 26 01:18:22 glet kernel: BTRFS: device label home devid 1 transid 32759 /dev/mapper/cry-home
nov 26 01:18:23 glet kernel: BTRFS info (device dm-3): force lzo compression, level 0
nov 26 01:18:23 glet kernel: BTRFS info (device dm-3): disk space caching is enabled
nov 26 01:18:23 glet kernel: BTRFS info (device dm-3): has skinny extents
nov 26 01:18:23 glet kernel: BTRFS error (device dm-3): bad tree block start, want 2152002191360 have 8829432654847901262
nov 26 01:18:23 glet kernel: BTRFS error (device dm-3): failed to read block groups: -5
nov 26 01:18:23 glet kernel: BTRFS error (device dm-3): open_ctree failed
-----------

   Now, rebooting with 4.19.0-041900 (downloaded from here)², or 4.20-rc4 (compiled on this machine), the problem disappears.

   Now, running scrub a few times, and copying data (all files of the logical volume) to external device, gives no complain.

   Here I stop. This is my primary dev laptop, and at the moment I can't spend time switching/rebooting/testing. I'm comparing the data with last backup (I rsync each hour), but it takes time (it's more then 3TB).

   So, that was about to let you know. Well, it's Ubuntu 18.10, and between reboots no dist-upgrade or changes in booting related packages or systemd.

  One question: I can completely trust the ok return status of scrub? I know is made for this, but shit happens...

Kisses,
Gelma   

-----------------
¹ commit:  8c9733fd9806c71e7f2313a280f98cb3051f93df
  "Add linux-next specific files for 20181123"
² http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.19/
