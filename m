Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:32769 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751368AbdCZN65 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 26 Mar 2017 09:58:57 -0400
Received: by mail-yw0-f172.google.com with SMTP id v76so16932408ywg.0
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Mar 2017 06:58:22 -0700 (PDT)
MIME-Version: 1.0
From: Chris <coderight@gmail.com>
Date: Sun, 26 Mar 2017 09:58:21 -0400
Message-ID: <CAPaFLLTyWSkUOFTAhmfYMPEqWfCx7SxVNvhaHw9XwqD=NeGtEg@mail.gmail.com>
Subject: btrfs-progs clean is incomplete
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"make clean-all" leaves generated files under the "kernel-shared" directory.

This causes problems when trying to build under the same tree when the
absolute path changes.

For example if you mount the source tree in one location,
generate/build, then mount it in a different location, clean-all,
re-build, and an error appears. "No rule to make target
'.../kerncompat.h', needed by 'kernel-shared/ulist.o'.  Stop."  This
happens because the "kernel-shared/ulist.o.d" file was not cleaned and
lists an incorrect path.

Chris
