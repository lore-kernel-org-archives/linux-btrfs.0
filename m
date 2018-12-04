Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0501C04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 03:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DAC22146D
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 03:32:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BJaVU+Iy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5DAC22146D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbeLDDcc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 22:32:32 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:45511 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725968AbeLDDcc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 22:32:32 -0500
Received: by mail-io1-f66.google.com with SMTP id o5so6416145iop.12
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 19:32:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=SuIORGHmB7rTU9RAQwEY1Fv6BJWqcH0jWWE/r9jpsNM=;
        b=BJaVU+IytLZkiTl5x7HJTi+jfi+6/mL/u7IG3CgRgaib+Z5Q59/GJZTpS6W8imO/2g
         V0hqdZUWGcnLe/vl1uVk+mUZxJKyEuFBv+SiaQV6sW7KqpF6eQNeOwoNBer2Z+BmZXLF
         ZYALSYQSVBnArqkZJJ6ictgrNrBqlY1/TgXw8KlW5Hg2vvW3DMoLhx23GB605zaZDYXY
         7oZphvgfhQa/C/XcFnOXYkJmHwxZZfPLJKM54WGfdMZ9rUDjbOfyj7ri82yH8cIK7qn+
         r06DCUoG7zi6crX0Eq6TcmtCnDuDV4trfRRyl4bJNuJt9C0j1OeCQ4f6RxSIICVebDHm
         1jLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=SuIORGHmB7rTU9RAQwEY1Fv6BJWqcH0jWWE/r9jpsNM=;
        b=qMYWsnW6O/4fk9vADr1iLVOzTT8LbzB498kkKJTqpdrQX2Rydr6kEAxd4NK3W7+97N
         X39NARnNCyVp3atYufVV6UnngObeMNCp2Qqy9ouOzxweJ+S9j1LDhor8DK+4BzOP1OrS
         QEvD/FMHErluWF37wwStSNplkRCgK3WVparVnVeiFxlJlht3Hq0Q0b2SrDKqVqTXEu0T
         +vDDwjxr5yWGuCDls1CFvJ5WCJxhO/H+mgN/0J0hihgCX7+K8uI8H2lHVzRWIXabOYla
         NwT4wkGeBd2qvJPvQRHSwBOpYpXHC95YqeT7Psx33hxBh48KkTiApx5Rdc2QtOvrtpvT
         D0ag==
X-Gm-Message-State: AA+aEWbj7iknQuUGlMeDejJddUuy4l2R8w+ofnXSBnRZ66uYW2Sd29dN
        2OPTiK6538f8tACn1zIzYRTGMVqLVqfVR0BcVLHBOCyP3+U=
X-Google-Smtp-Source: AFSGD/WsGxLiOlw7fVeJlOkWs1gGH0lFcq5NP5Qd8YiDGZuk9ux0ABo5RcEco2bCpnr++M+dGXzNXs0dpNwPdOv95js=
X-Received: by 2002:a5d:9317:: with SMTP id l23mr3520181ion.110.1543894351031;
 Mon, 03 Dec 2018 19:32:31 -0800 (PST)
MIME-Version: 1.0
From:   Mike Javorski <mike.javorski@gmail.com>
Date:   Mon, 3 Dec 2018 19:32:20 -0800
Message-ID: <CAOv1SKD46XeF=iqi4At-0YJpK6nHQ+3ErKDN_sW_4fAPMyAgMw@mail.gmail.com>
Subject: Ran into "invalid block group size" bug, unclear how to proceed.
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Need a bit of advice here ladies / gents. I am running into an issue
which Qu Wenruo seems to have posted a patch for several weeks ago
(see https://patchwork.kernel.org/patch/10694997/).

Here is the relevant dmesg output which led me to Qu's patch.
----
[   10.032475] BTRFS critical (device sdb): corrupt leaf: root=2
block=24655027060736 slot=20 bg_start=13188988928 bg_len=10804527104,
invalid block group size, have 10804527104 expect (0, 10737418240]
[   10.032493] BTRFS error (device sdb): failed to read block groups: -5
[   10.053365] BTRFS error (device sdb): open_ctree failed
----

This server has a 16 disk btrfs filesystem (RAID6) which I boot
periodically to btrfs-send snapshots to. This machine is running
ArchLinux and I had just updated  to their latest 4.19.4 kernel
package (from 4.18.10 which was working fine). I've tried updating to
the 4.19.6 kernel that is in testing, but that doesn't seem to resolve
the issue. From what I can see on kernel.org, the patch above is not
pushed to stable or to Linus' tree.

At this point the question is what to do. Is my FS toast? Could I
revert to the 4.18.10 kernel and boot safely? I don't know if the 4.19
boot process may have flipped some bits which would make reverting
problematic.

Thanks much,

- mike
