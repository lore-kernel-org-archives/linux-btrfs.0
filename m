Return-Path: <SRS0=RPoL=3J=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8919BC2D0DB
	for <linux-btrfs@archiver.kernel.org>; Mon, 20 Jan 2020 14:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C2C322464
	for <linux-btrfs@archiver.kernel.org>; Mon, 20 Jan 2020 14:45:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xg+fnweA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgATOpv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 20 Jan 2020 09:45:51 -0500
Received: from mail-vk1-f171.google.com ([209.85.221.171]:43289 "EHLO
        mail-vk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbgATOpv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Jan 2020 09:45:51 -0500
Received: by mail-vk1-f171.google.com with SMTP id h13so8610459vkn.10
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jan 2020 06:45:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=6v7pXguHzfkmZyMAkQcUYz49zk1QHgEri+hsKiwLVdU=;
        b=Xg+fnweATkdEiyyxTCxwxYi1ta0d3uCiCur1o2bzROlBnFehVuYh60h1Tk6LN0OKAO
         BOtElI5rtZy7TccGMkJ7Lbpy8XaF2Mkzq6Cnq7tXEJvP7DOVD4lgFk/FOg5T7SztE/GG
         3wVg8JCCo0XJBN+kpuOvuGYIYAABxUWroYykQzNxcAdf6J7HbRxKUO9SXWIMi96G2tvj
         HA2t/HEh01chxd7t88lpAT8pFxTsrX0GoTmoEy1t8P8M66zURxQgsNYgqyGLbWxpmYLb
         6sIB2HHkKGpIZ7l6CIAMKRYN0uVxjEJtjFUs+hwHFM/lWEtNUj6mBO2p6EpOFfWm0zJZ
         ZpjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=6v7pXguHzfkmZyMAkQcUYz49zk1QHgEri+hsKiwLVdU=;
        b=Hv5j30SCfhk44tUobubHRyIoUV5o43ogZwnz1J7F2LCtHy4xKL4IFEnPDI8kvYicIM
         /fU4WtFOdHRllejl9ZXXEAzuDdbYTPBJDlvrDtXQ8zgXR+Owv40kmuRnVGDYd2K3Srvc
         Zz6u84Bjvm8WrKSzzjo6qYEcZG0RSh5yN6RJfMYFqQ1/+4n5zmyrBOnCf++2Y0HHoLzb
         oY0f5HDsPZqRXiZNs8X/wj5ao9hdnZuHtQp1BC1ct0t8aYbZdMJFaZBSkORkD5/5S7lF
         WDZHy4Tcvwl1WoXtlzLfqqz9hodRxTzbvyzUyPo2xcbSXAMZDUwpapj1KK+XhztcXbPJ
         gdFw==
X-Gm-Message-State: APjAAAXXe8l0lm1DMc7Dqzyt8XxyDh9bOXOoeN9epesr6EPrWqp1Gcyr
        tY+LuC+UrqfP0qb8GvLTop0utzBRijwnxOWCAMisi5dK6Ds=
X-Google-Smtp-Source: APXvYqyXp2qehtbD3EwXc4ezOUQPLZqV7LuquXe9PBgU9d4O2cR7guogSQPTUkOkfqEGX3HFvAGC6pkyCKth+kmBGSM=
X-Received: by 2002:a1f:bf86:: with SMTP id p128mr1126301vkf.3.1579531549644;
 Mon, 20 Jan 2020 06:45:49 -0800 (PST)
MIME-Version: 1.0
From:   Robbie Smith <zoqaeski@gmail.com>
Date:   Tue, 21 Jan 2020 01:45:38 +1100
Message-ID: <CACurcBus8d2RYTtVOheAvJcohY5jmP=akKUw1hen5seccfGihA@mail.gmail.com>
Subject: BTRFS failure after resume from hibernate
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I put my laptop into hibernation mode for a few days so I could boot
up into Windows 10 to do some things, and upon waking up BTRFS has
borked itself, spitting out errors and locking itself into read-only
mode. Is there any up-to-date information on how to fix it, short of
wiping the partition and reinstalling (which is what I ended up
resorting to last time after none of the attempts to fix it worked)?
The error messages in my journal are:

BTRFS error (device dm-0): parent transid verify failed on
223458705408 wanted 144360 found 144376
BTRFS critical (device dm-0): corrupt leaf: block=3D223455346688 slot=3D23
extent bytenr=3D223451267072 len=3D16384 invalid generation, have 144376
expect (0, 144375]
BTRFS error (device dm-0): block=3D223455346688 read time tree block
corruption detected
BTRFS error (device dm-0): error loading props for ino 1032412 (root 258): =
-5

The parent transid messages are repeated a few times. There's nothing
fancy about my BTRFS setup: subvolumes are used to emulate my root and
home partition. No RAID, no compression, though the partition does sit
beneath a dm-crypt layer using LUKS. Hibernation is done onto a
separate swap partion on the same drive.

This is the second time in six months this has happened on this
laptop. The only other thing I can think of is that the laptop BIOS
reported that the charger wasn't supplying the correct wattage, and I
have no idea why it would do that=E2=80=94both laptop and charger are nearl=
y
brand-new, less than a year old. The laptop model is a Lenovo Thinkpad
T470.

I've got backups, but reinstalling is a nuisance and I really don't
want to spend a couple of days getting the laptop working again. I
don't have a conveniently large drive lying around to mirror this one
onto.

Robbie
