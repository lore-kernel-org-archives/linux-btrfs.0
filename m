Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f169.google.com ([209.85.213.169]:44381 "EHLO
        mail-yb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752180AbeENIkU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 04:40:20 -0400
Received: by mail-yb0-f169.google.com with SMTP id m127-v6so3853782ybm.11
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 01:40:20 -0700 (PDT)
MIME-Version: 1.0
From: Dimitri John Ledkov <xnox@ubuntu.com>
Date: Mon, 14 May 2018 09:40:19 +0100
Message-ID: <CANBHLUjcAjvcA3BCn=i4VmDvKUcxSBk4_g3qp7Jw-k84sZXx5g@mail.gmail.com>
Subject: Clarification needed about libbtrfs & libbtrfsutil
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Are both of these meant to be public libraries, installed on the user
systems, and available in .so variant as well for 3rd party
development and public dynamic linking?

Or are these private internal libraries, which are installed as public
runtime only, simply to share code between the utils, but otherwise
provide no abi stability and will forever remain libfoo.so.0?

Or should these even be a noinst_ libraries (~= Libtool Convenience
Libraries), and are simply intermediate by-products?

I'm asking because despite compiling shared & static variants of these
libraries, and "shared linked" and "static linked" variants of the
utils, it appears that all utilities are statically linking against
libbtrfs/libbtrfsutils. Thus no binaries nor bindings, dynamically
link against neither libbtrfs nor libbtrfsutil.

Tweaking the makefile to use libs_shared variable instead of libs or
libs_static, results in slightly smaller binaries, dynamically linked
against libbtrfs/libbtrfsutil.

But it is hard to tell if this is a bug/mistake, or an intentional feature.

-- 
Regards,

Dimitri.
