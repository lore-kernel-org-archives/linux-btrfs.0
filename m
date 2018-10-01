Return-Path: <SRS0=adn4=MN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5430C00449
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 14:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82695213A2
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 14:32:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FW5CsW1W"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82695213A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729469AbeJAVKi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Oct 2018 17:10:38 -0400
Received: from mail-ed1-f50.google.com ([209.85.208.50]:45782 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729415AbeJAVKh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Oct 2018 17:10:37 -0400
Received: by mail-ed1-f50.google.com with SMTP id h6-v6so12926119eds.12;
        Mon, 01 Oct 2018 07:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=lu454d2eCTucjk1GkUq1mbrmq9ALQ1DYXXyXmi4DwKU=;
        b=FW5CsW1WaMQRB3mjKr9YwptHmABXGLwiLBSYFAz1FaUiKnGvGZlOdQ7hPo4ajE/Fb9
         /xTObXWarwK7dIOAKNHHDnaGYO2Il3ch9+yRu9jUjt5o9oiWi8zqJkyE1TGbSNyboJkA
         egvIxZUI0zPm4WVtZzb5my72hsPy7SMh9CTFWLlyNhpWr78Xs7EIQiCzJJNh/fphLHtL
         hie9UIzsXtoKLS2kqpvPJJKhzeqT/jdQi9Q4HIKpnllzENoikFtWie8GULH12VYCRxXu
         sS756FGmho7kCL5qE0Zmo0i+JPpOxZUzd2GMGncQpBNDYJh0KInKY/wfYNuw/jAddCX3
         pcpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=lu454d2eCTucjk1GkUq1mbrmq9ALQ1DYXXyXmi4DwKU=;
        b=DkhJgLzh16VSJyFwG2zNQGYHH/DW9K5/+2BqRbU67seCJSkGs9kLXA4nXWN10SesIL
         3/G44N20VU9kVIJTayk4+nP6r72Nb2xCMGTjNqFI1YvMR+Qa+8uiBGL7uElICqfjAeV7
         1TpzIihmQqhMrGsZ3tyw5V0baXaPSB4OZftDgqcIyOULb158iZEoHvqF8uOkQhPvIt6J
         NsmSpQ74dRg11e11pJBkZg1jZInhZRjXjKPCghYAo0OFO1V8wnNjY7CL+Qq0KtNJW6F7
         3zorF/hL4t/3tSellEqr4XrPf3XfDFWxBcOJwi1DSzdwMZrrW/oTXJpza/CwHknElo9y
         r+6g==
X-Gm-Message-State: ABuFfoizw35QFUqEEOYU4UoCeoOHoU6fDkPHnrUv8CjGP2eAqiGW7Xxr
        6RjVme4K761ptvHUlRBgliN9vd32bGyaviRwp89hi6u/
X-Google-Smtp-Source: ACcGV63s7BCkONvrhgNUCmC8boYbJj1HHpQXOtBk99ois+cXfWOp+bITs56u8OmeI4hWWlEENo7iZzU3oCaO8sNBnYk=
X-Received: by 2002:a50:de03:: with SMTP id z3-v6mr18077176edk.245.1538404349334;
 Mon, 01 Oct 2018 07:32:29 -0700 (PDT)
MIME-Version: 1.0
From:   Joshi <joshiiitr@gmail.com>
Date:   Mon, 1 Oct 2018 20:02:17 +0530
Message-ID: <CA+1E3rLXPwzfO3ro49ZVg7RfpYon5YDB6Y_zqu60ivpgn4wenw@mail.gmail.com>
Subject: cross-fs copy support
To:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I was wondering about the cross-fs copy through copy_file_range.
It seems current implement has below check, that disables such copy.

1577         /* this could be relaxed once a method supports cross-fs copies */
1578         if (inode_in->i_sb != inode_out->i_sb)
1579                 return -EXDEV;

May I know what are the thoughts behind disabling cross-fs copy?
Code has the comment "once a method supports", but that leaves me
wondering exactly what 'method' is expected, and from whom.

I disabled the check, and copy across volumes seemed to work fine. At
least for a single file (1G size), with no data mismatch, and faster
speed than regular copy.

-- 
Joshi
