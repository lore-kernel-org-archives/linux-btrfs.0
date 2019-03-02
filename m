Return-Path: <SRS0=BAu1=RF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FCA8C43381
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Mar 2019 00:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 321822083D
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Mar 2019 00:20:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="UHsxFh6v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbfCBAUP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 1 Mar 2019 19:20:15 -0500
Received: from mail-lf1-f53.google.com ([209.85.167.53]:41573 "EHLO
        mail-lf1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbfCBAUO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Mar 2019 19:20:14 -0500
Received: by mail-lf1-f53.google.com with SMTP id y7so4587571lfg.8
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Mar 2019 16:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=nEsltv2MQW+vjpc+d+Kg3eNXydeVoFw6PN+rDC+effM=;
        b=UHsxFh6vAyEF0jF0bIk0iWY5/muXAFf3GcIZaQjnBonODLS5n0TGk8sYLy81F4Ip8B
         1f97Ih47S7QwPjq5HdAqo41FxWKJ9E50D1YW24rQoVr3qWPkp5lbaJNtnCtffo03nxJa
         bj+fg23CiOqzVHW2gW2EDbvRl4WD92g9+jhDGyVM9tqneIOcJFQ1kqXdPF6BHcdkqjGn
         aLPt+PQE7Eq4dcX6a13FmurLveMZ9rg8h7Ca+em5wZQGCEBG1djrtepWsJOZxsCNIKjY
         /vrHfFivs1nY/padS2mhf6VwIvHH+8FmfvA1+Tuv3CMFQYAvrCoGhdrf3ybWTSN2CNt7
         Bl/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=nEsltv2MQW+vjpc+d+Kg3eNXydeVoFw6PN+rDC+effM=;
        b=sGqxaEgSIZGfDQ8h+DYFRtKg+dCwTJgZOYE/9JCdStx+LCcNoRHB9KfXeSvn0JPZZf
         skuVzmwh9vUXYlUCEk8fZZgHssYaSpHUAzHmzxvpoDgjvpjWOIJxHXyHngslydaLWEr2
         MC9thEuhpGL7REfL7paW2voJyraI8+ME36D4WuSGGV8i2ZpFFSRnyZy3LTYHEqHv9GNS
         Wiusa08xsq2khJwvOW2BCXcEb821eeUPS27h0TG1tx20vZ0+G7YaqLdYq7M2DH8DDomU
         0LUdfOf4FIK8f3u02gsh5hoi+l3TKHV6h08UIBepnXAWGh5QNWAMSzL3dGcJ83A/BJdw
         +cIQ==
X-Gm-Message-State: APjAAAWszfzHuyW4t/zExrbIk7xeDAQjaZSa3KGYW/ZWWZ12K2QZUnFq
        50Ab+3dHx0am6wkdIBxKBB7pqoKsVa1ihZ1/rj9SYAJSe9DMyQ==
X-Google-Smtp-Source: APXvYqw58akH6QUxDQggyafup5WhyTYkYQwpEDzhtR8f6Je19qzjWFZ8XU1Mzprj7OY3lJsG8EahhX2Q1Pn2OMlLsJ0=
X-Received: by 2002:a19:a98f:: with SMTP id s137mr4611956lfe.18.1551486011340;
 Fri, 01 Mar 2019 16:20:11 -0800 (PST)
MIME-Version: 1.0
From:   Chris Murphy <lists@colorremedies.com>
Date:   Fri, 1 Mar 2019 17:20:00 -0700
Message-ID: <CAJCQCtQrLLpX8uZwp2BYfgaF1QPfuf1_XRjVxG24cbDHfEo2uA@mail.gmail.com>
Subject: [bug] btrfs check clear-space-cache v1 corrupted file system
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Problem happens with btrfsprogs 4.19.1

https://bugzilla.kernel.org/show_bug.cgi?id=202717

That bug report includes the trace in user space; but I've also
processed the resulting coredump file with gdb and attached that to
the bug report.

Before using --clear-space-cache v1, btrfs scrub and btrfs check came
up clean no errors. Following the crash, I compiled brfsprogs 4.20.2
and ran 'btrfs check' which finds corruption.

I've taken no further action, and the btrfs check output gives me no
useful plain language information what the next steps are. So I'm just
gonna leave it alone since it's a backup volume anyway.



-- 
Chris Murphy
