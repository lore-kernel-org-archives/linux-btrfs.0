Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:35737 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751260AbdHDWKZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Aug 2017 18:10:25 -0400
MIME-Version: 1.0
In-Reply-To: <20170804201921.156890-5-terrelln@fb.com>
References: <20170804201921.156890-1-terrelln@fb.com> <20170804201921.156890-5-terrelln@fb.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 4 Aug 2017 15:10:23 -0700
Message-ID: <CA+55aFyqFWbEG+jYyWjbA0=rm+u7Nm++psPfC_e+oMbgBYC33w@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] squashfs: Add zstd support
To: Nick Terrell <terrelln@fb.com>
Cc: "Austin S . Hemmelgarn" <ahferroin7@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        kernel-team <kernel-team@fb.com>, Chris Mason <clm@fb.com>,
        Yann Collet <cyan@fb.com>, Adam Borowski <kilobyte@angband.pl>,
        David Sterba <dsterba@suse.cz>, squashfs-devel@lists.sourceforge.net,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Phillip Lougher <phillip@squashfs.org.uk>, Sean Purcell <me@seanp.xyz>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 4, 2017 at 1:19 PM, Nick Terrell <terrelln@fb.com> wrote:
>
> This patch was written by Sean Purcell <me@seanp.xyz>, but I will be
> taking over the submission process.

Please, if so, get Sean's sign-off, and also make sure that the patch
gets submitted with

   From: Sean Purcell <me@seanp.xyz>

at the top of the body of the email so that authorship gets properly
attributed by all the usual tools.

             Linus
