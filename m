Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:55295 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab3CKPQg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 11:16:36 -0400
Received: by mail-ob0-f169.google.com with SMTP id ta14so3404509obb.28
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 08:16:35 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 11 Mar 2013 16:16:34 +0100
Message-ID: <CAFvQSYSONvdw7U+UZ_fxe-6=OALvWmaZiF=7+JE=vV0A6_z3uw@mail.gmail.com>
Subject: Creating zero-filled file aborts after 20GB in a 4GB volume with compress=lzo
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

When running ...

> dd if=/dev/zero of=testfile bs=1M

on a compressed btrfs volume of 4GB mounted with compress=lzo, dd
aborts after about 20GB written.

As I don't think this can be attributed to metadata consumed ... Any
ideas why lzo achieves such a poor ratio for even highly compressible
data?

Thank you in advance, Clemens
