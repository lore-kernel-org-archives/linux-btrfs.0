Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:36088 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752163AbcILVc3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 17:32:29 -0400
Received: by mail-oi0-f48.google.com with SMTP id q188so221820558oia.3
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2016 14:32:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8dc76c71-aa15-8b9d-87e1-c21732a97779@gmail.com>
References: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com>
 <5440522.9CHaGU5Wjs@merkaba> <pan$238e8$d4dacca2$71255eb4$9f2e5ec1@cox.net>
 <CAK5rZE6X_m6wyTmqRZ8B3TTZsXtEtPT5TaanFfgXKycJoBfsTA@mail.gmail.com>
 <pan$10305$d0b1bd23$a49643ee$465d6f6c@cox.net> <CAK5rZE7SMLgPpe8tAQZ9qu=vm+3Gk=73L_h2+tOPEag-0tS0Bg@mail.gmail.com>
 <CAK5rZE7V46=y9is5rmD2HDV2d5MNMiWd++xUszgSqAOY5VQxsA@mail.gmail.com>
 <CAK5rZE55nTKh7u6B56MaGcoezmgOrbjrkzSt+WipcGO1mjEGsw@mail.gmail.com> <8dc76c71-aa15-8b9d-87e1-c21732a97779@gmail.com>
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
Date: Mon, 12 Sep 2016 22:32:27 +0100
Message-ID: <CAMU1PDgonwcpAtxPhOBQkoaGk8ev++GbL3p_JRAKB+FXKo0sTw@mail.gmail.com>
Subject: Re: Small fs
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12 September 2016 at 19:55, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> I'm not sure about gparted, but the default behavior for mkfs is as follows:
> 1. Is the device rotational? (check /sys/block/<device>/rotational).  If
> not, do some extra stuff to try and ID it as an SSD.  If it is an SSD, use
> SINGLE mode for metadata, otherwise use DUP mode for metadata.
> 2. Is the FS set for mixed-bg?  If so, use the same profile for data as
> metadata, otherwise use SINGLE mode for data.
>
> It would not surprise me if gparted switches to single metadata mode for a
> small enough FS, but I'm not certain.  I do think that they just use the
> default selection for mixed-bg though, which means not using it in current
> btrfs-progs versions.

GParted always just takes the mkfs.btrfs defaults.

https://git.gnome.org/browse/gparted/tree/src/btrfs.cc?h=GPARTED_0_26_1#n154
